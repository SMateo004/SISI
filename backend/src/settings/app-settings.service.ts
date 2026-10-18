import {
  HttpStatus,
  Inject,
  Injectable,
  Logger,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AuditHook } from '../audit/admin-audit.service';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import type { Env } from '../config/env.schema';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { SETTINGS, type SettingKey, settingDef, validateSetting } from './settings.catalog';

const VERSION_KEY = 'settings:version';
const SCOPE = 'global';

export interface SettingView {
  key: SettingKey;
  group: string;
  label: string;
  help: string;
  kind: string;
  unit: string;
  min: number | null;
  max: number | null;
  value: number | string;
  defaultValue: number | string;
  overridden: boolean;
  updatedAt: string | null;
}

/**
 * Parámetros de negocio desde app_settings (ADR-0043). Lectura sincrónica desde una copia en
 * memoria: el valor guardado por el panel o, si no hay, la variable de entorno. Cada proceso
 * (API, worker, cron) recarga la copia cuando cambia la versión en Redis (cada
 * SETTINGS_REFRESH_MS) y el que escribe la recarga de inmediato.
 */
@Injectable()
export class AppSettingsService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(AppSettingsService.name);
  private values = new Map<string, { value: number | string; updatedAt: Date }>();
  private version: string | null = null;
  private timer: NodeJS.Timeout | null = null;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async onModuleInit(): Promise<void> {
    await this.reload();
    const every = this.config.get('SETTINGS_REFRESH_MS', { infer: true });
    this.timer = setInterval(() => {
      void this.refreshIfChanged().catch((error: unknown) => {
        this.logger.warn(`No se pudieron recargar los parámetros: ${String(error)}`);
      });
    }, every);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  /** Valor vigente (panel o entorno). Sincrónico: se puede usar en getters. */
  value<K extends SettingKey>(key: K): Env[K] {
    const stored = this.values.get(key);
    return (stored?.value ?? this.config.get(key, { infer: true })) as Env[K];
  }

  list(): SettingView[] {
    return SETTINGS.map((def) => {
      const stored = this.values.get(def.key);
      return {
        key: def.key,
        group: def.group,
        label: def.label,
        help: def.help,
        kind: def.kind,
        unit: def.unit,
        min: def.min ?? null,
        max: def.max ?? null,
        value: this.value(def.key) as number | string,
        defaultValue: this.defaultOf(def.key),
        overridden: stored !== undefined,
        updatedAt: stored?.updatedAt.toISOString() ?? null,
      };
    });
  }

  /** Cambia un parámetro (validado por rango) y lo audita en la misma transacción. */
  async set(key: string, raw: unknown, adminId: string, audit: AuditHook, reason: string) {
    const def = settingDef(key);
    if (!def) throw unknownSetting();
    const checked = validateSetting(def, raw);
    if (!checked.ok) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'SETTING_OUT_OF_RANGE', checked.message);
    }
    const before = this.value(def.key) as number | string;
    await this.prisma.$transaction(async (tx) => {
      await tx.appSetting.upsert({
        where: { key_scope: { key, scope: SCOPE } },
        create: { key, scope: SCOPE, value: { value: checked.value }, updatedById: adminId },
        update: { value: { value: checked.value }, updatedById: adminId },
      });
      await audit.record(tx, {
        action: 'config.setting_set',
        targetType: 'app_setting',
        targetId: key,
        before: { value: before },
        after: { value: checked.value },
        reason,
      });
    });
    await this.bump();
    return this.view(key);
  }

  /** Vuelve al valor por defecto (la variable de entorno). */
  async reset(key: string, audit: AuditHook, reason: string) {
    const def = settingDef(key);
    if (!def) throw unknownSetting();
    const before = this.value(def.key) as number | string;
    await this.prisma.$transaction(async (tx) => {
      await tx.appSetting.deleteMany({ where: { key, scope: SCOPE } });
      await audit.record(tx, {
        action: 'config.setting_reset',
        targetType: 'app_setting',
        targetId: key,
        before: { value: before },
        after: { value: this.defaultOf(def.key) },
        reason,
      });
    });
    await this.bump();
    return this.view(key);
  }

  private defaultOf(key: keyof Env): number | string {
    const value: unknown = this.config.get(key, { infer: true });
    return value as number | string;
  }

  private view(key: string): SettingView {
    const found = this.list().find((s) => s.key === key);
    if (!found) throw unknownSetting();
    return found;
  }

  private async bump(): Promise<void> {
    await this.redis.incr(VERSION_KEY);
    await this.reload();
  }

  private async refreshIfChanged(): Promise<void> {
    if ((await this.redis.get(VERSION_KEY)) !== this.version) await this.reload();
  }

  private async reload(): Promise<void> {
    const version = await this.redis.get(VERSION_KEY);
    const rows = await this.prisma.appSetting.findMany({
      where: { scope: SCOPE, key: { in: SETTINGS.map((s) => s.key) } },
    });
    const next = new Map<string, { value: number | string; updatedAt: Date }>();
    for (const row of rows) {
      const def = settingDef(row.key);
      const stored = (row.value as { value?: unknown } | null)?.value;
      const checked = def ? validateSetting(def, stored) : null;
      // Un valor guardado que ya no pasa la validación (p. ej. cambió el rango) se ignora.
      if (checked?.ok) next.set(row.key, { value: checked.value, updatedAt: row.updatedAt });
      else this.logger.warn(`Parámetro ${row.key} inválido en app_settings: se usa el del entorno`);
    }
    this.values = next;
    this.version = version;
  }
}

const unknownSetting = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'SETTING_NOT_FOUND', 'Ese parámetro no existe.');

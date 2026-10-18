import {
  Inject,
  Injectable,
  Logger,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { DashboardService } from './dashboard.service';

const LOCK_KEY = 'admin:counters:lock';
const LAST_KEY = 'admin:counters:last';

/**
 * Colas del panel en vivo (ADR-0044). El worker cuenta las colas cada ADMIN_COUNTERS_EMIT_MS
 * (conteos sobre índices) y emite admin:counters a la sala `admins` solo si cambiaron.
 * Con varias instancias del worker, un candado en Redis deja contar a una sola por vuelta.
 * Así ninguna cola depende de que cada cambio emita su evento.
 */
@Injectable()
export class AdminCountersPublisher implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(AdminCountersPublisher.name);
  private timer: NodeJS.Timeout | null = null;
  private readonly everyMs: number;

  constructor(
    private readonly dashboard: DashboardService,
    private readonly realtime: RealtimeEmitter,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.everyMs = config.get('ADMIN_COUNTERS_EMIT_MS', { infer: true });
  }

  onModuleInit(): void {
    this.timer = setInterval(() => {
      void this.tick().catch((error: unknown) => {
        this.logger.warn(`No se pudieron publicar las colas del panel: ${String(error)}`);
      });
    }, this.everyMs);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  /** Una vuelta: cuenta y avisa si cambió. Devuelve si emitió (para los tests). */
  async tick(): Promise<boolean> {
    const lock = await this.redis.set(LOCK_KEY, '1', 'PX', Math.max(this.everyMs - 50, 50), 'NX');
    if (lock !== 'OK') return false;
    const counters = await this.dashboard.counters();
    const json = JSON.stringify(counters);
    const last = await this.redis.set(LAST_KEY, json, 'GET');
    if (last === json) return false;
    this.realtime.toAdmins(
      'admin:counters',
      Object.assign({}, counters, { at: new Date().toISOString() }),
    );
    return true;
  }
}

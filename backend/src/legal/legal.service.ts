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
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import type { AcceptLegalDto, LegalDocumentDto } from './dto/legal.dto';
import { isDraft, type LegalType } from './legal-source';

const TYPES: readonly LegalType[] = ['terms', 'privacy'];
/** Cada instancia relee las versiones vigentes cada tanto (una versión nueva entra sin redeploy). */
const REFRESH_MS = 60_000;
const okKey = (userId: string, versions: string) => `legal:ok:${userId}:${versions}`;

/**
 * Textos legales con versión y aceptación registrada (ADR-0051). Vale la versión más alta ya
 * publicada de cada tipo; si el usuario no la aceptó, la API le responde 403
 * LEGAL_ACCEPTANCE_REQUIRED (LegalGuard) hasta que la acepte.
 */
@Injectable()
export class LegalService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(LegalService.name);
  private current = new Map<LegalType, LegalDocumentDto>();
  private loadedAt = 0;
  private timer: NodeJS.Timeout | null = null;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async onModuleInit(): Promise<void> {
    const production = this.config.get('APP_ENV', { infer: true }) === 'production';
    // Sin base al arrancar (o en la exportación de OpenAPI) se reintenta en la recarga periódica;
    // producción, en cambio, no arranca sin poder verificar sus textos.
    await this.reload().catch((error: unknown) => {
      if (production) throw error;
      this.logger.warn(`Textos legales no disponibles al arrancar: ${String(error)}`);
    });
    if (production) {
      const missing = TYPES.filter((t) => !this.current.has(t));
      const drafts = [...this.current.values()].filter((d) => d.draft).map((d) => d.type);
      if (missing.length > 0 || drafts.length > 0) {
        throw new Error(
          `Producción no arranca sin textos legales finales (faltan: ${missing.join(', ') || '—'}; borradores: ${drafts.join(', ') || '—'}). ADR-0051.`,
        );
      }
    }
    this.timer = setInterval(() => {
      void this.reload().catch((error: unknown) => {
        this.logger.warn(`No se pudieron releer los textos legales: ${String(error)}`);
      });
    }, REFRESH_MS);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  async reload(): Promise<void> {
    const rows = await this.prisma.legalDocument.findMany({
      where: { publishedAt: { lte: new Date() } },
      orderBy: [{ type: 'asc' }, { version: 'desc' }],
    });
    const next = new Map<LegalType, LegalDocumentDto>();
    for (const row of rows) {
      if (next.has(row.type)) continue;
      next.set(row.type, {
        type: row.type,
        version: row.version,
        title: row.title,
        contentMd: row.contentMd,
        publishedAt: row.publishedAt.toISOString(),
        draft: isDraft(row.contentMd),
      });
    }
    this.current = next;
    this.loadedAt = Date.now();
  }

  private async fresh(): Promise<Map<LegalType, LegalDocumentDto>> {
    if (Date.now() - this.loadedAt > REFRESH_MS) await this.reload();
    return this.current;
  }

  async currentDocuments(): Promise<LegalDocumentDto[]> {
    return [...(await this.fresh()).values()];
  }

  /** Tipos cuya versión vigente el usuario todavía no aceptó. */
  async pendingFor(userId: string): Promise<LegalType[]> {
    const current = await this.fresh();
    if (current.size === 0) return [];
    const versions = TYPES.map((t) => `${t}${String(current.get(t)?.version ?? 0)}`).join('-');
    if ((await this.redis.get(okKey(userId, versions))) === '1') return [];
    const accepted = await this.prisma.legalAcceptance.findMany({
      where: {
        userId,
        OR: [...current.values()].map((d) => ({ type: d.type, version: d.version })),
      },
      select: { type: true },
    });
    const done = new Set(accepted.map((a) => a.type));
    const pending = [...current.keys()].filter((t) => !done.has(t));
    if (pending.length === 0) await this.redis.set(okKey(userId, versions), '1', 'EX', 86_400);
    return pending;
  }

  /**
   * Acepta las versiones que la app mostró. Si mientras tanto se publicó otra, 409: la app
   * vuelve a cargar los textos (nadie acepta una versión que no vio).
   */
  async accept(userId: string, dto: AcceptLegalDto): Promise<LegalType[]> {
    const current = await this.fresh();
    const shown: Record<LegalType, number> = {
      terms: dto.termsVersion,
      privacy: dto.privacyVersion,
    };
    for (const doc of current.values()) {
      if (shown[doc.type] !== doc.version) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'LEGAL_VERSION_CHANGED',
          'Hay una versión nueva de los textos. Revísala para continuar.',
        );
      }
    }
    await this.prisma.legalAcceptance.createMany({
      data: [...current.values()].map((doc) => ({
        userId,
        type: doc.type,
        version: doc.version,
        adultDeclared: dto.adult,
        appVersion: dto.appVersion ?? null,
        platform: dto.platform ?? null,
      })),
    });
    return this.pendingFor(userId);
  }
}

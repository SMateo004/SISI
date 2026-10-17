import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';

const BATCH = 5000;

/**
 * Limpieza del outbox (ADR-0022): borra los eventos **ya publicados** con más de
 * OUTBOX_RETENTION_DAYS días, por lotes para no bloquear la tabla. Los pendientes nunca
 * se borran. No tiene nada que ver con el ledger (append-only, Fase 5).
 */
@Injectable()
export class OutboxCleanupService {
  private readonly logger = new Logger('OutboxCleanup');
  private readonly retentionDays: number;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.retentionDays = config.get('OUTBOX_RETENTION_DAYS', { infer: true });
  }

  /** Devuelve cuántos eventos borró. */
  async runOnce(): Promise<number> {
    let total = 0;
    for (;;) {
      const deleted = await this.prisma.$executeRaw`
        DELETE FROM outbox_events
        WHERE id IN (
          SELECT id FROM outbox_events
          WHERE published_at IS NOT NULL
            AND published_at < now() - make_interval(days => ${this.retentionDays})
          ORDER BY id
          LIMIT ${BATCH}
        )`;
      total += deleted;
      if (deleted < BATCH) break;
    }
    if (total > 0) this.logger.log(`Outbox: ${total} eventos publicados borrados`);
    return total;
  }
}

import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { OpsMetrics } from './ops-metrics';

export const DRILL_EVENT_TYPE = 'ops.drill';
export type DrillKind = 'outbox' | 'otp' | 'push' | 'clear';

/**
 * Simulacro de alertas en staging (ADR-0048): deja cada condición justo por encima de su umbral
 * para que la próxima vuelta de OpsMonitor avise, sin tocar datos reales. `clear` la deshace.
 * Solo lo llama dev-tools, que se niega a correr con APP_ENV=production.
 */
@Injectable()
export class OpsDrill {
  constructor(
    private readonly prisma: PrismaService,
    private readonly metrics: OpsMetrics,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async run(kind: DrillKind, now = Date.now()): Promise<string> {
    switch (kind) {
      case 'outbox': {
        // Un evento viejo sin publicar que el relay no toma (available_at en el futuro).
        const age = this.config.get('OPS_OUTBOX_MAX_AGE_MS', { infer: true }) + 60_000;
        await this.prisma.$executeRaw`
          INSERT INTO outbox_events (type, aggregate_id, payload, created_at, available_at)
          VALUES (${DRILL_EVENT_TYPE}, gen_random_uuid(), '{}'::jsonb,
                  ${new Date(now - age)}, ${new Date(now + 30 * 60_000)})`;
        return 'Evento del outbox atascado creado: la próxima vuelta del monitor avisa (outbox_stuck).';
      }
      case 'otp':
        await this.metrics.count(
          'otp_fail',
          this.config.get('OPS_OTP_FAIL_THRESHOLD', { infer: true }),
          now,
        );
        return 'Fallos de OTP sumados: la próxima vuelta avisa (otp_failing).';
      case 'push': {
        const failed = this.config.get('OPS_PUSH_FAIL_THRESHOLD', { infer: true });
        await this.metrics.count('push_sent', failed, now);
        await this.metrics.count('push_fail', failed, now);
        return 'Fallos de push sumados: la próxima vuelta avisa (push_failing).';
      }
      case 'clear': {
        const removed = await this.prisma.outboxEvent.deleteMany({
          where: { type: DRILL_EVENT_TYPE },
        });
        return `Simulacro deshecho: ${String(removed.count)} eventos de prueba borrados. Los contadores de OTP y push vencen solos con su ventana.`;
      }
    }
  }
}

import { InjectQueue } from '@nestjs/bullmq';
import {
  Inject,
  Injectable,
  Logger,
  type OnModuleDestroy,
  type OnModuleInit,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Queue } from 'bullmq';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { QUEUES } from '../queues/queues';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { OpsMetrics } from './ops-metrics';
import { checkIn, reportAlert } from './sentry';

export type OpsAlertKind =
  'outbox_stuck' | 'queue_stuck' | 'queue_failing' | 'otp_failing' | 'push_failing';

export interface OpsAlert {
  kind: OpsAlertKind;
  message: string;
  extra: Record<string, unknown>;
}

const LOCK_KEY = 'ops:monitor:lock';
const failedKey = (queue: string) => `ops:monitor:failed:${queue}`;

/** Latido del worker en Sentry: si deja de llegar, el worker está caído o colgado. */
export const WORKER_HEARTBEAT = { crontab: '* * * * *', checkinMargin: 5, maxRuntime: 1 };

/**
 * Alertas operativas desde el worker (ADR-0048). Cada OPS_MONITOR_MS revisa el outbox, las colas
 * de BullMQ y los contadores de fallos de OTP y push; lo que supere su umbral va a Sentry como
 * una alerta con fingerprint estable (una issue por tipo) y la regla de Sentry avisa por el
 * canal elegido. Con varias instancias, un candado deja revisar a una sola por vuelta.
 */
@Injectable()
export class OpsMonitor implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(OpsMonitor.name);
  private timer: NodeJS.Timeout | null = null;

  constructor(
    private readonly prisma: PrismaService,
    private readonly metrics: OpsMetrics,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @InjectQueue(QUEUES.matching) private readonly matchingQueue: Queue,
    @InjectQueue(QUEUES.events) private readonly eventsQueue: Queue,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  onModuleInit(): void {
    const every = this.config.get('OPS_MONITOR_MS', { infer: true });
    this.timer = setInterval(() => {
      void this.tick().catch((error: unknown) => {
        this.logger.warn(`No se pudo revisar la operación: ${String(error)}`);
      });
    }, every);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  /** Una vuelta: revisa, avisa y late. Devuelve las alertas (para los tests y el simulacro). */
  async tick(now = Date.now()): Promise<OpsAlert[] | null> {
    const every = this.config.get('OPS_MONITOR_MS', { infer: true });
    const lock = await this.redis.set(LOCK_KEY, '1', 'PX', Math.max(every - 50, 50), 'NX');
    if (lock !== 'OK') return null;
    const alerts = await this.check(now);
    for (const alert of alerts) {
      this.logger.error(`[alerta ${alert.kind}] ${alert.message}`);
      reportAlert(alert.kind, alert.message, alert.extra);
    }
    checkIn('worker-heartbeat', 'ok', WORKER_HEARTBEAT);
    return alerts;
  }

  private thresholds() {
    const get = this.config;
    return {
      OPS_OUTBOX_MAX_AGE_MS: get.get('OPS_OUTBOX_MAX_AGE_MS', { infer: true }),
      OPS_QUEUE_MAX_WAIT_MS: get.get('OPS_QUEUE_MAX_WAIT_MS', { infer: true }),
      OPS_QUEUE_FAILED_DELTA: get.get('OPS_QUEUE_FAILED_DELTA', { infer: true }),
      OPS_OTP_FAIL_THRESHOLD: get.get('OPS_OTP_FAIL_THRESHOLD', { infer: true }),
      OPS_WINDOW_MS: get.get('OPS_WINDOW_MS', { infer: true }),
      OPS_PUSH_FAIL_THRESHOLD: get.get('OPS_PUSH_FAIL_THRESHOLD', { infer: true }),
      OPS_PUSH_FAIL_RATIO: get.get('OPS_PUSH_FAIL_RATIO', { infer: true }),
    };
  }

  async check(now = Date.now()): Promise<OpsAlert[]> {
    const alerts: OpsAlert[] = [];
    const cfg = this.thresholds();

    // Outbox: el evento sin publicar más antiguo (el relay está caído o fallando).
    const [oldest] = await this.prisma.$queryRaw<{ createdAt: Date | null; pending: bigint }[]>`
      SELECT min(created_at) AS "createdAt", count(*) AS pending
      FROM outbox_events WHERE published_at IS NULL`;
    const outboxMax = cfg.OPS_OUTBOX_MAX_AGE_MS;
    if (oldest?.createdAt && now - oldest.createdAt.getTime() > outboxMax) {
      alerts.push({
        kind: 'outbox_stuck',
        message: `Hay eventos del outbox sin publicar hace más de ${minutes(outboxMax)}.`,
        extra: {
          pending: Number(oldest.pending),
          oldestAgeSec: Math.round((now - oldest.createdAt.getTime()) / 1000),
        },
      });
    }

    // Colas: un job esperando demasiado (nadie consume) o fallidos que crecen.
    for (const queue of [this.matchingQueue, this.eventsQueue]) {
      const [waiting] = await queue.getJobs(['waiting'], 0, 0, true);
      const waitMax = cfg.OPS_QUEUE_MAX_WAIT_MS;
      if (waiting && now - waiting.timestamp > waitMax) {
        alerts.push({
          kind: 'queue_stuck',
          message: `La cola ${queue.name} tiene jobs esperando hace más de ${minutes(waitMax)}.`,
          extra: {
            queue: queue.name,
            waiting: await queue.getWaitingCount(),
            oldestAgeSec: Math.round((now - waiting.timestamp) / 1000),
          },
        });
      }
      const failed = await queue.getFailedCount();
      const previous = await this.redis.set(failedKey(queue.name), String(failed), 'GET');
      const delta = previous === null ? 0 : failed - Number(previous);
      if (delta >= cfg.OPS_QUEUE_FAILED_DELTA) {
        alerts.push({
          kind: 'queue_failing',
          message: `La cola ${queue.name} sumó ${String(delta)} jobs fallidos desde la última revisión.`,
          extra: { queue: queue.name, failed, delta },
        });
      }
    }

    // OTP: envíos fallidos en la ventana (Bird caído, sin saldo o rechazando).
    const otpFails = await this.metrics.recent('otp_fail', now);
    if (otpFails >= cfg.OPS_OTP_FAIL_THRESHOLD) {
      alerts.push({
        kind: 'otp_failing',
        message: `Fallaron ${String(otpFails)} envíos de código en los últimos ${minutes(2 * cfg.OPS_WINDOW_MS)}.`,
        extra: { failed: otpFails },
      });
    }

    // Push: muchos fallos o una proporción alta (credencial de FCM vencida, proyecto mal).
    const pushFails = await this.metrics.recent('push_fail', now);
    const pushSent = await this.metrics.recent('push_sent', now);
    const ratio = pushSent > 0 ? pushFails / pushSent : 0;
    if (
      pushFails >= cfg.OPS_PUSH_FAIL_THRESHOLD ||
      (pushSent >= 10 && ratio >= cfg.OPS_PUSH_FAIL_RATIO)
    ) {
      alerts.push({
        kind: 'push_failing',
        message: `Fallaron ${String(pushFails)} de ${String(pushSent)} avisos push recientes.`,
        extra: { failed: pushFails, sent: pushSent, ratio: Math.round(ratio * 100) / 100 },
      });
    }
    return alerts;
  }
}

const minutes = (ms: number) => {
  const m = Math.round(ms / 60_000);
  return m >= 1 ? `${String(m)} min` : `${String(Math.round(ms / 1000))} s`;
};

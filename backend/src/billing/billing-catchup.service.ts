import { randomUUID } from 'node:crypto';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { Prisma } from '../generated/prisma/client';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { BillingLedgerService } from './billing-ledger.service';
import { periodStatus, reminderTimes } from './billing.rules';

const LOCK_KEY = 'billing:catchup:lock';
const BATCH = 200;

export interface CatchUpResult {
  skipped: boolean;
  closed: number;
  overdue: number;
  reminders: number;
}

type NoticeKind = 'cierre' | 'vispera' | 'dia' | 'vencido';

/**
 * Puesta al día de cobros (ADR-0036). Idempotente: se puede correr cada hora o muchas veces
 * seguidas sin efectos dobles, y una corrida perdida se recupera en la siguiente.
 * - Cierra los periodos cuyo fin ya pasó (cerrado_pendiente, o pagado si no deben nada).
 * - Vence los cerrados con saldo cuya fecha límite pasó (el worker bloquea, ADR-0038).
 * - Programa los avisos de cierre, víspera y día del vencimiento (uno por tipo y periodo).
 * No envía nada directamente: escribe en el outbox y el worker avisa.
 * Un candado en Redis evita dos corridas a la vez; las filas se bloquean igual (FOR UPDATE).
 */
@Injectable()
export class BillingCatchUpService {
  private readonly logger = new Logger('BillingCatchUp');
  private readonly lockTtlMs: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly outbox: OutboxService,
    private readonly ledger: BillingLedgerService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.lockTtlMs = config.get('BILLING_LOCK_TTL_MS', { infer: true });
  }

  async run(now: Date = new Date()): Promise<CatchUpResult> {
    const token = randomUUID();
    const acquired = await this.redis.set(LOCK_KEY, token, 'PX', this.lockTtlMs, 'NX');
    if (acquired !== 'OK') {
      this.logger.warn('Otra corrida de cobros está en curso: se omite esta');
      return { skipped: true, closed: 0, overdue: 0, reminders: 0 };
    }
    try {
      const closed = await this.closeEnded(now);
      const overdue = await this.markOverdue(now);
      const reminders = await this.scheduleReminders(now);
      if (closed + overdue + reminders > 0) {
        this.logger.log(`Cobros: ${closed} cerrados, ${overdue} vencidos, ${reminders} avisos`);
      }
      return { skipped: false, closed, overdue, reminders };
    } finally {
      // Solo libera el candado si sigue siendo suyo.
      await this.redis.eval(
        "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end",
        1,
        LOCK_KEY,
        token,
      );
    }
  }

  /** Cierra los periodos abiertos cuyo fin ya pasó (R7.2). */
  private async closeEnded(now: Date): Promise<number> {
    let count = 0;
    for (;;) {
      const ids = await this.prisma.billingPeriod.findMany({
        where: { status: 'abierto', endAt: { lte: now } },
        select: { id: true },
        orderBy: { endAt: 'asc' },
        take: BATCH,
      });
      for (const { id } of ids) {
        if (await this.settle(id, now, 'abierto')) count += 1;
      }
      if (ids.length < BATCH) return count;
    }
  }

  /** Vence los cerrados con saldo cuya fecha límite pasó (R7.7). */
  private async markOverdue(now: Date): Promise<number> {
    let count = 0;
    for (;;) {
      const ids = await this.prisma.billingPeriod.findMany({
        where: { status: 'cerrado_pendiente', dueAt: { lte: now } },
        select: { id: true },
        orderBy: { dueAt: 'asc' },
        take: BATCH,
      });
      for (const { id } of ids) {
        if (await this.settle(id, now, 'cerrado_pendiente')) count += 1;
      }
      if (ids.length < BATCH) return count;
    }
  }

  /**
   * Recalcula el estado de un periodo con la fila bloqueada. `expected` evita pisar un
   * cambio concurrente (otra corrida, un pago). Devuelve si cambió.
   */
  private async settle(periodId: string, now: Date, expected: string): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const [period] = await tx.$queryRaw<
        {
          id: string;
          workerId: string;
          status: string;
          endAt: Date;
          dueAt: Date;
          commissionBs: string;
        }[]
      >`
        SELECT id, worker_id AS "workerId", status::text AS status, end_at AS "endAt",
               due_at AS "dueAt", commission_bs::text AS "commissionBs"
        FROM billing_periods WHERE id = ${periodId}::uuid FOR UPDATE`;
      if (period?.status !== expected) return false;
      const balance = await this.ledger.periodBalance(tx, periodId);
      const next = periodStatus({ endAt: period.endAt, dueAt: period.dueAt, balance, now });
      if (next === period.status) return false;
      await tx.billingPeriod.update({
        where: { id: periodId },
        data: {
          status: next,
          ...(period.status === 'abierto' ? { closedAt: now } : {}),
          ...(next === 'pagado' ? { paidAt: now } : {}),
          ...(next === 'vencido' ? { overdueAt: now } : {}),
        },
      });
      // Sin trabajos (o sin deuda) no hay cobro ni aviso.
      const owes = balance.gt(0) && new Prisma.Decimal(period.commissionBs).gt(0);
      if (period.status === 'abierto' && owes) {
        await this.notice(tx, periodId, period.workerId, 'cierre');
      }
      if (next === 'vencido') await this.notice(tx, periodId, period.workerId, 'vencido');
      return true;
    });
  }

  /** Víspera y día del vencimiento, a la hora local configurada (R7.6). */
  private async scheduleReminders(now: Date): Promise<number> {
    // Solo los que vencen en los próximos 3 días; el momento exacto se calcula por zona.
    const pending = await this.prisma.billingPeriod.findMany({
      where: {
        status: 'cerrado_pendiente',
        dueAt: { gt: now, lte: new Date(now.getTime() + 3 * 86_400_000) },
      },
      select: { id: true, workerId: true, dueAt: true, timezone: true },
    });
    let count = 0;
    for (const p of pending) {
      const times = reminderTimes(p.dueAt, this.ledger.calendar(p.timezone));
      for (const kind of ['vispera', 'dia'] as const) {
        if (now < times[kind]) continue;
        const sent = await this.prisma.$transaction((tx) =>
          this.notice(tx, p.id, p.workerId, kind),
        );
        if (sent) count += 1;
      }
    }
    return count;
  }

  /** Registra el aviso una sola vez por periodo y tipo; solo entonces lo pasa al outbox. */
  private async notice(
    tx: Prisma.TransactionClient,
    periodId: string,
    workerId: string,
    kind: NoticeKind,
  ): Promise<boolean> {
    const inserted = await tx.$executeRaw`
      INSERT INTO billing_notices (period_id, kind) VALUES (${periodId}::uuid, ${kind})
      ON CONFLICT DO NOTHING`;
    if (inserted === 0) return false;
    await this.outbox.add(tx, 'billing.notice', periodId, { periodId, workerId, kind });
    return true;
  }
}

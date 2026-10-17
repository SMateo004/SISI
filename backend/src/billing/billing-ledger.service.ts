import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { Prisma } from '../generated/prisma/client';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import {
  type BillingCalendar,
  newBillingCode,
  paymentReference,
  type PeriodStatus,
  periodWindow,
} from './billing.rules';

export interface LockedPeriod {
  id: string;
  workerId: string;
  cityId: string;
  timezone: string;
  startAt: Date;
  endAt: Date;
  dueAt: Date;
  status: PeriodStatus;
}

export interface CommissionInput {
  jobId: string;
  workerId: string;
  finalPriceBs: string;
  commissionBs: string;
  completedAt: Date;
}

/**
 * Núcleo del ledger (ADR-0034, ADR-0035): periodos perezosos con la fila bloqueada y
 * comisiones idempotentes. Lo usan el worker (job.completed), la API (pagos y ajustes) y el
 * cron. Toda escritura que cambia el saldo deja `billing.balance_changed` en el outbox.
 */
@Injectable()
export class BillingLedgerService {
  private readonly logger = new Logger('BillingLedger');
  private readonly dueAfterDays: number;
  private readonly reminderHour: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly outbox: OutboxService,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.dueAfterDays = config.get('BILLING_DUE_AFTER_DAYS', { infer: true });
    this.reminderHour = config.get('BILLING_REMINDER_HOUR', { infer: true });
  }

  calendar(timeZone: string): BillingCalendar {
    return { timeZone, dueAfterDays: this.dueAfterDays, reminderHour: this.reminderHour };
  }

  /**
   * Comisión de un trabajo terminado (job.completed). En una transacción: el periodo de la
   * semana en que terminó, bloqueado; si ese periodo ya se cerró (el evento llegó tarde), el
   * periodo abierto actual. Idempotente por job_id: un evento repetido no hace nada.
   */
  async recordCommission(
    input: CommissionInput,
    now: Date = new Date(),
  ): Promise<{ inserted: boolean; periodId: string | null }> {
    const commission = new Prisma.Decimal(input.commissionBs);
    // Una comisión de 0 (categoría al 0 %) no genera deuda ni movimiento.
    if (commission.lte(0)) return { inserted: false, periodId: null };

    return this.prisma.$transaction(async (tx) => {
      let period = await this.lockPeriodAt(tx, input.workerId, input.completedAt);
      if (period.status !== 'abierto') {
        this.logger.log(
          `Comisión del trabajo ${input.jobId} llegó con su periodo cerrado: va al periodo actual`,
        );
        period = await this.lockPeriodAt(tx, input.workerId, now);
      }
      const [row] = await tx.$queryRaw<{ id: bigint }[]>`
        INSERT INTO ledger_entries (worker_id, city_id, period_id, type, amount_bs, job_id)
        VALUES (${input.workerId}::uuid, ${period.cityId}::uuid, ${period.id}::uuid,
                'comision', ${commission.toFixed(2)}::numeric, ${input.jobId}::uuid)
        ON CONFLICT (job_id) WHERE type = 'comision' DO NOTHING
        RETURNING id`;
      if (!row) return { inserted: false, periodId: null };
      await tx.billingPeriod.update({
        where: { id: period.id },
        data: {
          grossBs: { increment: input.finalPriceBs },
          commissionBs: { increment: commission.toFixed(2) },
        },
      });
      await this.outbox.add(tx, 'billing.balance_changed', input.workerId, {
        workerId: input.workerId,
        cause: 'comision',
      });
      return { inserted: true, periodId: period.id };
    });
  }

  /**
   * Periodo del trabajador que contiene `at`, creado si no existe y bloqueado (FOR UPDATE)
   * hasta el fin de la transacción. La comisión y el cierre bloquean la misma fila: una
   * comisión nunca queda en dos periodos ni en ninguno.
   */
  async lockPeriodAt(
    tx: Prisma.TransactionClient,
    workerId: string,
    at: Date,
  ): Promise<LockedPeriod> {
    const worker = await tx.user.findUniqueOrThrow({
      where: { id: workerId },
      select: { cityId: true, city: { select: { timezone: true } } },
    });
    const timeZone = worker.city.timezone;
    const window = periodWindow(at, this.calendar(timeZone));
    const code = await this.billingCode(tx, workerId);
    await tx.$executeRaw`
      INSERT INTO billing_periods
        (worker_id, city_id, timezone, start_at, end_at, due_at, payment_reference, updated_at)
      VALUES (${workerId}::uuid, ${worker.cityId}::uuid, ${timeZone}, ${window.startAt},
              ${window.endAt}, ${window.dueAt},
              ${paymentReference(window.startAt, timeZone, code)}, now())
      ON CONFLICT (worker_id, start_at) DO NOTHING`;
    const [period] = await tx.$queryRaw<LockedPeriod[]>`
      SELECT id, worker_id AS "workerId", city_id AS "cityId", timezone,
             start_at AS "startAt", end_at AS "endAt", due_at AS "dueAt", status::text AS status
      FROM billing_periods
      WHERE worker_id = ${workerId}::uuid AND start_at = ${window.startAt}
      FOR UPDATE`;
    if (!period) throw new Error(`No se pudo crear el periodo de ${workerId}`);
    return period;
  }

  /**
   * Recalcula el estado de un periodo cerrado después de un pago o ajuste (fila ya
   * bloqueada por quien llama). Un periodo abierto no se toca: lo cierra el cron.
   * Un pagado que vuelve a deber (ajuste en contra) vuelve a pendiente o vencido.
   */
  async refreshClosedStatus(
    tx: Prisma.TransactionClient,
    periodId: string,
    now: Date,
  ): Promise<string> {
    const period = await tx.billingPeriod.findUniqueOrThrow({ where: { id: periodId } });
    if (period.status === 'abierto') return period.status;
    const balance = await this.periodBalance(tx, periodId);
    const next = balance.lte(0) ? 'pagado' : now >= period.dueAt ? 'vencido' : 'cerrado_pendiente';
    if (next !== period.status) {
      await tx.billingPeriod.update({
        where: { id: periodId },
        data: {
          status: next,
          paidAt: next === 'pagado' ? now : null,
          ...(next === 'vencido' && !period.overdueAt ? { overdueAt: now } : {}),
        },
      });
    }
    return next;
  }

  /** Saldo de un periodo: suma de sus movimientos (positivo = debe). */
  async periodBalance(
    tx: Prisma.TransactionClient | PrismaService,
    periodId: string,
  ): Promise<Prisma.Decimal> {
    const [row] = await tx.$queryRaw<{ balance: string }[]>`
      SELECT COALESCE(SUM(amount_bs), 0)::text AS balance
      FROM ledger_entries WHERE period_id = ${periodId}::uuid`;
    return new Prisma.Decimal(row?.balance ?? '0');
  }

  /** Saldo total del trabajador: suma de todo su ledger (positivo = debe). */
  async workerBalance(
    tx: Prisma.TransactionClient | PrismaService,
    workerId: string,
  ): Promise<Prisma.Decimal> {
    const [row] = await tx.$queryRaw<{ balance: string }[]>`
      SELECT COALESCE(SUM(amount_bs), 0)::text AS balance
      FROM ledger_entries WHERE worker_id = ${workerId}::uuid`;
    return new Prisma.Decimal(row?.balance ?? '0');
  }

  /** Código estable del trabajador para la referencia; se genera la primera vez. */
  private async billingCode(tx: Prisma.TransactionClient, workerId: string): Promise<string> {
    const profile = await tx.workerProfile.findUnique({
      where: { userId: workerId },
      select: { billingCode: true },
    });
    if (profile?.billingCode) return profile.billingCode;
    // Igual que WorkerStatusService: el perfil se crea si falta (sin_solicitar).
    if (!profile) {
      await tx.$executeRaw`
        INSERT INTO worker_profiles (user_id, updated_at) VALUES (${workerId}::uuid, now())
        ON CONFLICT (user_id) DO NOTHING`;
    }
    // Colisión improbable (31^6): se reintenta con otro código.
    for (let attempt = 0; attempt < 5; attempt++) {
      const code = newBillingCode();
      const taken = await tx.workerProfile.findUnique({ where: { billingCode: code } });
      if (taken) continue;
      const { count } = await tx.workerProfile.updateMany({
        where: { userId: workerId, billingCode: null },
        data: { billingCode: code },
      });
      if (count > 0) return code;
      const again = await tx.workerProfile.findUnique({
        where: { userId: workerId },
        select: { billingCode: true },
      });
      if (again?.billingCode) return again.billingCode;
    }
    throw new Error(`No se pudo asignar un código de cobro a ${workerId}`);
  }
}

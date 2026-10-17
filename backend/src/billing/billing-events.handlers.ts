import { Injectable, type OnModuleInit } from '@nestjs/common';
import { NotificationsService } from '../notifications/notifications.service';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { BillingLedgerService } from './billing-ledger.service';
import { dueLabel } from './billing.rules';
import { DebtStateService } from './debt-state.service';

/**
 * Cobros en el worker (ADR-0034, ADR-0036). Idempotentes:
 * - job.completed: la comisión no se duplica (índice único por job_id);
 * - billing.notice: cada aviso se registra una sola vez por periodo y tipo, y el aviso con
 *   push se deduplica por periodo y tipo.
 */
@Injectable()
export class BillingEventsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly prisma: PrismaService,
    private readonly ledger: BillingLedgerService,
    private readonly realtime: RealtimeEmitter,
    private readonly notifications: NotificationsService,
    private readonly debtState: DebtStateService,
  ) {}

  onModuleInit(): void {
    this.registry.on('job.completed', async ({ payload }) => {
      await this.ledger.recordCommission({
        jobId: payload.jobId,
        workerId: payload.workerId,
        finalPriceBs: payload.finalPriceBs,
        commissionBs: payload.commissionBs,
        completedAt: new Date(payload.completedAt),
      });
    });

    // Cambió el saldo (comisión, pago o ajuste): bloqueo o desbloqueo según la deuda vencida.
    this.registry.on('billing.balance_changed', async ({ payload }) => {
      await this.debtState.reconcile(payload.workerId);
    });

    this.registry.on('billing.notice', async ({ payload }) => {
      // Vencido (R7.7): el bloqueo avisa con account:blocked y push.
      if (payload.kind === 'vencido') {
        await this.debtState.reconcile(payload.workerId);
        return;
      }
      const period = await this.prisma.billingPeriod.findUniqueOrThrow({
        where: { id: payload.periodId },
      });
      const balance = await this.ledger.periodBalance(this.prisma, period.id);
      // Si ya lo pagó entre el registro del aviso y ahora, no se le avisa.
      if (balance.lte(0)) return;
      const amountBs = balance.toFixed(2);
      const label = dueLabel(period.dueAt, period.timezone);
      this.realtime.toUser(period.workerId, 'billing:due', {
        periodId: period.id,
        kind: payload.kind,
        amountBs,
        paymentReference: period.paymentReference,
        dueAt: period.dueAt.toISOString(),
      });
      const base = {
        userId: period.workerId,
        cityId: period.cityId,
        dedupeKey: `billing:${period.id}:${payload.kind}`,
      };
      if (payload.kind === 'cierre') {
        await this.notifications.notify({
          ...base,
          type: 'billing_due',
          data: {
            periodId: period.id,
            amountBs,
            reference: period.paymentReference,
            dueLabel: label,
          },
        });
      } else {
        await this.notifications.notify({
          ...base,
          type: 'billing_reminder',
          data: {
            periodId: period.id,
            amountBs,
            reference: period.paymentReference,
            dueLabel: label,
            today: payload.kind === 'dia',
          },
        });
      }
    });
  }
}

import { Injectable, type OnModuleInit } from '@nestjs/common';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { BillingLedgerService } from './billing-ledger.service';

/**
 * Cobros en el worker (ADR-0034): cada trabajo terminado deja su comisión en el ledger.
 * Idempotente: job.completed repetido no duplica el movimiento (índice único por job_id).
 */
@Injectable()
export class BillingEventsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly ledger: BillingLedgerService,
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
  }
}

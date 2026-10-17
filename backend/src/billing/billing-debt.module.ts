import { Module } from '@nestjs/common';
import { WorkerStatusModule } from '../workers/worker-status.module';
import { DebtStateService } from './debt-state.service';

/** Bloqueo y desbloqueo por deuda (R7.7, ADR-0038). Lo usa el worker. */
@Module({
  imports: [WorkerStatusModule],
  providers: [DebtStateService],
  exports: [DebtStateService],
})
export class BillingDebtModule {}

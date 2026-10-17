import { Module } from '@nestjs/common';
import { BillingDebtStatusProvider } from '../billing/billing-debt-status.provider';
import { WorkerAvailabilityModule } from '../locations/locations.module';
import { RealtimeWorkerNotifier } from './realtime-worker.notifier';
import { DEBT_STATUS_PROVIDER, WORKER_NOTIFIER } from './worker.ports';
import { WorkerStatusService } from './worker-status.service';

/**
 * Único punto que cambia el estado del trabajador (ADR-0013), con sus puertos reales:
 * deuda vencida desde billing y avisos por Socket.IO y push. Lo usan la API y el worker.
 */
@Module({
  imports: [WorkerAvailabilityModule],
  providers: [
    WorkerStatusService,
    { provide: DEBT_STATUS_PROVIDER, useClass: BillingDebtStatusProvider },
    { provide: WORKER_NOTIFIER, useClass: RealtimeWorkerNotifier },
  ],
  exports: [WorkerStatusService, WORKER_NOTIFIER, DEBT_STATUS_PROVIDER],
})
export class WorkerStatusModule {}

import { Module } from '@nestjs/common';
import {
  DEBT_STATUS_PROVIDER,
  LoggingWorkerNotifier,
  NoBillingYetDebtProvider,
  WORKER_NOTIFIER,
} from './worker.ports';
import { WorkerStatusService } from './worker-status.service';

@Module({
  providers: [
    WorkerStatusService,
    { provide: DEBT_STATUS_PROVIDER, useClass: NoBillingYetDebtProvider },
    { provide: WORKER_NOTIFIER, useClass: LoggingWorkerNotifier },
  ],
  exports: [WorkerStatusService],
})
export class WorkersModule {}

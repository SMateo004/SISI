import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module';
import { UsersModule } from '../users/users.module';
import { AdminWorkersController } from './admin-workers.controller';
import { ModeService } from './mode.service';
import { WorkerMeController } from './worker-me.controller';
import {
  DEBT_STATUS_PROVIDER,
  LoggingWorkerNotifier,
  NoBillingYetDebtProvider,
  WORKER_NOTIFIER,
} from './worker.ports';
import { WorkerStatusService } from './worker-status.service';
import { WorkersService } from './workers.service';

@Module({
  imports: [CategoriesModule, UsersModule],
  controllers: [WorkerMeController, AdminWorkersController],
  providers: [
    WorkersService,
    WorkerStatusService,
    ModeService,
    { provide: DEBT_STATUS_PROVIDER, useClass: NoBillingYetDebtProvider },
    { provide: WORKER_NOTIFIER, useClass: LoggingWorkerNotifier },
  ],
  exports: [WorkerStatusService],
})
export class WorkersModule {}

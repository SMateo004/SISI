import { Module } from '@nestjs/common';
import { BillingCoreModule } from '../billing/billing-core.module';
import { WorkerStatusModule } from '../workers/worker-status.module';
import { AdminUsersController } from './admin-users.controller';
import { AdminUsersService } from './admin-users.service';

@Module({
  imports: [BillingCoreModule, WorkerStatusModule],
  controllers: [AdminUsersController],
  providers: [AdminUsersService],
})
export class AdminUsersModule {}

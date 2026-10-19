import { Module } from '@nestjs/common';
import { ConsoleOtpFeed } from '../auth/otp/console-otp-feed';
import { BillingCoreModule } from '../billing/billing-core.module';
import { WorkerStatusModule } from '../workers/worker-status.module';
import { AdminOtpCodesController } from './admin-otp-codes.controller';
import { AdminUsersController } from './admin-users.controller';
import { AdminUsersService } from './admin-users.service';

@Module({
  imports: [BillingCoreModule, WorkerStatusModule],
  controllers: [AdminUsersController, AdminOtpCodesController],
  // ConsoleOtpFeed no guarda estado propio (todo en Redis): basta otra instancia aquí.
  providers: [AdminUsersService, ConsoleOtpFeed],
})
export class AdminUsersModule {}

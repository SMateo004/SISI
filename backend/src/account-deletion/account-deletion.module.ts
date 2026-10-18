import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { BillingModule } from '../billing/billing.module';
import { WorkerAvailabilityModule } from '../locations/locations.module';
import { OutboxModule } from '../outbox/outbox.module';
import { RequestStatusModule } from '../requests/request-status.module';
import { MeDeletionController, WebDeletionController } from './account-deletion.controller';
import { AccountDeletionService } from './account-deletion.service';

/** Eliminación de cuenta por anonimización (ADR-0049). Solo la API; el worker borra archivos. */
@Module({
  imports: [AuthModule, BillingModule, WorkerAvailabilityModule, OutboxModule, RequestStatusModule],
  controllers: [MeDeletionController, WebDeletionController],
  providers: [AccountDeletionService],
  exports: [AccountDeletionService],
})
export class AccountDeletionModule {}

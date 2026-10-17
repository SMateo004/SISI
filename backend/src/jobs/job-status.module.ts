import { Module } from '@nestjs/common';
import { RequestStatusModule } from '../requests/request-status.module';
import { JobAutoConfirmService } from './job-autoconfirm.service';
import { JobStatusService } from './job-status.service';

/** Único punto que cambia el estado de un trabajo (ADR-0029). Lo usan API y worker. */
@Module({
  imports: [RequestStatusModule],
  providers: [JobStatusService, JobAutoConfirmService],
  exports: [JobStatusService, JobAutoConfirmService],
})
export class JobStatusModule {}

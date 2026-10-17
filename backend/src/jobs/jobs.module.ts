import { Module } from '@nestjs/common';
import { ModerationModule } from '../moderation/moderation.module';
import { AdminJobsController } from './admin-jobs.controller';
import { JobStatusModule } from './job-status.module';
import { JobsController } from './jobs.controller';
import { JobsService } from './jobs.service';

/** Trabajos en la API (R6, ADR-0029). */
@Module({
  imports: [JobStatusModule, ModerationModule],
  controllers: [JobsController, AdminJobsController],
  providers: [JobsService],
  exports: [JobsService],
})
export class JobsModule {}

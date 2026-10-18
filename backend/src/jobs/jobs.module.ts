import { Module } from '@nestjs/common';
import { ModerationModule } from '../moderation/moderation.module';
import { ReviewPublisherModule } from '../reviews/reviews.module';
import { AdminJobsController } from './admin-jobs.controller';
import { AdminJobsService } from './admin-jobs.service';
import { JobStatusModule } from './job-status.module';
import { JobTrackingModule } from './job-tracking.module';
import { JobsController } from './jobs.controller';
import { JobsService } from './jobs.service';

/** Trabajos en la API (R6, ADR-0029). */
@Module({
  imports: [JobStatusModule, ModerationModule, JobTrackingModule, ReviewPublisherModule],
  controllers: [JobsController, AdminJobsController],
  providers: [JobsService, AdminJobsService],
  exports: [JobsService],
})
export class JobsModule {}

import { Module } from '@nestjs/common';
import { AdminJobsController } from './admin-jobs.controller';
import { JobStatusModule } from './job-status.module';
import { JobsController } from './jobs.controller';
import { JobsService } from './jobs.service';

/** Trabajos en la API (R6, ADR-0029). */
@Module({
  imports: [JobStatusModule],
  controllers: [JobsController, AdminJobsController],
  providers: [JobsService],
  exports: [JobsService],
})
export class JobsModule {}

import { Module } from '@nestjs/common';
import { JobTrackingService } from './job-tracking.service';

/** Seguimiento en vivo del trabajador en camino (API). Lo usa POST /worker/location. */
@Module({
  providers: [JobTrackingService],
  exports: [JobTrackingService],
})
export class JobTrackingModule {}

import { Module } from '@nestjs/common';
import { JobTrackingModule } from '../jobs/job-tracking.module';
import { WorkerAvailabilityService } from './worker-availability.service';
import { WorkerLocationsController } from './worker-locations.controller';
import { WorkerLocationsService } from './worker-locations.service';

/** Apagar la disponibilidad: lo usan workers (modo, estado) y el worker (barrido). */
@Module({
  providers: [WorkerAvailabilityService],
  exports: [WorkerAvailabilityService],
})
export class WorkerAvailabilityModule {}

/** Toggle "Disponible" y ubicación en vivo (ADR-0024). */
@Module({
  imports: [WorkerAvailabilityModule, JobTrackingModule],
  controllers: [WorkerLocationsController],
  providers: [WorkerLocationsService],
})
export class LocationsModule {}

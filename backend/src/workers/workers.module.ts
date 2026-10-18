import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module';
import { WorkerAvailabilityModule } from '../locations/locations.module';
import { UsersModule } from '../users/users.module';
import { ModeService } from './mode.service';
import { WorkerMeController } from './worker-me.controller';
import { WorkerStatusModule } from './worker-status.module';
import { WorkersService } from './workers.service';

@Module({
  imports: [CategoriesModule, UsersModule, WorkerAvailabilityModule, WorkerStatusModule],
  controllers: [WorkerMeController],
  providers: [WorkersService, ModeService],
  exports: [WorkerStatusModule],
})
export class WorkersModule {}

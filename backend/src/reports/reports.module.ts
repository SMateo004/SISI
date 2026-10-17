import { Module } from '@nestjs/common';
import { ModerationModule } from '../moderation/moderation.module';
import { WorkersModule } from '../workers/workers.module';
import { AdminReportsController, ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';

/** Reportes y suspensión por moderación (R9.3, ADR-0033). */
@Module({
  imports: [ModerationModule, WorkersModule],
  controllers: [ReportsController, AdminReportsController],
  providers: [ReportsService],
  exports: [ReportsService],
})
export class ReportsModule {}

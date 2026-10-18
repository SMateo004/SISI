import { Module } from '@nestjs/common';
import { AuditModule } from '../audit/audit.module';
import { FeatureFlagsModule } from '../feature-flags/feature-flags.module';
import { AdminPilotController } from './admin-pilot.controller';
import { PilotController } from './pilot.controller';
import { PilotService } from './pilot.service';

/** Piloto cerrado: lista de números por ciudad e interés (ADR-0052). */
@Module({
  imports: [FeatureFlagsModule, AuditModule],
  controllers: [PilotController, AdminPilotController],
  providers: [PilotService],
  exports: [PilotService],
})
export class PilotModule {}

import { Global, Module } from '@nestjs/common';
import { AdminOpsController } from './admin-ops.controller';
import { OpsMetrics } from './ops-metrics';

/** Contadores de fallos para las alertas (ADR-0048), en la API y en el worker. */
@Global()
@Module({
  controllers: [AdminOpsController],
  providers: [OpsMetrics],
  exports: [OpsMetrics],
})
export class ObservabilityModule {}

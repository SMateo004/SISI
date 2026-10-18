import { Module } from '@nestjs/common';
import { RetentionService } from './retention.service';

/** Retención de datos (ADR-0050): la corre el worker una vez por día y dev-tools a pedido. */
@Module({
  providers: [RetentionService],
  exports: [RetentionService],
})
export class RetentionModule {}

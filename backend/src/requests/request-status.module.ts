import { Module } from '@nestjs/common';
import { RequestStatusService } from './request-status.service';

/** Único punto que cambia el estado de una solicitud (ADR-0019). Lo usan API y worker. */
@Module({
  providers: [RequestStatusService],
  exports: [RequestStatusService],
})
export class RequestStatusModule {}

import { Global, Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { PresenceService } from './presence.service';
import { RealtimeEmitter } from './realtime.emitter';
import { RealtimeGateway } from './realtime.gateway';

/** Gateway Socket.IO de la API (ADR-0023). */
@Module({
  imports: [AuthModule],
  providers: [RealtimeGateway],
})
export class RealtimeModule {}

/** Emisor de eventos de tiempo real y presencia (API o worker) por Redis (ADR-0023, ADR-0031). */
@Global()
@Module({
  providers: [RealtimeEmitter, PresenceService],
  exports: [RealtimeEmitter, PresenceService],
})
export class RealtimeEmitterModule {}

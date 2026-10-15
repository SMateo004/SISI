import { Global, Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { RealtimeEmitter } from './realtime.emitter';
import { RealtimeGateway } from './realtime.gateway';

/** Gateway Socket.IO de la API (ADR-0023). */
@Module({
  imports: [AuthModule],
  providers: [RealtimeGateway],
})
export class RealtimeModule {}

/** Emisor de eventos de tiempo real (API o worker) por Redis (ADR-0023). */
@Global()
@Module({
  providers: [RealtimeEmitter],
  exports: [RealtimeEmitter],
})
export class RealtimeEmitterModule {}

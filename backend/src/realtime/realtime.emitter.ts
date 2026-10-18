import { Inject, Injectable, type OnApplicationShutdown } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Emitter } from '@socket.io/redis-emitter';
import { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { type RealtimeEventName, type RealtimePayloads, rooms } from './realtime.events';

/**
 * Emite eventos de tiempo real desde cualquier proceso (ADR-0023). Usa
 * @socket.io/redis-emitter: publica en Redis y el adapter de cada instancia de la API lo
 * entrega a sus sockets. El worker no levanta un servidor Socket.IO.
 */
@Injectable()
export class RealtimeEmitter implements OnApplicationShutdown {
  private readonly redis: Redis;
  private readonly emitter: Emitter;

  constructor(@Inject(ConfigService) config: AppConfigService) {
    this.redis = new Redis(config.get('REDIS_URL', { infer: true }), { maxRetriesPerRequest: 3 });
    this.emitter = new Emitter(this.redis);
  }

  toUser<E extends RealtimeEventName>(
    userId: string,
    event: E,
    payload: RealtimePayloads[E],
  ): void {
    this.emitter.to(rooms.user(userId)).emit(event, payload);
  }

  toUsers<E extends RealtimeEventName>(
    userIds: string[],
    event: E,
    payload: RealtimePayloads[E],
  ): void {
    if (userIds.length === 0) return;
    this.emitter.to(userIds.map(rooms.user)).emit(event, payload);
  }

  toAdmins<E extends RealtimeEventName>(event: E, payload: RealtimePayloads[E]): void {
    this.emitter.to(rooms.admins).emit(event, payload);
  }

  toRequest<E extends RealtimeEventName>(
    requestId: string,
    event: E,
    payload: RealtimePayloads[E],
  ): void {
    this.emitter.to(rooms.request(requestId)).emit(event, payload);
  }

  /** Une los sockets de esos usuarios a la sala de la solicitud (empleador y notificados). */
  joinRequest(userIds: string[], requestId: string): void {
    if (userIds.length === 0) return;
    this.emitter.in(userIds.map(rooms.user)).socketsJoin(rooms.request(requestId));
  }

  /** Vacía la sala de la solicitud (al asignarse, cancelarse o expirar). */
  leaveRequest(requestId: string): void {
    this.emitter.in(rooms.request(requestId)).socketsLeave(rooms.request(requestId));
  }

  async onApplicationShutdown(): Promise<void> {
    if (this.redis.status !== 'end') await this.redis.quit();
  }
}

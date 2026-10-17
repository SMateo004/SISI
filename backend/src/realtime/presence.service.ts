import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { REDIS_CLIENT } from '../redis/redis.constants';

const key = (userId: string): string => `presence:${userId}`;

/**
 * Presencia en Socket.IO (ADR-0031): por usuario, un ZSET de sockets con su vencimiento.
 * El gateway lo registra al conectar, lo renueva con un latido y lo quita al desconectar;
 * si una instancia cae sin desconectar, sus sockets vencen solos. El worker lo consulta
 * para decidir si un mensaje de chat necesita push. Un fallo de Redis cuenta como
 * "desconectado": a lo sumo llega un push de más.
 */
@Injectable()
export class PresenceService {
  private readonly logger = new Logger('Presence');
  readonly ttlMs: number;

  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.ttlMs = config.get('PRESENCE_TTL_MS', { infer: true });
  }

  async touch(entries: { userId: string; socketId: string }[]): Promise<void> {
    if (entries.length === 0) return;
    const until = Date.now() + this.ttlMs;
    const multi = this.redis.multi();
    for (const e of entries) {
      multi.zadd(key(e.userId), until, e.socketId).pexpire(key(e.userId), this.ttlMs);
    }
    await multi.exec().catch((err: unknown) => {
      this.logger.warn(`No se pudo registrar la presencia: ${String(err)}`);
    });
  }

  async leave(userId: string, socketId: string): Promise<void> {
    await this.redis.zrem(key(userId), socketId).catch(() => undefined);
  }

  async isOnline(userId: string): Promise<boolean> {
    try {
      const result = await this.redis
        .multi()
        .zremrangebyscore(key(userId), '-inf', Date.now())
        .zcard(key(userId))
        .exec();
      const count = result?.[1]?.[1];
      return typeof count === 'number' && count > 0;
    } catch {
      return false;
    }
  }
}

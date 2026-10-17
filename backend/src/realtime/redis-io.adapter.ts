import type { INestApplicationContext } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IoAdapter } from '@nestjs/platform-socket.io';
import { createAdapter } from '@socket.io/redis-adapter';
import { Redis } from 'ioredis';
import type { Server, ServerOptions } from 'socket.io';
import type { AppConfigService } from '../config/app-config';

/**
 * Adapter de Socket.IO para la API (ADR-0023): mismo CORS que HTTP y
 * @socket.io/redis-adapter, para que un evento llegue al socket sin importar en qué
 * instancia esté conectado (y para recibir lo que emite el worker con redis-emitter).
 */
export class RedisIoAdapter extends IoAdapter {
  private readonly pub: Redis;
  private readonly sub: Redis;
  private readonly origins: string[];

  constructor(app: INestApplicationContext) {
    super(app);
    const config = app.get<AppConfigService>(ConfigService);
    this.origins = config.get('CORS_ORIGINS', { infer: true });
    this.pub = new Redis(config.get('REDIS_URL', { infer: true }), { maxRetriesPerRequest: 3 });
    this.sub = this.pub.duplicate();
  }

  override createIOServer(port: number, options?: ServerOptions): Server {
    const server = super.createIOServer(port, {
      ...options,
      // Solo websocket: sin long-polling no hace falta afinidad de sesión entre instancias
      // (Render no la garantiza, ADR-0023).
      transports: ['websocket'],
      cors: { origin: this.origins.length > 0 ? this.origins : false, credentials: true },
    } as ServerOptions);
    server.adapter(createAdapter(this.pub, this.sub));
    return server;
  }

  override async dispose(): Promise<void> {
    await super.dispose();
    for (const client of [this.pub, this.sub]) {
      if (client.status !== 'end') await client.quit();
    }
  }
}

import type { INestApplicationContext } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IoAdapter } from '@nestjs/platform-socket.io';
import { createAdapter } from '@socket.io/redis-adapter';
import { Redis } from 'ioredis';
import type { Server, ServerOptions } from 'socket.io';
import { isAllowedSocketOrigin } from '../common/http/security-headers';
import type { AppConfigService } from '../config/app-config';
import { socketIoKey } from './realtime.events';

/**
 * Adapter de Socket.IO para la API (ADR-0023): mismo CORS que HTTP y
 * @socket.io/redis-adapter, para que un evento llegue al socket sin importar en qué
 * instancia esté conectado (y para recibir lo que emite el worker con redis-emitter).
 */
export class RedisIoAdapter extends IoAdapter {
  private readonly pub: Redis;
  private readonly sub: Redis;
  private readonly origins: string[];
  private readonly key: string;

  constructor(app: INestApplicationContext) {
    super(app);
    const config = app.get<AppConfigService>(ConfigService);
    this.origins = config.get('CORS_ORIGINS', { infer: true });
    this.key = socketIoKey(config.get('QUEUE_PREFIX', { infer: true }));
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
      // El CORS no protege un websocket: se rechaza un navegador de otro origen (ADR-0047).
      allowRequest: (req, callback) => {
        callback(null, isAllowedSocketOrigin(req.headers.origin, this.origins));
      },
    } as ServerOptions);
    server.adapter(createAdapter(this.pub, this.sub, { key: this.key }));
    return server;
  }

  override async dispose(): Promise<void> {
    await super.dispose();
    for (const client of [this.pub, this.sub]) {
      if (client.status !== 'end') await client.quit();
    }
  }
}

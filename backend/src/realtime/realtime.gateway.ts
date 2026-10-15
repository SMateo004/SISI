import {
  type OnGatewayConnection,
  type OnGatewayDisconnect,
  type OnGatewayInit,
  WebSocketGateway,
} from '@nestjs/websockets';
import type { Server, Socket } from 'socket.io';
import { authenticateAccessToken, type VerifiedAccess } from '../auth/guards/jwt-auth.guard';
import { TokenService } from '../auth/tokens/token.service';
import { ApiError } from '../common/errors/api-error';
import { rooms } from './realtime.events';

interface SocketData {
  user: VerifiedAccess;
  expiryTimer?: NodeJS.Timeout;
}

type SisiSocket = Socket<
  Record<string, never>,
  Record<string, never>,
  Record<string, never>,
  SocketData
>;

/**
 * Gateway Socket.IO de la API (ADR-0023).
 * - El handshake trae `auth.token` (token de acceso) y se valida igual que en HTTP.
 * - Cada socket entra a `user:{id}`; el servidor lo une a `request:{id}` cuando corresponde.
 * - Al vencer el token, el servidor corta el socket: la app reconecta con uno nuevo.
 * El cliente no envía eventos: los cambios se hacen por REST.
 */
@WebSocketGateway()
export class RealtimeGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  constructor(private readonly tokens: TokenService) {}

  afterInit(server: Server): void {
    server.use((socket, next) => {
      const auth = socket.handshake.auth as { token?: unknown };
      const token = typeof auth.token === 'string' ? auth.token : undefined;
      authenticateAccessToken(this.tokens, token)
        .then((user) => {
          (socket as SisiSocket).data.user = user;
          next();
        })
        .catch((err: unknown) => {
          const error = new Error(
            err instanceof ApiError ? err.message : 'No autorizado',
          ) as Error & {
            data?: unknown;
          };
          error.data = { code: err instanceof ApiError ? err.code : 'UNAUTHENTICATED' };
          next(error);
        });
    });
  }

  async handleConnection(socket: SisiSocket): Promise<void> {
    const { user } = socket.data;
    await socket.join(rooms.user(user.id));
    if (user.expiresAt !== undefined) {
      const ms = Math.max(user.expiresAt - Date.now(), 0);
      socket.data.expiryTimer = setTimeout(() => socket.disconnect(true), ms);
    }
  }

  handleDisconnect(socket: SisiSocket): void {
    clearTimeout(socket.data.expiryTimer);
  }
}

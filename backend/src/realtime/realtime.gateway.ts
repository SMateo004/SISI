import type { OnModuleDestroy } from '@nestjs/common';
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
import { PrismaService } from '../prisma/prisma.service';
import { PresenceService } from './presence.service';
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
 * - Cada socket entra a `user:{id}` y a `request:{id}` de las solicitudes abiertas en las que
 *   participa (como empleador o trabajador notificado): reconectar no lo saca de sus salas.
 * - Al vencer el token, el servidor corta el socket: la app reconecta con uno nuevo.
 * - Registra la presencia del usuario en Redis con un latido (ADR-0031).
 * El cliente no envía eventos: los cambios se hacen por REST.
 */
@WebSocketGateway()
export class RealtimeGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect, OnModuleDestroy
{
  private readonly local = new Map<string, string>();
  private heartbeat?: NodeJS.Timeout;

  constructor(
    private readonly tokens: TokenService,
    private readonly prisma: PrismaService,
    private readonly presence: PresenceService,
  ) {}

  afterInit(server: Server): void {
    // Renueva la presencia de los sockets de esta instancia antes de que venza.
    this.heartbeat = setInterval(
      () => {
        void this.presence.touch(
          [...this.local].map(([socketId, userId]) => ({ socketId, userId })),
        );
      },
      Math.max(Math.floor(this.presence.ttlMs / 3), 1000),
    );
    this.heartbeat.unref();

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
    // Primero, sin esperar nada: el cliente ya se considera conectado y un aviso a su
    // sala (o un socketsJoin) podría llegar mientras se consulta la base.
    void socket.join(rooms.user(user.id));
    // El panel recibe las colas pendientes en vivo (ADR-0044).
    if (user.role === 'admin' && user.aud === 'admin') void socket.join(rooms.admins);
    this.local.set(socket.id, user.id);
    // El temporizador se arma antes de cualquier await: si el cliente se desconecta mientras
    // tanto, handleDisconnect ya lo encuentra y lo limpia (antes quedaba vivo hasta 15 min).
    if (user.expiresAt !== undefined) {
      const ms = Math.max(user.expiresAt - Date.now(), 0);
      socket.data.expiryTimer = setTimeout(() => socket.disconnect(true), ms);
      socket.data.expiryTimer.unref();
    }
    await this.presence.touch([{ userId: user.id, socketId: socket.id }]);
    if (socket.disconnected) {
      // Se fue durante el await: no dejar su presencia marcada.
      await this.presence.leave(user.id, socket.id);
      return;
    }
    const open = await this.prisma.serviceRequest.findMany({
      where: {
        status: { in: ['buscando', 'con_ofertas'] },
        OR: [{ employerId: user.id }, { notifications: { some: { workerId: user.id } } }],
      },
      select: { id: true },
      take: 50,
    });
    if (open.length > 0) await socket.join(open.map((r) => rooms.request(r.id)));
  }

  handleDisconnect(socket: SisiSocket): void {
    clearTimeout(socket.data.expiryTimer);
    this.local.delete(socket.id);
    void this.presence.leave(socket.data.user.id, socket.id);
  }

  onModuleDestroy(): void {
    clearInterval(this.heartbeat);
  }
}

import { Injectable, Logger } from '@nestjs/common';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../prisma/prisma.service';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import type { WorkerNotifier } from './worker.ports';
import type { WorkerStatus } from './worker-status.machine';

/**
 * Avisos de los cambios de estado del trabajador (Fase 5): account:blocked y
 * account:unblocked por Socket.IO, y aviso con push. Se llama después de confirmar la
 * transacción; un fallo aquí no deshace el cambio de estado (se registra en el log).
 */
@Injectable()
export class RealtimeWorkerNotifier implements WorkerNotifier {
  private readonly logger = new Logger('WorkerNotifier');

  constructor(
    private readonly prisma: PrismaService,
    private readonly realtime: RealtimeEmitter,
    private readonly notifications: NotificationsService,
  ) {}

  async modeForcedToEmployer(): Promise<void> {
    // El aviso de bloqueo (statusChanged) ya explica que sigue en modo empleador.
  }

  async statusChanged(userId: string, from: WorkerStatus, to: WorkerStatus): Promise<void> {
    try {
      const user = await this.prisma.user.findUniqueOrThrow({
        where: { id: userId },
        select: { cityId: true },
      });
      const at = new Date().toISOString();
      if (to === 'bloqueado_deuda' || to === 'suspendido_moderacion') {
        const reason = to === 'bloqueado_deuda' ? 'deuda' : 'moderacion';
        this.realtime.toUser(userId, 'account:blocked', { reason, status: to });
        await this.notifications.notify({
          userId,
          cityId: user.cityId,
          type: 'account_blocked',
          data: { reason },
          dedupeKey: `account:${userId}:${to}:${at}`,
        });
      } else if (from === 'bloqueado_deuda' || from === 'suspendido_moderacion') {
        this.realtime.toUser(userId, 'account:unblocked', { status: to });
        await this.notifications.notify({
          userId,
          cityId: user.cityId,
          type: 'account_unblocked',
          data: { status: to },
          dedupeKey: `account:${userId}:${to}:${at}`,
        });
      }
    } catch (error) {
      this.logger.error(`No se pudo avisar el cambio de estado de ${userId}: ${String(error)}`);
    }
  }
}

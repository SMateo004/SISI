import { Injectable, type OnModuleInit } from '@nestjs/common';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { REJECTION_LABELS } from '../verifications/verification.rules';
import { NotificationsService } from './notifications.service';

/**
 * Aviso y push al trabajador cuando el admin revisa su solicitud (Fase 6). Corre en el
 * worker; idempotente por la clave de deduplicación del evento.
 */
@Injectable()
export class AccountNotificationsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly notifications: NotificationsService,
    private readonly prisma: PrismaService,
  ) {}

  onModuleInit(): void {
    this.registry.on('worker.reviewed', async ({ outboxId, payload }) => {
      const user = await this.prisma.user.findUniqueOrThrow({
        where: { id: payload.workerId },
        select: { cityId: true },
      });
      const dedupeKey = `${outboxId}:${payload.workerId}`;
      if (payload.decision === 'approved') {
        await this.notifications.notify({
          userId: payload.workerId,
          cityId: user.cityId,
          type: 'verification_approved',
          data: {},
          dedupeKey,
        });
        return;
      }
      await this.notifications.notify({
        userId: payload.workerId,
        cityId: user.cityId,
        type: 'verification_rejected',
        data: {
          reason: payload.reason ? REJECTION_LABELS[payload.reason] : 'Revisa la nota del equipo',
          note: payload.note ?? '',
        },
        dedupeKey,
      });
    });
  }
}

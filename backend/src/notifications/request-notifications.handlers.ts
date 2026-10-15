import { Injectable, type OnModuleInit } from '@nestjs/common';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { NotificationsService } from './notifications.service';

/**
 * Avisos al empleador cuando el admin libera o rechaza una solicitud retenida (cierra el
 * pendiente de la Fase 2). Corren en el worker, a partir de eventos del outbox.
 */
@Injectable()
export class RequestNotificationsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly notifications: NotificationsService,
    private readonly prisma: PrismaService,
  ) {}

  onModuleInit(): void {
    this.registry.on('request.released', async ({ outboxId, payload }) => {
      const r = await this.request(payload.requestId);
      await this.notifications.notify({
        userId: r.employerId,
        cityId: r.cityId,
        type: 'request_released',
        data: { requestId: r.id, category: r.category.name },
        dedupeKey: `${outboxId}:${r.employerId}`,
      });
    });
    this.registry.on('request.rejected', async ({ outboxId, payload }) => {
      const r = await this.request(payload.requestId);
      await this.notifications.notify({
        userId: r.employerId,
        cityId: r.cityId,
        type: 'request_rejected',
        data: { requestId: r.id, category: r.category.name },
        dedupeKey: `${outboxId}:${r.employerId}`,
      });
    });
  }

  private request(id: string) {
    return this.prisma.serviceRequest.findUniqueOrThrow({
      where: { id },
      select: {
        id: true,
        employerId: true,
        cityId: true,
        category: { select: { name: true } },
      },
    });
  }
}

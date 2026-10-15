import { Injectable, type OnModuleInit } from '@nestjs/common';
import { toBs } from '../categories/effective-category';
import { NotificationsService } from '../notifications/notifications.service';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { MatchingService } from './matching.service';

/**
 * Efectos del matching en el worker (ADR-0025): socket y push a partir de eventos del
 * outbox. Idempotentes: el aviso guardado usa dedupe_key y los eventos de socket son avisos.
 */
@Injectable()
export class MatchingEventsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly prisma: PrismaService,
    private readonly realtime: RealtimeEmitter,
    private readonly notifications: NotificationsService,
    private readonly matching: MatchingService,
  ) {}

  onModuleInit(): void {
    // Aviso a un trabajador del anillo: sala de la solicitud, request:new y push.
    this.registry.on('request.notified', async ({ outboxId, payload }) => {
      const r = await this.request(payload.requestId);
      this.realtime.joinRequest([payload.workerId], r.id);
      this.realtime.toUser(payload.workerId, 'request:new', {
        requestId: r.id,
        ring: payload.ring,
        distanceM: payload.distanceM,
        category: { slug: r.category.slug, name: r.category.name },
        proposedPriceBs: toBs(r.proposedPriceBs),
        respondBy: payload.respondBy,
      });
      await this.notifications.notify({
        userId: payload.workerId,
        cityId: r.cityId,
        type: 'request_new',
        data: {
          requestId: r.id,
          category: r.category.name,
          distanceM: payload.distanceM,
          proposedPriceBs: toBs(r.proposedPriceBs),
        },
        dedupeKey: `${outboxId}:${payload.workerId}`,
      });
    });

    // Expiró (R4.5): a la sala, offer:closed a los ofertantes y aviso al empleador.
    this.registry.on('request.expired', async ({ outboxId, payload }) => {
      const r = await this.request(payload.requestId);
      await this.matching.cancelPendingJobs(r.id);
      this.realtime.toRequest(r.id, 'request:expired', { requestId: r.id });
      this.realtime.toUser(r.employerId, 'request:expired', { requestId: r.id });
      const offerers = await this.prisma.offer.findMany({
        where: { requestId: r.id },
        select: { workerId: true },
      });
      this.realtime.toUsers(
        offerers.map((o) => o.workerId),
        'offer:closed',
        { requestId: r.id, reason: 'expirada' },
      );
      this.realtime.leaveRequest(r.id);
      await this.notifications.notify({
        userId: r.employerId,
        cityId: r.cityId,
        type: 'request_expired',
        data: { requestId: r.id, category: r.category.name },
        dedupeKey: `${outboxId}:${r.employerId}`,
      });
    });

    // El empleador canceló (R3.4): se cancelan los pasos pendientes y se avisa a los notificados.
    this.registry.on('request.cancelled', async ({ payload }) => {
      await this.matching.cancelPendingJobs(payload.requestId);
      const notified = await this.prisma.requestNotification.findMany({
        where: { requestId: payload.requestId },
        select: { workerId: true },
      });
      this.realtime.toUsers(
        notified.map((n) => n.workerId),
        'offer:closed',
        { requestId: payload.requestId, reason: 'cancelada' },
      );
      this.realtime.leaveRequest(payload.requestId);
    });
  }

  private request(id: string) {
    return this.prisma.serviceRequest.findUniqueOrThrow({
      where: { id },
      select: {
        id: true,
        cityId: true,
        employerId: true,
        proposedPriceBs: true,
        category: { select: { slug: true, name: true } },
      },
    });
  }
}

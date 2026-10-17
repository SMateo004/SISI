import { Injectable, type OnModuleInit } from '@nestjs/common';
import { toBs } from '../categories/effective-category';
import { MatchingService } from '../matching/matching.service';
import { NotificationsService } from '../notifications/notifications.service';
import { OutboxService } from '../outbox/outbox.service';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { lockRequest } from '../requests/request-lock';
import { RequestStatusService } from '../requests/request-status.service';
import { withdrawLockedOffer } from './offer-withdrawal';
import { shortName } from './offer.rules';

/**
 * Efectos de las ofertas en el worker (ADR-0026): offer:new al empleador, y al asignar,
 * request:assigned, offer:closed a los no elegidos y aviso al elegido. Al elegido se le
 * retiran sus otras ofertas activas: queda ocupado (Fase 4).
 */
@Injectable()
export class OfferEventsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly prisma: PrismaService,
    private readonly realtime: RealtimeEmitter,
    private readonly notifications: NotificationsService,
    private readonly matching: MatchingService,
    private readonly status: RequestStatusService,
    private readonly outbox: OutboxService,
  ) {}

  onModuleInit(): void {
    this.registry.on('offer.created', async ({ outboxId, payload }) => {
      const offer = await this.prisma.offer.findUniqueOrThrow({
        where: { id: payload.offerId },
        include: {
          request: { select: { employerId: true, cityId: true } },
          worker: {
            select: { ratingAvg: true, ratingCount: true, user: { select: { name: true } } },
          },
        },
      });
      const name = shortName(offer.worker.user.name);
      this.realtime.toUser(offer.request.employerId, 'offer:new', {
        requestId: offer.requestId,
        offerId: offer.id,
        type: offer.type,
        amountBs: toBs(offer.amountBs),
        etaMin: offer.etaMin,
        worker: {
          shortName: name,
          ratingAvg: toBs(offer.worker.ratingAvg),
          ratingCount: offer.worker.ratingCount,
        },
      });
      await this.notifications.notify({
        userId: offer.request.employerId,
        cityId: offer.request.cityId,
        type: 'offer_new',
        data: { requestId: offer.requestId, workerShortName: name, amountBs: toBs(offer.amountBs) },
        dedupeKey: `${outboxId}:${offer.request.employerId}`,
      });
    });

    // Retiró su oferta: el empleador deja de verla; si era la única, sigue el matching.
    this.registry.on('offer.withdrawn', async ({ payload }) => {
      const request = await this.prisma.serviceRequest.findUniqueOrThrow({
        where: { id: payload.requestId },
        select: { employerId: true },
      });
      this.realtime.toUser(request.employerId, 'offer:closed', {
        requestId: payload.requestId,
        reason: 'retirada',
        offerId: payload.offerId,
      });
      if (payload.reopened) await this.matching.resume(payload.requestId);
    });

    this.registry.on('request.assigned', async ({ outboxId, payload }) => {
      const job = await this.prisma.job.findUniqueOrThrow({
        where: { id: payload.jobId },
        include: { request: { select: { cityId: true, category: { select: { name: true } } } } },
      });
      await this.matching.cancelPendingJobs(job.requestId);
      const notified = (
        await this.prisma.requestNotification.findMany({
          where: { requestId: job.requestId },
          select: { workerId: true },
        })
      ).map((n) => n.workerId);
      const others = notified.filter((id) => id !== job.workerId);

      // Las dos partes reciben el jobId (para pedir el contacto); los demás, solo el aviso.
      this.realtime.toUsers([job.employerId, job.workerId], 'request:assigned', {
        requestId: job.requestId,
        jobId: job.id,
      });
      this.realtime.toUsers(others, 'request:assigned', { requestId: job.requestId, jobId: null });
      this.realtime.toUsers(others, 'offer:closed', {
        requestId: job.requestId,
        reason: 'elegida_otra',
      });
      this.realtime.leaveRequest(job.requestId);

      await this.withdrawOtherOffers(job.workerId, job.requestId);

      await this.notifications.notify({
        userId: job.workerId,
        cityId: job.request.cityId,
        type: 'request_assigned_worker',
        data: { requestId: job.requestId, jobId: job.id, category: job.request.category.name },
        dedupeKey: `${outboxId}:${job.workerId}`,
      });
    });
  }
  /**
   * El trabajador elegido ya no puede tomar otra: se retiran sus ofertas activas en otras
   * solicitudes (cada una en su transacción, con su solicitud bloqueada). El empleador de
   * cada una recibe offer:closed por offer.withdrawn; si era la única, sigue el matching.
   */
  private async withdrawOtherOffers(workerId: string, assignedRequestId: string): Promise<void> {
    const offers = await this.prisma.offer.findMany({
      where: { workerId, status: 'activa', requestId: { not: assignedRequestId } },
      select: { id: true, requestId: true },
    });
    for (const offer of offers) {
      await this.prisma.$transaction(async (tx) => {
        const request = await lockRequest(tx, offer.requestId);
        const current = await tx.offer.findUnique({
          where: { id: offer.id },
          select: { status: true },
        });
        if (!request || current?.status !== 'activa') return;
        if (request.status !== 'buscando' && request.status !== 'con_ofertas') return;
        await withdrawLockedOffer(
          tx,
          { status: this.status, outbox: this.outbox },
          request,
          offer.id,
          null,
        );
      });
    }
  }
}

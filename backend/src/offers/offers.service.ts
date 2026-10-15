import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CategoryResolver } from '../categories/category-resolver';
import { toBs } from '../categories/effective-category';
import { ApiError } from '../common/errors/api-error';
import { RateLimitStore } from '../common/rate-limit/rate-limit.store';
import { RateLimitedException } from '../common/rate-limit/rate-limited.exception';
import type { AppConfigService } from '../config/app-config';
import { exclusionOf } from '../matching/candidates';
import { DEBT_CAP_POLICY, type DebtCapPolicy } from '../matching/debt-cap.policy';
import type { MatchingConfig } from '../matching/matching.config';
import { MATCHING_CONFIG } from '../matching/matching-config.provider';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { lockRequest } from '../requests/request-lock';
import { RequestStatusService } from '../requests/request-status.service';
import { StorageService } from '../storage/storage.service';
import type {
  AcceptOfferResultDto,
  CreateOfferDto,
  EmployerOfferDto,
  IncomingRequestDto,
  JobContactDto,
  MyOfferDto,
} from './dto/offer.dto';
import {
  counterCap,
  estimateEtaMin,
  notEligibleMessage,
  offerAmount,
  parseSpeeds,
  shortName,
  type TransportMode,
} from './offer.rules';
import { OffersRepository } from './offers.repository';

const OPEN = new Set(['buscando', 'con_ofertas']);

const notFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'REQUEST_NOT_FOUND', 'La solicitud no existe.');

const offersClosed = (): ApiError =>
  new ApiError(HttpStatus.CONFLICT, 'OFFERS_CLOSED', 'Esta solicitud ya no recibe ofertas.');

/** Ofertas, aceptación y contacto (R5, ADR-0026). */
@Injectable()
export class OffersService {
  private readonly speeds: Record<TransportMode, number>;
  private readonly routeFactor: number;
  private readonly maxFactor: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly repo: OffersRepository,
    private readonly status: RequestStatusService,
    private readonly outbox: OutboxService,
    private readonly categories: CategoryResolver,
    private readonly storage: StorageService,
    private readonly rateLimits: RateLimitStore,
    @Inject(DEBT_CAP_POLICY) private readonly debt: DebtCapPolicy,
    @Inject(MATCHING_CONFIG) private readonly matching: MatchingConfig,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {
    this.speeds = parseSpeeds(config.get('ETA_SPEEDS_KMH', { infer: true }));
    this.routeFactor = config.get('ETA_ROUTE_FACTOR', { infer: true });
    this.maxFactor = config.get('OFFER_COUNTER_MAX_FACTOR', { infer: true });
  }

  // ---- Trabajador ----

  /** Ofertar o reemplazar la oferta (R5.2). La primera oferta pasa la solicitud a con_ofertas. */
  async createOrReplace(
    workerId: string,
    requestId: string,
    dto: CreateOfferDto,
  ): Promise<MyOfferDto> {
    const decision = await this.rateLimits.consume([
      {
        key: `offer:create:user:${workerId}`,
        limit: this.config.get('RATE_OFFER_PER_MIN', { infer: true }),
        windowSec: 60,
      },
    ]);
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);

    const offer = await this.prisma.$transaction(async (tx) => {
      const request = await lockRequest(tx, requestId);
      const notified = request
        ? await tx.requestNotification.findUnique({
            where: { requestId_workerId: { requestId, workerId } },
          })
        : null;
      // Un no notificado no sabe que la solicitud existe (no se revela).
      if (!request || !notified) throw notFound();
      if (!OPEN.has(request.status)) throw offersClosed();

      const worker = await this.repo.offeringWorker(tx, requestId, workerId);
      if (!worker) throw notFound();
      const blocked = await this.debt.ineligible([workerId]);
      const reason = exclusionOf(worker, {
        ring: { maxKm: Number.POSITIVE_INFINITY, limit: 1 },
        employerId: request.employerId,
        now: Date.now(),
        staleLocationMs: this.matching.staleLocationMs,
        debtEligible: (id) => !blocked.has(id),
      });
      if (reason) {
        throw new ApiError(HttpStatus.CONFLICT, 'NOT_ELIGIBLE', notEligibleMessage(reason), {
          reason,
        });
      }

      const category = await this.categories.forCity(request.categoryId, request.cityId);
      if (!category) throw notFound();
      const amountBs = offerAmount({
        type: dto.type,
        amountBs: dto.amountBs,
        proposedPriceBs: request.proposedPriceBs,
        priceMaxBs: toBs(category.priceMaxBs),
        maxFactor: this.maxFactor,
      });
      const etaMin = estimateEtaMin(
        worker.distanceM,
        worker.transport,
        this.speeds,
        this.routeFactor,
      );

      const existing = await tx.offer.findUnique({
        where: { requestId_workerId: { requestId, workerId } },
      });
      if (existing && existing.status !== 'activa') throw offersClosed();
      const saved = existing
        ? await tx.offer.update({
            where: { id: existing.id },
            data: {
              type: dto.type,
              amountBs,
              etaMin,
              distanceM: worker.distanceM,
              revision: { increment: 1 },
            },
          })
        : await tx.offer.create({
            data: {
              requestId,
              workerId,
              cityId: request.cityId,
              type: dto.type,
              amountBs,
              etaMin,
              distanceM: worker.distanceM,
            },
          });

      if (request.status === 'buscando') {
        await this.status.apply(requestId, 'RECEIVE_OFFER', workerId, {}, tx);
      }
      await this.outbox.add(tx, 'offer.created', requestId, {
        requestId,
        offerId: saved.id,
        revision: saved.revision,
      });
      return saved;
    });
    return toMyOffer(offer);
  }

  /** Solicitudes que le llegaron (para la bandeja y para resincronizar al reconectar). */
  async incoming(workerId: string): Promise<IncomingRequestDto[]> {
    const since = new Date(Date.now() - 24 * 3600_000);
    const notifications = await this.prisma.requestNotification.findMany({
      where: { workerId, notifiedAt: { gte: since } },
      orderBy: { notifiedAt: 'desc' },
      take: 50,
      select: { requestId: true },
    });
    return Promise.all(notifications.map((n) => this.incomingOne(workerId, n.requestId)));
  }

  async incomingOne(workerId: string, requestId: string): Promise<IncomingRequestDto> {
    const notification = await this.prisma.requestNotification.findUnique({
      where: { requestId_workerId: { requestId, workerId } },
      include: {
        request: {
          include: {
            category: { select: { slug: true, name: true } },
            photos: { orderBy: { position: 'asc' } },
            job: { select: { id: true, workerId: true } },
            offers: { where: { workerId } },
          },
        },
      },
    });
    if (!notification) throw notFound();
    const r = notification.request;
    const category = await this.categories.forCity(r.categoryId, r.cityId);
    if (!category) throw notFound();
    const ttl = this.config.get('REQUEST_PHOTO_URL_TTL_SEC', { infer: true });
    const mine = r.offers[0];
    const chosen = r.job?.workerId === workerId;
    return {
      requestId: r.id,
      outcome: OPEN.has(r.status)
        ? 'abierta'
        : r.status === 'asignada'
          ? chosen
            ? 'elegido'
            : 'elegida_otra'
          : r.status === 'cancelada'
            ? 'cancelada'
            : 'expirada',
      category: r.category,
      description: r.description,
      distanceM: notification.distanceM,
      proposedPriceBs: toBs(r.proposedPriceBs),
      referenceRange: { minBs: toBs(category.priceMinBs), maxBs: toBs(category.priceMaxBs) },
      maxCounterBs: counterCap(toBs(category.priceMaxBs), this.maxFactor),
      // Fotos solo para notificados (este método exige la notificación).
      photos: await Promise.all(
        r.photos.map(async (p) => ({
          id: p.id,
          position: p.position,
          url: await this.storage.presignDownload(p.fileKey, ttl),
        })),
      ),
      ring: notification.ring,
      respondBy: new Date(
        notification.notifiedAt.getTime() + this.matching.ringWaitMs,
      ).toISOString(),
      myOffer: mine ? toMyOffer(mine) : null,
      jobId: chosen ? (r.job?.id ?? null) : null,
      notifiedAt: notification.notifiedAt.toISOString(),
    };
  }

  // ---- Empleador ----

  /** Ofertas activas en vivo (R5.3): precio, calificación, ETA y nombre corto. */
  async listForEmployer(employerId: string, requestId: string): Promise<EmployerOfferDto[]> {
    const request = await this.prisma.serviceRequest.findUnique({
      where: { id: requestId },
      select: { employerId: true },
    });
    if (request?.employerId !== employerId) throw notFound();
    const offers = await this.prisma.offer.findMany({
      where: { requestId, status: { in: ['activa', 'aceptada'] } },
      orderBy: [{ amountBs: 'asc' }, { etaMin: 'asc' }],
      include: {
        worker: {
          select: { ratingAvg: true, ratingCount: true, user: { select: { name: true } } },
        },
      },
    });
    return offers.map((o) => ({
      id: o.id,
      type: o.type,
      amountBs: toBs(o.amountBs),
      etaMin: o.etaMin,
      distanceM: o.distanceM,
      revision: o.revision,
      worker: {
        shortName: shortName(o.worker.user.name),
        ratingAvg: toBs(o.worker.ratingAvg),
        ratingCount: o.worker.ratingCount,
      },
      updatedAt: o.updatedAt.toISOString(),
    }));
  }

  /**
   * Elegir una oferta (R5.4). En una transacción con la solicitud bloqueada: crea el
   * trabajo, pasa la solicitud a asignada y cierra las demás ofertas. Una segunda
   * aceptación concurrente espera el bloqueo y recibe 409.
   */
  async accept(
    employerId: string,
    requestId: string,
    offerId: string,
  ): Promise<AcceptOfferResultDto> {
    return this.prisma.$transaction(async (tx) => {
      const request = await lockRequest(tx, requestId);
      if (request?.employerId !== employerId) throw notFound();
      if (request.status === 'asignada') {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'REQUEST_ALREADY_ASSIGNED',
          'Ya elegiste un trabajador para esta solicitud.',
        );
      }
      if (request.status !== 'con_ofertas') throw offersClosed();
      const offer = await tx.offer.findFirst({
        where: { id: offerId, requestId, status: 'activa' },
      });
      if (!offer) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'OFFER_NOT_AVAILABLE',
          'Esa oferta ya no está disponible. Elige otra.',
        );
      }
      const category = await this.categories.forCity(request.categoryId, request.cityId);
      if (!category) throw notFound();

      const job = await tx.job.create({
        data: {
          requestId,
          workerId: offer.workerId,
          employerId,
          cityId: request.cityId,
          offerId: offer.id,
          finalPriceBs: offer.amountBs,
          commissionPct: category.commissionPct,
        },
      });
      await this.status.apply(requestId, 'ASSIGN', employerId, { data: { expiresAt: null } }, tx);
      await tx.offer.update({ where: { id: offer.id }, data: { status: 'aceptada' } });
      await tx.offer.updateMany({
        where: { requestId, status: 'activa' },
        data: { status: 'cerrada' },
      });
      await this.outbox.add(tx, 'request.assigned', requestId, { requestId, jobId: job.id });
      return { jobId: job.id, requestId };
    });
  }

  // ---- Contacto ----

  /** Teléfono de la contraparte, solo para las dos partes del trabajo (R5.4, R9.4). */
  async contact(userId: string, jobId: string): Promise<JobContactDto> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      include: {
        worker: { select: { name: true, phone: true } },
        employer: { select: { name: true, phone: true } },
        request: { select: { address: true } },
      },
    });
    if (!job || (job.employerId !== userId && job.workerId !== userId)) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'JOB_NOT_FOUND', 'El trabajo no existe.');
    }
    const iAmEmployer = job.employerId === userId;
    const other = iAmEmployer ? job.worker : job.employer;
    return {
      jobId: job.id,
      role: iAmEmployer ? 'worker' : 'employer',
      name: other.name,
      phone: other.phone,
      address: iAmEmployer ? null : job.request.address,
      finalPriceBs: toBs(job.finalPriceBs),
    };
  }
}

function toMyOffer(o: {
  id: string;
  type: 'accept' | 'counter';
  amountBs: { toFixed(n: number): string };
  etaMin: number;
  status: 'activa' | 'aceptada' | 'cerrada';
  revision: number;
  updatedAt: Date;
}): MyOfferDto {
  return {
    id: o.id,
    type: o.type,
    amountBs: o.amountBs.toFixed(2),
    etaMin: o.etaMin,
    status: o.status,
    revision: o.revision,
    updatedAt: o.updatedAt.toISOString(),
  };
}

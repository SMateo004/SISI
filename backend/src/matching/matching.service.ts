import { Inject, Injectable, Logger } from '@nestjs/common';
import { FeatureFlagsService } from '../feature-flags/feature-flags.service';
import type { Prisma } from '../generated/prisma/client';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { BullJobPublisher } from '../queues/bull-job.publisher';
import { jobIds, MATCHING_JOBS, QUEUES } from '../queues/queues';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { type LockedRequest, lockRequest } from '../requests/request-lock';
import { RequestStatusService } from '../requests/request-status.service';
import { selectCandidates } from './candidates';
import { DEBT_CAP_POLICY, type DebtCapPolicy } from './debt-cap.policy';
import { expectedMatchingJob } from './expected-job';
import type { MatchingConfig, RingConfig } from './matching.config';
import { MATCHING_CONFIG } from './matching-config.provider';
import { MatchingRepository } from './matching.repository';
import { closeDecision, closeDelay, nextStep, rescanDelay, shouldExpand } from './ring-plan';

const OPEN = new Set(['buscando', 'con_ofertas']);

/** Interruptor por ciudad (R10.2): con el flag apagado el matching queda en pausa. */
export const MATCHING_FLAG = 'matching.enabled';

export class MatchingPausedError extends Error {
  constructor(cityId: string) {
    super(`Matching en pausa en la ciudad ${cityId} (flag ${MATCHING_FLAG} apagado)`);
  }
}

type RingOutcome =
  | { kind: 'skip' }
  | {
      kind: 'ran';
      notified: number;
      lastNotifiedAt: number | null;
      employerId: string;
      closeSeq: number;
    }
  | { kind: 'enough'; lastNotifiedAt: number | null; closeSeq: number };

type CloseOutcome =
  | { kind: 'skip' }
  | { kind: 'grace'; expiresAt: number; closeSeq: number }
  | { kind: 'rescan'; delayMs: number; closeSeq: number; notified: number }
  | { kind: 'expired' };

/**
 * Matching por anillos (R4, ADR-0025). Cada paso es un job de BullMQ con jobId
 * determinístico; cada uno bloquea la solicitud (`FOR UPDATE`) y revisa su estado, así
 * que repetir un job no repite avisos ni transiciones.
 */
@Injectable()
export class MatchingService {
  private readonly logger = new Logger('Matching');

  constructor(
    private readonly prisma: PrismaService,
    private readonly repo: MatchingRepository,
    private readonly status: RequestStatusService,
    private readonly outbox: OutboxService,
    private readonly flags: FeatureFlagsService,
    private readonly publisher: BullJobPublisher,
    private readonly realtime: RealtimeEmitter,
    @Inject(DEBT_CAP_POLICY) private readonly debt: DebtCapPolicy,
    @Inject(MATCHING_CONFIG) private readonly config: MatchingConfig,
  ) {}

  /** Anillo `ring` (R4.2): elige candidatos, los registra y programa el paso siguiente. */
  async runRing(requestId: string, ring: number): Promise<RingOutcome> {
    const ringConfig = this.config.rings[ring - 1];
    if (!ringConfig) return { kind: 'skip' };
    const now = Date.now();

    const outcome = await this.prisma.$transaction(async (tx): Promise<RingOutcome> => {
      const request = await lockRequest(tx, requestId);
      if (!request || !OPEN.has(request.status) || (request.ring ?? 0) >= ring) {
        return { kind: 'skip' };
      }
      await this.assertEnabled(request.cityId);
      const activeOffers = await tx.offer.count({ where: { requestId, status: 'activa' } });
      if (!shouldExpand(ring, activeOffers, this.config.enoughOffers)) {
        return {
          kind: 'enough',
          lastNotifiedAt: await this.lastNotifiedAt(tx, requestId),
          closeSeq: request.closeSeq,
        };
      }
      const notified = await this.notifyCandidates(tx, request, ring, ringConfig, now);
      return {
        kind: 'ran',
        notified,
        lastNotifiedAt: await this.lastNotifiedAt(tx, requestId),
        employerId: request.employerId,
        closeSeq: request.closeSeq,
      };
    });

    if (outcome.kind === 'ran') {
      if (ring === 1) this.realtime.joinRequest([outcome.employerId], requestId);
      this.logger.log(`Solicitud ${requestId}: anillo ${ring}, ${outcome.notified} avisados`);
      const step = nextStep({
        ring,
        notifiedNow: outcome.notified,
        now,
        lastNotifiedAt: outcome.lastNotifiedAt,
        config: this.config,
      });
      if (step.kind === 'ring') await this.scheduleRing(requestId, step.ring, step.delayMs);
      else await this.scheduleClose(requestId, outcome.closeSeq, step.delayMs);
    } else if (outcome.kind === 'enough') {
      this.logger.log(
        `Solicitud ${requestId}: ofertas suficientes, no se amplía al anillo ${ring}`,
      );
      await this.scheduleClose(
        requestId,
        outcome.closeSeq,
        closeDelay(now, outcome.lastNotifiedAt, this.config.ringWaitMs),
      );
    }
    return outcome;
  }

  /**
   * Fin de la búsqueda (R4.5): con ofertas da plazo para elegir; sin ofertas, mientras no
   * se cumpla el tiempo mínimo vuelve a buscar en el último anillo; después expira.
   * `seq` identifica el cierre programado: uno viejo (de antes de una reprogramación) no hace nada.
   */
  async close(requestId: string, seq: number): Promise<CloseOutcome> {
    const now = Date.now();
    const outcome = await this.prisma.$transaction(async (tx): Promise<CloseOutcome> => {
      const request = await lockRequest(tx, requestId);
      if (!request || !OPEN.has(request.status) || request.expiresAt) return { kind: 'skip' };
      if (request.closeSeq !== seq) return { kind: 'skip' };
      const activeOffers = await tx.offer.count({ where: { requestId, status: 'activa' } });
      const publishedAt = (request.publishedAt ?? new Date(now)).getTime();
      const decision = closeDecision({
        activeOffers,
        now,
        publishedAt,
        offersGraceMs: this.config.offersGraceMs,
        minSearchMs: this.config.minSearchMs,
      });

      if (decision.kind === 'expire') {
        await this.expireIn(tx, requestId);
        return { kind: 'expired' };
      }
      // Cada cierre o expiración nuevo usa otro número: BullMQ ignora un jobId repetido.
      const closeSeq = request.closeSeq + 1;
      if (decision.kind === 'grace') {
        await tx.serviceRequest.update({
          where: { id: requestId },
          data: { expiresAt: new Date(decision.expiresAt), closeSeq },
        });
        return { kind: 'grace', expiresAt: decision.expiresAt, closeSeq };
      }

      await this.assertEnabled(request.cityId);
      const lastRing = this.config.rings.length;
      const ringConfig = this.config.rings[lastRing - 1];
      if (!ringConfig) return { kind: 'skip' };
      const notified = await this.notifyCandidates(tx, request, lastRing, ringConfig, now);
      await tx.serviceRequest.update({ where: { id: requestId }, data: { closeSeq } });
      return {
        kind: 'rescan',
        notified,
        closeSeq,
        delayMs: rescanDelay({
          now,
          publishedAt,
          minSearchMs: this.config.minSearchMs,
          rescanMs: this.config.rescanMs,
          lastNotifiedAt: await this.lastNotifiedAt(tx, requestId),
          ringWaitMs: this.config.ringWaitMs,
        }),
      };
    });

    if (outcome.kind === 'grace') {
      await this.scheduleExpire(requestId, outcome.closeSeq, outcome.expiresAt - now);
    } else if (outcome.kind === 'rescan') {
      this.logger.log(
        `Solicitud ${requestId}: sin ofertas, se vuelve a buscar (${outcome.notified} avisados)`,
      );
      await this.scheduleClose(requestId, outcome.closeSeq, outcome.delayMs);
    }
    return outcome;
  }

  /** Vence el plazo para elegir: expira y cierra las ofertas. */
  async expire(requestId: string, seq: number): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const request = await lockRequest(tx, requestId);
      if (!request || !OPEN.has(request.status) || !request.expiresAt) return;
      if (request.closeSeq !== seq || request.expiresAt.getTime() > Date.now()) return;
      await this.expireIn(tx, requestId);
    });
  }

  /**
   * Retoma el matching de una solicitud abierta (p. ej. tras retirarse la última oferta):
   * encola el paso que corresponde según la base, igual que el reconciliador.
   */
  async resume(requestId: string): Promise<void> {
    const request = await this.prisma.serviceRequest.findUnique({
      where: { id: requestId },
      select: {
        id: true,
        status: true,
        ring: true,
        ringStartedAt: true,
        expiresAt: true,
        closeSeq: true,
      },
    });
    if (!request || !OPEN.has(request.status)) return;
    await this.publisher.publish(
      expectedMatchingJob(request as Parameters<typeof expectedMatchingJob>[0], {
        totalRings: this.config.rings.length,
        ringWaitMs: this.config.ringWaitMs,
        now: Date.now(),
      }),
    );
  }

  /** Quita de la cola los pasos pendientes (al cancelar o asignar). */
  async cancelPendingJobs(requestId: string): Promise<void> {
    const request = await this.prisma.serviceRequest.findUnique({
      where: { id: requestId },
      select: { closeSeq: true },
    });
    const seq = request?.closeSeq ?? 0;
    const queue = this.publisher.queue(QUEUES.matching);
    const ids = [
      ...this.config.rings.map((_, i) => jobIds.ring(requestId, i + 1)),
      jobIds.close(requestId, seq),
      jobIds.expire(requestId, seq),
    ];
    for (const id of ids) {
      const job = await queue.getJob(id);
      if (!job) continue;
      const state = await job.getState();
      // Los activos terminan solos: revisan el estado bajo bloqueo y no hacen nada.
      if (state === 'delayed' || state === 'waiting' || state === 'prioritized') {
        await job.remove();
      }
    }
  }

  /** Elige y registra candidatos nuevos de un anillo; escribe un request.notified por cada uno. */
  private async notifyCandidates(
    tx: Prisma.TransactionClient,
    request: LockedRequest,
    ring: number,
    ringConfig: RingConfig,
    now: number,
  ): Promise<number> {
    const rows = await this.repo.nearbyWorkers(tx, request.id, ringConfig.maxKm);
    const blocked = await this.debt.ineligible(rows.map((r) => r.workerId));
    const chosen = selectCandidates(rows, {
      ring: ringConfig,
      employerId: request.employerId,
      now,
      staleLocationMs: this.config.staleLocationMs,
      debtEligible: (id) => !blocked.has(id),
    });

    const startedAt = new Date(now);
    const respondBy = new Date(now + this.config.ringWaitMs).toISOString();
    if (chosen.length > 0) {
      await tx.requestNotification.createMany({
        data: chosen.map((c) => ({
          requestId: request.id,
          workerId: c.workerId,
          cityId: request.cityId,
          ring,
          distanceM: c.distanceM,
          notifiedAt: startedAt,
        })),
        skipDuplicates: true,
      });
    }
    await tx.serviceRequest.update({
      where: { id: request.id },
      data: { ring, ringStartedAt: startedAt },
    });
    for (const c of chosen) {
      await this.outbox.add(tx, 'request.notified', request.id, {
        requestId: request.id,
        workerId: c.workerId,
        ring,
        distanceM: c.distanceM,
        respondBy,
      });
    }
    return chosen.length;
  }

  private async assertEnabled(cityId: string): Promise<void> {
    if (!(await this.flags.isEnabled(MATCHING_FLAG, cityId))) {
      // El job falla y BullMQ lo reintenta; luego lo retoma el reconciliador.
      throw new MatchingPausedError(cityId);
    }
  }

  private async expireIn(tx: Prisma.TransactionClient, requestId: string): Promise<void> {
    await this.status.apply(requestId, 'EXPIRE', null, { reason: 'Sin asignar a tiempo' }, tx);
    await tx.offer.updateMany({
      where: { requestId, status: 'activa' },
      data: { status: 'cerrada' },
    });
    await this.outbox.add(tx, 'request.expired', requestId, { requestId });
  }

  private async lastNotifiedAt(
    tx: Prisma.TransactionClient,
    requestId: string,
  ): Promise<number | null> {
    const agg = await tx.requestNotification.aggregate({
      where: { requestId },
      _max: { notifiedAt: true },
    });
    return agg._max.notifiedAt?.getTime() ?? null;
  }

  private scheduleRing(requestId: string, ring: number, delayMs: number): Promise<void> {
    return this.publisher.publish({
      queue: QUEUES.matching,
      name: MATCHING_JOBS.ring,
      jobId: jobIds.ring(requestId, ring),
      data: { requestId, ring },
      delayMs,
    });
  }

  private scheduleClose(requestId: string, seq: number, delayMs: number): Promise<void> {
    return this.publisher.publish({
      queue: QUEUES.matching,
      name: MATCHING_JOBS.close,
      jobId: jobIds.close(requestId, seq),
      data: { requestId, seq },
      delayMs,
    });
  }

  private scheduleExpire(requestId: string, seq: number, delayMs: number): Promise<void> {
    return this.publisher.publish({
      queue: QUEUES.matching,
      name: MATCHING_JOBS.expire,
      jobId: jobIds.expire(requestId, seq),
      data: { requestId, seq },
      delayMs,
    });
  }
}

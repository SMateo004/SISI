import { Inject, Injectable, Logger } from '@nestjs/common';
import { FeatureFlagsService } from '../feature-flags/feature-flags.service';
import type { Prisma } from '../generated/prisma/client';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { BullJobPublisher } from '../queues/bull-job.publisher';
import { jobIds, MATCHING_JOBS, QUEUES } from '../queues/queues';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { RequestStatusService } from '../requests/request-status.service';
import { selectCandidates } from './candidates';
import { DEBT_CAP_POLICY, type DebtCapPolicy } from './debt-cap.policy';
import type { MatchingConfig } from './matching.config';
import { MATCHING_CONFIG } from './matching-config.provider';
import { MatchingRepository } from './matching.repository';
import { closeDecision, closeDelay, nextStep, shouldExpand } from './ring-plan';

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
  | { kind: 'ran'; notified: number; lastNotifiedAt: number | null; employerId: string }
  | { kind: 'enough'; lastNotifiedAt: number | null };

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
      const request = await this.repo.lockRequest(tx, requestId);
      if (!request || !OPEN.has(request.status) || (request.ring ?? 0) >= ring) {
        return { kind: 'skip' };
      }
      if (!(await this.flags.isEnabled(MATCHING_FLAG, request.cityId))) {
        // El job falla y BullMQ lo reintenta; luego lo retoma el reconciliador.
        throw new MatchingPausedError(request.cityId);
      }
      const activeOffers = await tx.offer.count({ where: { requestId, status: 'activa' } });
      if (!shouldExpand(ring, activeOffers, this.config.enoughOffers)) {
        return { kind: 'enough', lastNotifiedAt: await this.lastNotifiedAt(tx, requestId) };
      }

      const rows = await this.repo.nearbyWorkers(tx, requestId, ringConfig.maxKm);
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
            requestId,
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
        where: { id: requestId },
        data: { ring, ringStartedAt: startedAt },
      });
      for (const c of chosen) {
        await this.outbox.add(tx, 'request.notified', requestId, {
          requestId,
          workerId: c.workerId,
          ring,
          distanceM: c.distanceM,
          respondBy,
        });
      }
      return {
        kind: 'ran',
        notified: chosen.length,
        lastNotifiedAt: await this.lastNotifiedAt(tx, requestId),
        employerId: request.employerId,
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
      if (step.kind === 'ring') await this.schedule('ring', requestId, step.delayMs, step.ring);
      else await this.schedule('close', requestId, step.delayMs);
    } else if (outcome.kind === 'enough') {
      this.logger.log(
        `Solicitud ${requestId}: ofertas suficientes, no se amplía al anillo ${ring}`,
      );
      await this.schedule(
        'close',
        requestId,
        closeDelay(now, outcome.lastNotifiedAt, this.config.ringWaitMs),
      );
    }
    return outcome;
  }

  /** Fin de la búsqueda (R4.5): sin ofertas expira; con ofertas da plazo para elegir. */
  async close(requestId: string): Promise<void> {
    const now = Date.now();
    const expiresAt = await this.prisma.$transaction(async (tx) => {
      const request = await this.repo.lockRequest(tx, requestId);
      if (!request || !OPEN.has(request.status) || request.expiresAt) return null;
      const activeOffers = await tx.offer.count({ where: { requestId, status: 'activa' } });
      const decision = closeDecision(activeOffers, now, this.config.offersGraceMs);
      if (decision.expireNow) {
        await this.expireIn(tx, requestId);
        return null;
      }
      await tx.serviceRequest.update({
        where: { id: requestId },
        data: { expiresAt: new Date(decision.expiresAt) },
      });
      return decision.expiresAt;
    });
    if (expiresAt !== null) await this.schedule('expire', requestId, expiresAt - now);
  }

  /** Vence el plazo para elegir: expira y cierra las ofertas. */
  async expire(requestId: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const request = await this.repo.lockRequest(tx, requestId);
      if (!request || !OPEN.has(request.status) || !request.expiresAt) return;
      if (request.expiresAt.getTime() > Date.now()) return;
      await this.expireIn(tx, requestId);
    });
  }

  /** Quita de la cola los pasos pendientes (al cancelar o asignar). */
  async cancelPendingJobs(requestId: string): Promise<void> {
    const queue = this.publisher.queue(QUEUES.matching);
    const ids = [
      ...this.config.rings.map((_, i) => jobIds.ring(requestId, i + 1)),
      jobIds.close(requestId),
      jobIds.expire(requestId),
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

  private async schedule(
    step: 'ring' | 'close' | 'expire',
    requestId: string,
    delayMs: number,
    ring?: number,
  ): Promise<void> {
    const jobId =
      step === 'ring'
        ? jobIds.ring(requestId, ring ?? 1)
        : step === 'close'
          ? jobIds.close(requestId)
          : jobIds.expire(requestId);
    await this.publisher.publish({
      queue: QUEUES.matching,
      name: MATCHING_JOBS[step],
      jobId,
      data: step === 'ring' ? { requestId, ring } : { requestId },
      delayMs,
    });
  }
}

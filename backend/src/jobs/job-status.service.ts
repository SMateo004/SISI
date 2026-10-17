import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import { Prisma } from '../generated/prisma/client';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { RequestStatusService } from '../requests/request-status.service';
import { commissionOf } from './commission';
import {
  type JobAction,
  type JobActorRole,
  type JobStatus,
  nextJobStatus,
} from './job-status.machine';

export interface JobActor {
  role: JobActorRole;
  /** null = sistema. */
  id: string | null;
}

export interface LockedJob {
  id: string;
  requestId: string;
  workerId: string;
  employerId: string;
  cityId: string;
  status: JobStatus;
  finalPriceBs: Prisma.Decimal;
  commissionPct: Prisma.Decimal;
  workerFinishedAt: Date | null;
  disputedAt: Date | null;
}

export interface JobTransition {
  job: LockedJob;
  from: JobStatus;
  to: JobStatus;
}

export const jobNotFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'JOB_NOT_FOUND', 'El trabajo no existe.');

/**
 * Único punto que cambia jobs.status y sus marcas (ADR-0029): bloquea la fila, valida con
 * la máquina de estados (actor incluido), guarda el timestamp de la acción, deja el
 * historial en job_events y escribe los eventos en el outbox en la misma transacción.
 * Al terminar calcula la comisión (ADR-0030) y emite job.completed.
 */
@Injectable()
export class JobStatusService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly outbox: OutboxService,
    private readonly requests: RequestStatusService,
  ) {}

  async apply(
    jobId: string,
    action: JobAction,
    actor: JobActor,
    extra: { data?: Prisma.JobUncheckedUpdateInput; note?: string } = {},
    tx?: Prisma.TransactionClient,
  ): Promise<JobTransition> {
    if (tx) return this.applyIn(tx, jobId, action, actor, extra);
    return this.prisma.$transaction((t) => this.applyIn(t, jobId, action, actor, extra));
  }

  private async applyIn(
    tx: Prisma.TransactionClient,
    jobId: string,
    action: JobAction,
    actor: JobActor,
    extra: { data?: Prisma.JobUncheckedUpdateInput; note?: string },
  ): Promise<JobTransition> {
    const job = await lockJob(tx, jobId);
    if (!job) throw jobNotFound();
    // Una parte solo actúa sobre su propio trabajo; a un tercero no se le revela.
    if (
      (actor.role === 'worker' && actor.id !== job.workerId) ||
      (actor.role === 'employer' && actor.id !== job.employerId)
    ) {
      throw jobNotFound();
    }
    const to = nextJobStatus(job, action, actor.role);
    const now = new Date();
    const data: Prisma.JobUncheckedUpdateInput = { ...extra.data, status: to };
    switch (action) {
      case 'START_TRIP':
        data.onTheWayAt = now;
        break;
      case 'START_WORK':
        data.startedAt = now;
        break;
      case 'FINISH':
        data.workerFinishedAt = now;
        break;
      case 'DISPUTE':
        data.disputedAt = now;
        break;
      case 'CANCEL':
      case 'RESOLVE_CANCEL':
        data.cancelledAt = now;
        data.cancelledByRole = actor.role;
        data.cancelledById = actor.id;
        break;
      case 'CONFIRM':
      case 'AUTO_CONFIRM':
      case 'RESOLVE_CONFIRM':
        data.completedAt = now;
        data.autoConfirmed = action === 'AUTO_CONFIRM';
        data.commissionBs = commissionOf(job.finalPriceBs, job.commissionPct);
        break;
    }
    await tx.job.update({ where: { id: jobId }, data });
    await tx.jobEvent.create({
      data: {
        jobId,
        action,
        fromStatus: job.status,
        toStatus: to,
        actorRole: actor.role,
        actorId: actor.id,
        note: extra.note,
      },
    });

    if (to === 'cancelado') {
      await this.requests.apply(job.requestId, 'JOB_CANCELLED', actor.id, { reason: action }, tx);
    }
    // Sin penalidad por ahora: solo se cuenta (Fase 4, docs/pendientes.md).
    if (action === 'CANCEL' && actor.id) {
      await tx.user.update({
        where: { id: actor.id },
        data: { cancellationsCount: { increment: 1 } },
      });
    }
    await this.outbox.add(tx, 'job.status_changed', jobId, {
      jobId,
      action,
      from: job.status,
      to,
      actorRole: actor.role,
    });
    if (to === 'terminado') {
      await this.outbox.add(tx, 'job.completed', jobId, {
        jobId,
        workerId: job.workerId,
        cityId: job.cityId,
        finalPriceBs: job.finalPriceBs.toFixed(2),
        commissionPct: job.commissionPct.toFixed(2),
        commissionBs: (data.commissionBs as Prisma.Decimal).toFixed(2),
        completedAt: now.toISOString(),
      });
    }
    return { job, from: job.status, to };
  }
}

/** `SELECT … FOR UPDATE` del trabajo: las acciones de un mismo trabajo van en serie. */
export async function lockJob(
  tx: Prisma.TransactionClient,
  jobId: string,
): Promise<LockedJob | null> {
  const [row] = await tx.$queryRaw<
    (Omit<LockedJob, 'finalPriceBs' | 'commissionPct'> & {
      finalPriceBs: string;
      commissionPct: string;
    })[]
  >`
    SELECT id, request_id AS "requestId", worker_id AS "workerId",
           employer_id AS "employerId", city_id AS "cityId", status::text AS status,
           final_price_bs::text AS "finalPriceBs", commission_pct::text AS "commissionPct",
           worker_finished_at AS "workerFinishedAt", disputed_at AS "disputedAt"
    FROM jobs WHERE id = ${jobId}::uuid FOR UPDATE`;
  if (!row) return null;
  return {
    ...row,
    finalPriceBs: new Prisma.Decimal(row.finalPriceBs),
    commissionPct: new Prisma.Decimal(row.commissionPct),
  };
}

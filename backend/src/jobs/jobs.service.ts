import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { ModerationService } from '../moderation/moderation.service';
import type { Prisma } from '../generated/prisma/client';
import { shortName } from '../offers/offer.rules';
import { PrismaService } from '../prisma/prisma.service';
import { jobReviews } from '../reviews/reviews.service';
import { netOf } from './commission';
import type { AdminDisputedJobDto, JobCancelReason, JobDto, JobPageDto } from './dto/job.dto';
import { allowedJobActions, type JobAction, type JobActorRole } from './job-status.machine';
import { jobNotFound, JobStatusService } from './job-status.service';

const jobInclude = {
  request: {
    select: { description: true, category: { select: { slug: true, name: true } } },
  },
  worker: { select: { name: true } },
  employer: { select: { name: true } },
  reviews: true,
} satisfies Prisma.JobInclude;

type JobRow = Prisma.JobGetPayload<{ include: typeof jobInclude }>;

const iso = (d: Date | null): string | null => d?.toISOString() ?? null;

/** Trabajos para las dos partes (R6, ADR-0029). Los cambios pasan por JobStatusService. */
@Injectable()
export class JobsService {
  private readonly autoConfirmMs: number;
  private readonly reviewWindowMs: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly status: JobStatusService,
    private readonly moderation: ModerationService,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.autoConfirmMs = config.get('JOB_AUTOCONFIRM_MS', { infer: true });
    this.reviewWindowMs = config.get('REVIEW_WINDOW_MS', { infer: true });
  }

  /** Una acción de una de las partes; su rol sale del trabajo (403 si no le toca). */
  async act(
    userId: string,
    jobId: string,
    action: JobAction,
    extra: { data?: Prisma.JobUncheckedUpdateInput; note?: string } = {},
  ): Promise<JobDto> {
    const role = await this.roleOf(userId, jobId);
    await this.status.apply(jobId, action, { role, id: userId }, extra);
    return this.get(userId, jobId);
  }

  /**
   * Cancelar antes de empezar (asignado o en camino), cualquiera de las dos partes. Motivo
   * de una lista cerrada y nota opcional moderada: si coincide, se guarda retenida (no la
   * ve la contraparte). La solicitud queda cancelada; el empleador puede volver a publicar.
   */
  async cancel(
    userId: string,
    jobId: string,
    reason: JobCancelReason,
    rawNote: string | undefined,
  ): Promise<JobDto> {
    const trimmed = rawNote?.trim();
    const note = trimmed === '' ? undefined : trimmed;
    const held = note ? (await this.moderation.check(note)).held : false;
    return this.act(userId, jobId, 'CANCEL', {
      data: { cancelReason: reason, cancelNote: note ?? null, cancelNoteHeld: held },
      note: `${reason}${note && !held ? `: ${note}` : ''}`,
    });
  }

  async get(userId: string, jobId: string): Promise<JobDto> {
    const job = await this.prisma.job.findUnique({ where: { id: jobId }, include: jobInclude });
    if (!job || (job.workerId !== userId && job.employerId !== userId)) throw jobNotFound();
    return this.toDto(job, job.workerId === userId ? 'worker' : 'employer');
  }

  /** Historial (R8.3): del más reciente al más antiguo, como trabajador o como empleador. */
  async list(
    userId: string,
    role: 'worker' | 'employer',
    cursor: string | undefined,
    limit = 20,
  ): Promise<JobPageDto> {
    const rows = await this.prisma.job.findMany({
      where: role === 'worker' ? { workerId: userId } : { employerId: userId },
      include: jobInclude,
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, limit);
    return {
      items: page.map((job) => this.toDto(job, role)),
      nextCursor: rows.length > limit ? (page.at(-1)?.id ?? null) : null,
    };
  }

  // ---- Admin ----

  async disputed(): Promise<AdminDisputedJobDto[]> {
    const rows = await this.prisma.job.findMany({
      where: { status: 'en_curso', disputedAt: { not: null } },
      include: jobInclude,
      orderBy: { disputedAt: 'asc' },
      take: 100,
    });
    return rows.map((job) => ({
      id: job.id,
      requestId: job.requestId,
      workerId: job.workerId,
      employerId: job.employerId,
      category: job.request.category,
      finalPriceBs: job.finalPriceBs.toFixed(2),
      workerFinishedAt: job.workerFinishedAt?.toISOString() ?? '',
      disputedAt: job.disputedAt?.toISOString() ?? '',
      disputeNote: job.disputeNote,
    }));
  }

  /** El admin resuelve una disputa; la nota queda en job_events. */
  async resolveDispute(
    adminId: string,
    jobId: string,
    decision: 'confirm' | 'cancel',
    note: string,
  ): Promise<{ status: string }> {
    const { to } = await this.status.apply(
      jobId,
      decision === 'confirm' ? 'RESOLVE_CONFIRM' : 'RESOLVE_CANCEL',
      { role: 'admin', id: adminId },
      { note },
    );
    return { status: to };
  }

  private async roleOf(userId: string, jobId: string): Promise<JobActorRole> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      select: { workerId: true, employerId: true },
    });
    if (job?.workerId === userId) return 'worker';
    if (job?.employerId === userId) return 'employer';
    throw jobNotFound();
  }

  private toDto(job: JobRow, role: 'worker' | 'employer'): JobDto {
    const counterpart =
      role === 'worker'
        ? { userId: job.employerId, name: job.employer.name }
        : { userId: job.workerId, name: job.worker.name };
    const pendingAutoConfirm =
      job.status === 'en_curso' && job.workerFinishedAt && !job.disputedAt
        ? new Date(job.workerFinishedAt.getTime() + this.autoConfirmMs)
        : null;
    const showMoney = role === 'worker' && job.commissionBs !== null;
    const mine = job.cancelledById !== null && job.cancelledByRole === role;
    return {
      id: job.id,
      requestId: job.requestId,
      status: job.status,
      myRole: role,
      category: job.request.category,
      description: job.request.description,
      counterpart: {
        userId: counterpart.userId,
        shortName: shortName(counterpart.name, role === 'worker' ? 'Cliente' : 'Trabajador'),
      },
      finalPriceBs: job.finalPriceBs.toFixed(2),
      commissionBs: showMoney && job.commissionBs ? job.commissionBs.toFixed(2) : null,
      netBs:
        showMoney && job.commissionBs ? netOf(job.finalPriceBs, job.commissionBs).toFixed(2) : null,
      timeline: {
        assignedAt: job.assignedAt.toISOString(),
        onTheWayAt: iso(job.onTheWayAt),
        startedAt: iso(job.startedAt),
        workerFinishedAt: iso(job.workerFinishedAt),
        disputedAt: iso(job.disputedAt),
        completedAt: iso(job.completedAt),
        cancelledAt: iso(job.cancelledAt),
      },
      cancellation: job.cancelledByRole
        ? {
            by: job.cancelledByRole as 'worker' | 'employer' | 'admin',
            reason: job.cancelReason,
            // La nota retenida solo la ve quien la escribió.
            note: !job.cancelNoteHeld || mine ? job.cancelNote : null,
            noteHeld: mine && job.cancelNoteHeld,
          }
        : null,
      reviews: jobReviews(
        job,
        role === 'worker' ? job.workerId : job.employerId,
        this.reviewWindowMs,
      ),
      autoConfirmed: job.autoConfirmed,
      autoConfirmAt: iso(pendingAutoConfirm),
      allowedActions: allowedJobActions(job, role),
    };
  }
}

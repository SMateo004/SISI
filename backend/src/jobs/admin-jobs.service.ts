import { Injectable } from '@nestjs/common';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { assertNotSelf } from '../common/admin/self-review';
import { PrismaService } from '../prisma/prisma.service';
import type { AdminJobDetailDto, AdminJobPartyDto } from './dto/admin-job.dto';
import { jobNotFound, JobStatusService } from './job-status.service';

const party = (u: { id: string; name: string | null; phone: string }): AdminJobPartyDto => ({
  id: u.id,
  name: u.name,
  phone: u.phone,
});

/** Disputas en el panel: detalle completo y resolución por JobStatusService (ADR-0029). */
@Injectable()
export class AdminJobsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly status: JobStatusService,
    private readonly audit: AdminAuditService,
  ) {}

  async detail(jobId: string): Promise<AdminJobDetailDto> {
    const user = { select: { id: true, name: true, phone: true } } as const;
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      include: {
        worker: user,
        employer: user,
        request: {
          select: {
            description: true,
            address: true,
            proposedPriceBs: true,
            category: { select: { slug: true, name: true } },
          },
        },
        events: { orderBy: { id: 'asc' } },
      },
    });
    if (!job) throw jobNotFound();
    const [messages, offers] = await Promise.all([
      this.prisma.chatMessage.findMany({
        where: { jobId },
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      }),
      this.prisma.offer.findMany({
        where: { requestId: job.requestId },
        orderBy: { createdAt: 'asc' },
        include: {
          worker: { select: { user: user } },
          events: { orderBy: { id: 'asc' } },
        },
      }),
    ]);
    return {
      id: job.id,
      requestId: job.requestId,
      status: job.status,
      category: job.request.category,
      description: job.request.description,
      address: job.request.address,
      proposedPriceBs: job.request.proposedPriceBs.toFixed(2),
      finalPriceBs: job.finalPriceBs.toFixed(2),
      commissionPct: job.commissionPct.toFixed(2),
      commissionBs: job.commissionBs?.toFixed(2) ?? null,
      worker: party(job.worker),
      employer: party(job.employer),
      disputedAt: job.disputedAt?.toISOString() ?? null,
      disputeNote: job.disputeNote,
      timeline: job.events.map((e) => ({
        action: e.action,
        fromStatus: e.fromStatus,
        toStatus: e.toStatus,
        actorRole: e.actorRole,
        actorId: e.actorId,
        note: e.note,
        at: e.createdAt.toISOString(),
      })),
      chat: messages.map((m) => ({
        id: m.id,
        from: m.senderId === job.workerId ? ('worker' as const) : ('employer' as const),
        body: m.body,
        status: m.status,
        at: m.createdAt.toISOString(),
      })),
      offers: offers.map((o) => ({
        id: o.id,
        worker: party(o.worker.user),
        status: o.status,
        chosen: o.id === job.offerId,
        history: o.events.map((e) => ({
          kind: e.kind,
          revision: e.revision,
          type: e.type,
          amountBs: e.amountBs.toFixed(2),
          etaMin: e.etaMin,
          at: e.createdAt.toISOString(),
        })),
      })),
    };
  }

  /**
   * Resuelve una disputa: confirm → terminado con comisión (job.completed); cancel →
   * cancelado sin comisión. La nota queda en job_events y la decisión en la auditoría.
   */
  async resolve(
    ctx: AdminContext,
    jobId: string,
    decision: 'confirm' | 'cancel',
    note: string,
  ): Promise<{ status: string }> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      select: { workerId: true, employerId: true, cityId: true },
    });
    if (!job) throw jobNotFound();
    assertNotSelf(
      ctx.adminId,
      [job.workerId, job.employerId],
      'No puedes resolver una disputa de un trabajo tuyo.',
    );
    const to = await this.prisma.$transaction(async (tx) => {
      const transition = await this.status.apply(
        jobId,
        decision === 'confirm' ? 'RESOLVE_CONFIRM' : 'RESOLVE_CANCEL',
        { role: 'admin', id: ctx.adminId },
        { note },
        tx,
      );
      await this.audit.record(tx, ctx, {
        action: decision === 'confirm' ? 'dispute.confirm' : 'dispute.cancel',
        targetType: 'job',
        targetId: jobId,
        before: { status: transition.from },
        after: { status: transition.to },
        reason: note,
        cityId: job.cityId,
      });
      return transition.to;
    });
    return { status: to };
  }
}

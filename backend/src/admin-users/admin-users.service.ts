import { HttpStatus, Injectable } from '@nestjs/common';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { BillingLedgerService } from '../billing/billing-ledger.service';
import { assertNotSelf } from '../common/admin/self-review';
import { ApiError } from '../common/errors/api-error';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { WorkerStatusService } from '../workers/worker-status.service';
import type {
  JobRowDto,
  UserPageDto,
  UserProfileDto,
  UserRowDto,
  UserSearchQueryDto,
  WorkerStatusResultDto,
} from './dto/admin-users.dto';

const PAGE = 25;

const userNotFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'La cuenta no existe.');

/**
 * Cómo buscar: solo dígitos (con o sin +591) → por teléfono; si no, por nombre. Ambos con
 * ILIKE sobre índices trigram (sin escaneo completo).
 */
export function searchFilter(q: string | undefined): Prisma.UserWhereInput {
  const text = q?.trim() ?? '';
  if (text === '') return {};
  const digits = text.replace(/[\s()-]/g, '').replace(/^\+?591/, '');
  if (/^\+?\d+$/.test(digits)) return { phone: { contains: digits.replace('+', '') } };
  return { name: { contains: text, mode: 'insensitive' } };
}

const rowSelect = {
  id: true,
  phone: true,
  name: true,
  role: true,
  activeMode: true,
  createdAt: true,
  moderationFlaggedAt: true,
  city: { select: { name: true } },
  workerProfile: { select: { status: true } },
} satisfies Prisma.UserSelect;

type Row = Prisma.UserGetPayload<{ select: typeof rowSelect }>;

/** Plano (no la clase del DTO): se puede extender con spread. */
const toRow = (u: Row): Pick<UserRowDto, keyof UserRowDto> => ({
  id: u.id,
  phone: u.phone,
  name: u.name,
  role: u.role,
  activeMode: u.activeMode,
  cityName: u.city.name,
  workerStatus: u.workerProfile?.status ?? null,
  flagged: u.moderationFlaggedAt !== null,
  createdAt: u.createdAt.toISOString(),
});

/** Usuarios y trabajadores en el panel (permiso `usuarios`). */
@Injectable()
export class AdminUsersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly ledger: BillingLedgerService,
    private readonly status: WorkerStatusService,
    private readonly audit: AdminAuditService,
  ) {}

  async search(query: UserSearchQueryDto): Promise<UserPageDto> {
    const rows = await this.prisma.user.findMany({
      where: searchFilter(query.q),
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: PAGE + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
      select: rowSelect,
    });
    const page = rows.slice(0, PAGE);
    return {
      items: page.map(toRow),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  async profile(id: string): Promise<UserProfileDto> {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: {
        ...rowSelect,
        employerRatingAvg: true,
        employerRatingCount: true,
        cancellationsCount: true,
        workerProfile: {
          select: {
            status: true,
            statusChangedAt: true,
            ratingAvg: true,
            ratingCount: true,
            rejectionReason: true,
            moderationResolution: true,
            transport: true,
            maxRadiusKm: true,
            categories: { select: { category: { select: { name: true } } } },
          },
        },
      },
    });
    if (!user) throw userNotFound();

    const [reportGroups, reports, jobsCount, jobs] = await Promise.all([
      this.prisma.report.groupBy({
        by: ['status'],
        where: { reportedUserId: id },
        _count: { _all: true },
      }),
      this.prisma.report.findMany({
        where: { reportedUserId: id },
        orderBy: { createdAt: 'desc' },
        take: 10,
        select: { id: true, targetType: true, reason: true, status: true, createdAt: true },
      }),
      this.prisma.job.count({ where: { OR: [{ workerId: id }, { employerId: id }] } }),
      this.prisma.job.findMany({
        where: { OR: [{ workerId: id }, { employerId: id }] },
        orderBy: { createdAt: 'desc' },
        take: 10,
        select: {
          id: true,
          workerId: true,
          status: true,
          finalPriceBs: true,
          assignedAt: true,
          request: { select: { category: { select: { name: true } } } },
        },
      }),
    ]);
    const counts = { pendiente: 0, valido: 0, descartado: 0 };
    for (const g of reportGroups) counts[g.status] = g._count._all;

    const wp = user.workerProfile;
    let worker: UserProfileDto['worker'] = null;
    if (wp && wp.status !== 'sin_solicitar') {
      const [balance, periods] = await Promise.all([
        this.ledger.workerBalance(this.prisma, id),
        this.prisma.billingPeriod.findMany({
          where: { workerId: id },
          orderBy: { startAt: 'desc' },
          take: 8,
          select: {
            id: true,
            status: true,
            paymentReference: true,
            startAt: true,
            dueAt: true,
            commissionBs: true,
          },
        }),
      ]);
      worker = {
        status: wp.status,
        statusChangedAt: wp.statusChangedAt.toISOString(),
        rating: { avg: wp.ratingAvg.toFixed(2), count: wp.ratingCount },
        rejectionReason: wp.rejectionReason,
        moderationResolution: wp.moderationResolution,
        categories: wp.categories.map((c) => c.category.name),
        transport: wp.transport,
        maxRadiusKm: wp.maxRadiusKm,
        balanceBs: balance.toFixed(2),
        periods: periods.map((p) => ({
          id: p.id,
          status: p.status,
          paymentReference: p.paymentReference,
          startAt: p.startAt.toISOString(),
          dueAt: p.dueAt.toISOString(),
          commissionBs: p.commissionBs.toFixed(2),
        })),
      };
    }

    return {
      ...toRow(user),
      employerRating: { avg: user.employerRatingAvg.toFixed(2), count: user.employerRatingCount },
      cancellationsCount: user.cancellationsCount,
      flaggedAt: user.moderationFlaggedAt?.toISOString() ?? null,
      worker,
      reportCounts: counts,
      reports: reports.map((r) => ({ ...r, createdAt: r.createdAt.toISOString() })),
      jobsCount,
      jobs: jobs.map((j): JobRowDto => ({
        id: j.id,
        as: j.workerId === id ? 'worker' : 'employer',
        status: j.status,
        categoryName: j.request.category.name,
        finalPriceBs: j.finalPriceBs.toFixed(2),
        assignedAt: j.assignedAt.toISOString(),
      })),
    };
  }

  /** Suspende el perfil de trabajador (R9.3) por la máquina de estados (ADR-0013). */
  suspend(ctx: AdminContext, userId: string, reason: string): Promise<WorkerStatusResultDto> {
    return this.applyWorkerEvent(ctx, userId, 'worker.suspend', reason, {
      type: 'SUSPEND',
      reason,
    });
  }

  /** Levanta la suspensión: vuelve a aprobado, o a bloqueado por deuda si tiene deuda vencida. */
  reactivate(ctx: AdminContext, userId: string, reason: string): Promise<WorkerStatusResultDto> {
    return this.applyWorkerEvent(ctx, userId, 'worker.reactivate', reason, {
      type: 'LIFT_SUSPENSION',
      resolution: reason,
    });
  }

  /** Quita la marca "revisar" de un empleador reportado (ADR-0033), con motivo. */
  async clearFlag(ctx: AdminContext, userId: string, reason: string): Promise<UserRowDto> {
    assertNotSelf(ctx.adminId, [userId], 'No puedes quitar la marca de tu propia cuenta.');
    return this.prisma.$transaction(async (tx) => {
      const user = await tx.user.findUnique({ where: { id: userId }, select: rowSelect });
      if (!user) throw userNotFound();
      if (!user.moderationFlaggedAt) {
        throw new ApiError(HttpStatus.CONFLICT, 'USER_NOT_FLAGGED', 'La cuenta no está marcada.');
      }
      const { count } = await tx.user.updateMany({
        where: { id: userId, moderationFlaggedAt: user.moderationFlaggedAt },
        data: { moderationFlaggedAt: null },
      });
      if (count === 0) {
        throw new ApiError(HttpStatus.CONFLICT, 'USER_CHANGED', 'La cuenta cambió. Recarga.');
      }
      await this.audit.record(tx, ctx, {
        action: 'user.clear_flag',
        targetType: 'user',
        targetId: userId,
        before: { flaggedAt: user.moderationFlaggedAt },
        after: { flaggedAt: null },
        reason,
      });
      return toRow({ ...user, moderationFlaggedAt: null });
    });
  }

  private async applyWorkerEvent(
    ctx: AdminContext,
    userId: string,
    action: string,
    reason: string,
    event: Parameters<WorkerStatusService['apply']>[1],
  ): Promise<WorkerStatusResultDto> {
    assertNotSelf(ctx.adminId, [userId], 'No puedes cambiar el estado de tu propia cuenta.');
    const exists = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { id: true },
    });
    if (!exists) throw userNotFound();
    const change = await this.status.apply(userId, event, ctx.adminId, (tx, { from, to }) =>
      this.audit.record(tx, ctx, {
        action,
        targetType: 'worker',
        targetId: userId,
        before: { status: from },
        after: { status: to },
        reason,
      }),
    );
    return {
      userId,
      status: change.profile.status,
      modeForcedToEmployer: change.modeForcedToEmployer,
    };
  }
}

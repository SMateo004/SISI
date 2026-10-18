import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { assertNotSelf } from '../common/admin/self-review';
import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import type { Report } from '../generated/prisma/client';
import { ModerationService } from '../moderation/moderation.service';
import { PrismaService } from '../prisma/prisma.service';
import { WorkerStatusService } from '../workers/worker-status.service';
import type {
  AdminReportDto,
  AdminReportPageDto,
  ReportDto,
  ResolveReportResultDto,
} from './dto/report.dto';
import {
  type ReportReasonValue,
  type ReportTargetValue,
  type SuspensionDecision,
  suspensionDecision,
} from './report.rules';

const ADMIN_PAGE = 25;

const targetNotFound = (): ApiError =>
  new ApiError(
    HttpStatus.NOT_FOUND,
    'REPORT_TARGET_NOT_FOUND',
    'No encontramos lo que quieres reportar.',
  );

/**
 * Reportes (R9.3, ADR-0033). Solo se reporta algo con lo que uno tuvo relación (a los
 * demás no se les revela que existe). Al validar un reporte, si el reportado suma
 * REPORTS_SUSPEND_THRESHOLD reportes válidos de personas distintas, se suspende como
 * trabajador (WorkerStatusService, ADR-0013) o, si solo es empleador, se marca para el admin.
 */
@Injectable()
export class ReportsService {
  private readonly logger = new Logger('Reports');
  private readonly threshold: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly moderation: ModerationService,
    private readonly workerStatus: WorkerStatusService,
    private readonly audit: AdminAuditService,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.threshold = config.get('REPORTS_SUSPEND_THRESHOLD', { infer: true });
  }

  async create(
    reporterId: string,
    targetType: ReportTargetValue,
    targetId: string,
    reason: ReportReasonValue,
    rawNote: string | undefined,
  ): Promise<ReportDto> {
    const target = await this.resolveTarget(reporterId, targetType, targetId);
    const trimmed = rawNote?.trim();
    const note = trimmed === '' ? undefined : trimmed;
    const noteHeld = note ? (await this.moderation.check(note)).held : false;
    const existing = await this.prisma.report.findUnique({
      where: { reporterId_targetType_targetId: { reporterId, targetType, targetId } },
      select: { id: true },
    });
    if (existing) throw alreadyReported();
    try {
      const report = await this.prisma.report.create({
        data: {
          reporterId,
          targetType,
          targetId,
          reportedUserId: target.reportedUserId,
          cityId: target.cityId,
          reason,
          note: note ?? null,
          noteHeld,
        },
      });
      return toDto(report);
    } catch (err) {
      // Dos envíos simultáneos: gana uno, el otro choca con el índice único.
      if ((err as { code?: string }).code === 'P2002') throw alreadyReported();
      throw err;
    }
  }

  async mine(reporterId: string): Promise<ReportDto[]> {
    const rows = await this.prisma.report.findMany({
      where: { reporterId },
      orderBy: { createdAt: 'desc' },
      take: 100,
    });
    return rows.map(toDto);
  }

  // ---- Admin ----

  /** Por estado, del más antiguo al más nuevo (el que más espera, primero), 25 por página. */
  async list(
    status: 'pendiente' | 'valido' | 'descartado' = 'pendiente',
    cursor?: string,
  ): Promise<AdminReportPageDto> {
    const rows = await this.prisma.report.findMany({
      where: { status },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      take: ADMIN_PAGE + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, ADMIN_PAGE);
    return {
      items: await Promise.all(page.map((r) => this.toAdminDto(r))),
      nextCursor: rows.length > ADMIN_PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  /**
   * Marca un reporte válido o descartado. Desde el panel (`actor`), la decisión y lo que
   * provoque (suspensión o marca, R9.3) quedan auditados en su transacción; dev-tools pasa null.
   */
  async resolve(
    actor: AdminContext | null,
    reportId: string,
    valid: boolean,
    resolution: string,
  ): Promise<ResolveReportResultDto> {
    const adminId = actor?.adminId ?? null;
    const current = await this.prisma.report.findUnique({
      where: { id: reportId },
      select: { reporterId: true, reportedUserId: true },
    });
    if (!current) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'REPORT_NOT_FOUND', 'El reporte no existe.');
    }
    assertNotSelf(
      adminId,
      [current.reporterId, current.reportedUserId],
      'No puedes resolver un reporte en el que eres parte.',
    );
    const count = await this.prisma.$transaction(async (tx) => {
      const updated = await tx.report.updateMany({
        where: { id: reportId, status: 'pendiente' },
        data: {
          status: valid ? 'valido' : 'descartado',
          resolution,
          resolvedById: adminId,
          resolvedAt: new Date(),
        },
      });
      if (updated.count > 0 && actor) {
        await this.audit.record(tx, actor, {
          action: valid ? 'report.valid' : 'report.dismiss',
          targetType: 'report',
          targetId: reportId,
          before: { status: 'pendiente' },
          after: {
            status: valid ? 'valido' : 'descartado',
            reportedUserId: current.reportedUserId,
          },
          reason: resolution,
        });
      }
      return updated.count;
    });
    const report = await this.prisma.report.findUnique({ where: { id: reportId } });
    if (!report) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'REPORT_NOT_FOUND', 'El reporte no existe.');
    }
    if (count === 0) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'REPORT_ALREADY_RESOLVED',
        'Este reporte ya fue resuelto.',
      );
    }
    const outcome = valid ? await this.enforce(report.reportedUserId, actor) : 'none';
    return { report: await this.toAdminDto(report), outcome };
  }

  /**
   * Aplica R9.3 al reportado. Idempotente: si ya está suspendido o marcado, no hace nada,
   * así que se puede volver a correr (dev-tools) si una suspensión falló a medias.
   */
  async enforce(userId: string, actor: AdminContext | null): Promise<SuspensionDecision> {
    const actorId = actor?.adminId ?? null;
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { moderationFlaggedAt: true, workerProfile: { select: { status: true } } },
    });
    const decision = suspensionDecision({
      validReporters: await this.validReporters(userId),
      threshold: this.threshold,
      workerStatus: user.workerProfile?.status ?? null,
      alreadyFlagged: user.moderationFlaggedAt !== null,
    });
    const reason = `${this.threshold} reportes válidos (R9.3)`;
    if (decision === 'suspend') {
      await this.workerStatus.apply(
        userId,
        { type: 'SUSPEND', reason },
        actorId,
        actor
          ? (tx, { from, to }) =>
              this.audit.record(tx, actor, {
                action: 'report.suspend',
                targetType: 'worker',
                targetId: userId,
                before: { status: from },
                after: { status: to },
                reason,
              })
          : undefined,
      );
    } else if (decision === 'flag') {
      await this.prisma.$transaction(async (tx) => {
        const { count } = await tx.user.updateMany({
          where: { id: userId, moderationFlaggedAt: null },
          data: { moderationFlaggedAt: new Date() },
        });
        if (count > 0 && actor) {
          await this.audit.record(tx, actor, {
            action: 'report.flag',
            targetType: 'user',
            targetId: userId,
            before: { flagged: false },
            after: { flagged: true },
            reason,
          });
        }
      });
      this.logger.warn(
        `Usuario ${userId} marcado para revisión: ${this.threshold} reportes válidos`,
      );
    }
    return decision;
  }

  private async validReporters(userId: string): Promise<number> {
    const rows = await this.prisma.report.findMany({
      where: { reportedUserId: userId, status: 'valido' },
      select: { reporterId: true },
      distinct: ['reporterId'],
    });
    return rows.length;
  }

  /** Dueño del objetivo y ciudad, verificando que quien reporta tenga relación con él. */
  private async resolveTarget(
    reporterId: string,
    type: ReportTargetValue,
    id: string,
  ): Promise<{ reportedUserId: string; cityId: string }> {
    switch (type) {
      case 'request': {
        const request = await this.prisma.serviceRequest.findUnique({
          where: { id },
          select: { employerId: true, cityId: true },
        });
        const notified = request
          ? await this.prisma.requestNotification.findUnique({
              where: { requestId_workerId: { requestId: id, workerId: reporterId } },
            })
          : null;
        if (!request || !notified) throw targetNotFound();
        return { reportedUserId: request.employerId, cityId: request.cityId };
      }
      case 'job': {
        const job = await this.prisma.job.findUnique({
          where: { id },
          select: { workerId: true, employerId: true, cityId: true },
        });
        if (!job || (job.workerId !== reporterId && job.employerId !== reporterId)) {
          throw targetNotFound();
        }
        return {
          reportedUserId: job.workerId === reporterId ? job.employerId : job.workerId,
          cityId: job.cityId,
        };
      }
      case 'chat_message': {
        const message = await this.prisma.chatMessage.findUnique({
          where: { id },
          select: {
            senderId: true,
            cityId: true,
            job: { select: { workerId: true, employerId: true } },
          },
        });
        const party =
          message && (message.job.workerId === reporterId || message.job.employerId === reporterId);
        if (!message || !party || message.senderId === reporterId) throw targetNotFound();
        return { reportedUserId: message.senderId, cityId: message.cityId };
      }
      case 'user': {
        if (id === reporterId) throw targetNotFound();
        const user = await this.prisma.user.findUnique({ where: { id }, select: { cityId: true } });
        if (!user || !(await this.related(reporterId, id))) throw targetNotFound();
        return { reportedUserId: id, cityId: user.cityId };
      }
    }
  }

  /** Tuvieron un trabajo juntos, uno ofertó en una solicitud del otro o le llegó una suya. */
  private async related(a: string, b: string): Promise<boolean> {
    const job = await this.prisma.job.count({
      where: {
        OR: [
          { workerId: a, employerId: b },
          { workerId: b, employerId: a },
        ],
      },
    });
    if (job > 0) return true;
    const offer = await this.prisma.offer.count({
      where: {
        OR: [
          { workerId: b, request: { employerId: a } },
          { workerId: a, request: { employerId: b } },
        ],
      },
    });
    if (offer > 0) return true;
    const notified = await this.prisma.requestNotification.count({
      where: {
        OR: [
          { workerId: a, request: { employerId: b } },
          { workerId: b, request: { employerId: a } },
        ],
      },
    });
    return notified > 0;
  }

  private async toAdminDto(r: Report): Promise<AdminReportDto> {
    const [user, reporter, target] = await Promise.all([
      this.prisma.user.findUniqueOrThrow({
        where: { id: r.reportedUserId },
        select: {
          name: true,
          phone: true,
          moderationFlaggedAt: true,
          workerProfile: { select: { status: true } },
        },
      }),
      this.prisma.user.findUniqueOrThrow({
        where: { id: r.reporterId },
        select: { name: true, phone: true },
      }),
      this.targetSummary(r.targetType, r.targetId),
    ]);
    return Object.assign(toDto(r), {
      reporterId: r.reporterId,
      reporterName: reporter.name,
      reporterPhone: reporter.phone,
      note: r.note,
      noteHeld: r.noteHeld,
      resolution: r.resolution,
      targetSummary: target,
      reportedUser: {
        id: r.reportedUserId,
        name: user.name,
        phone: user.phone,
        validReporters: await this.validReporters(r.reportedUserId),
        workerStatus: user.workerProfile?.status ?? null,
        flaggedAt: user.moderationFlaggedAt?.toISOString() ?? null,
      },
    });
  }

  /** Qué se reportó, en una línea, para decidir sin abrir otra pantalla. */
  private async targetSummary(type: ReportTargetValue, id: string): Promise<string> {
    const clip = (text: string) => (text.length > 160 ? `${text.slice(0, 157)}…` : text);
    switch (type) {
      case 'request': {
        const r = await this.prisma.serviceRequest.findUnique({
          where: { id },
          select: { description: true },
        });
        return r ? clip(r.description) : 'Solicitud no encontrada';
      }
      case 'chat_message': {
        const m = await this.prisma.chatMessage.findUnique({
          where: { id },
          select: { body: true },
        });
        return m ? clip(m.body) : 'Mensaje no encontrado';
      }
      case 'job': {
        const j = await this.prisma.job.findUnique({
          where: { id },
          select: { status: true, request: { select: { category: { select: { name: true } } } } },
        });
        return j ? `Trabajo de ${j.request.category.name} (${j.status})` : 'Trabajo no encontrado';
      }
      case 'user': {
        const u = await this.prisma.user.findUnique({ where: { id }, select: { name: true } });
        return u ? `Perfil de ${u.name ?? 'usuario sin nombre'}` : 'Usuario no encontrado';
      }
    }
  }
}

const alreadyReported = (): ApiError =>
  new ApiError(
    HttpStatus.CONFLICT,
    'ALREADY_REPORTED',
    'Ya reportaste esto. Lo estamos revisando.',
  );

function toDto(r: Report): ReportDto {
  return {
    id: r.id,
    targetType: r.targetType,
    targetId: r.targetId,
    reason: r.reason,
    status: r.status,
    createdAt: r.createdAt.toISOString(),
  };
}

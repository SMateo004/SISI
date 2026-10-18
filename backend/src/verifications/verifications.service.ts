import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { assertNotSelf } from '../common/admin/self-review';
import { ApiError } from '../common/errors/api-error';
import { ageOn } from '../common/time/age';
import type { AppConfigService } from '../config/app-config';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';
import type { DocumentUrlDto } from '../workers/dto/worker.dto';
import { WorkerStatusService } from '../workers/worker-status.service';
import type {
  VerificationDetailDto,
  VerificationPageDto,
  VerificationResultDto,
} from './dto/verifications.dto';
import { type RejectionReason, rejectionText } from './verification.rules';

const PAGE = 25;

const notFound = (): ApiError =>
  new ApiError(
    HttpStatus.NOT_FOUND,
    'VERIFICATION_NOT_FOUND',
    'La solicitud de trabajador no existe.',
  );

const SELF = 'No puedes revisar tu propia solicitud de trabajador.';

/**
 * Verificaciones (R1.3, R1.4, R9.5). La decisión pasa por WorkerStatusService (ADR-0013);
 * la auditoría y el aviso (outbox worker.reviewed) van en la misma transacción.
 */
@Injectable()
export class VerificationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    private readonly status: WorkerStatusService,
    private readonly outbox: OutboxService,
    private readonly audit: AdminAuditService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  /** Cola de pendiente_revision, de la más antigua a la más nueva. */
  async queue(cursor?: string): Promise<VerificationPageDto> {
    const rows = await this.prisma.workerProfile.findMany({
      where: { status: 'pendiente_revision' },
      orderBy: [{ submittedAt: 'asc' }, { userId: 'asc' }],
      take: PAGE + 1,
      ...(cursor ? { cursor: { userId: cursor }, skip: 1 } : {}),
      select: {
        userId: true,
        submittedAt: true,
        user: { select: { name: true, phone: true, city: { select: { name: true } } } },
        categories: { select: { category: { select: { name: true } } } },
      },
    });
    const page = rows.slice(0, PAGE);
    return {
      items: page.map((r) => ({
        userId: r.userId,
        name: r.user.name,
        phone: r.user.phone,
        cityName: r.user.city.name,
        submittedAt: (r.submittedAt ?? new Date(0)).toISOString(),
        categories: r.categories.map((c) => c.category.name),
      })),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.userId ?? null) : null,
    };
  }

  /** Detalle con los documentos por URL temporal (5 min, sin caché). Abrirlo queda auditado. */
  async detail(ctx: AdminContext, userId: string): Promise<VerificationDetailDto> {
    const p = await this.prisma.workerProfile.findUnique({
      where: { userId },
      select: {
        status: true,
        submittedAt: true,
        birthDate: true,
        transport: true,
        maxRadiusKm: true,
        user: {
          select: {
            name: true,
            phone: true,
            cityId: true,
            city: { select: { name: true, timezone: true } },
          },
        },
        categories: {
          select: { category: { select: { id: true, name: true, extraRequirements: true } } },
        },
        documents: { select: { id: true, type: true, fileKey: true }, orderBy: { type: 'asc' } },
      },
    });
    if (!p || p.status === 'sin_solicitar') throw notFound();
    const ttl = this.config.get('DOCUMENT_URL_TTL_SEC', { infer: true });
    const expiresAt = new Date(Date.now() + ttl * 1000).toISOString();
    const documents = await Promise.all(
      p.documents.map(async (d) => ({
        id: d.id,
        type: d.type,
        url: await this.storage.presignDownload(d.fileKey, ttl, { noStore: true }),
        expiresAt,
      })),
    );
    await this.auditView(
      ctx,
      userId,
      p.user.cityId,
      p.documents.map((d) => d.id),
    );
    const birth = p.birthDate
      ? {
          year: p.birthDate.getUTCFullYear(),
          month: p.birthDate.getUTCMonth() + 1,
          day: p.birthDate.getUTCDate(),
        }
      : null;
    return {
      userId,
      name: p.user.name,
      phone: p.user.phone,
      cityName: p.user.city.name,
      submittedAt: (p.submittedAt ?? new Date(0)).toISOString(),
      categories: p.categories.map((c) => c.category.name),
      status: p.status,
      birthDate: p.birthDate?.toISOString().slice(0, 10) ?? null,
      age: birth ? ageOn(birth, new Date(), p.user.city.timezone) : null,
      transport: p.transport,
      maxRadiusKm: p.maxRadiusKm,
      categoryDetails: p.categories.map(({ category }) => ({
        id: category.id,
        name: category.name,
        extraRequirements: Array.isArray(category.extraRequirements)
          ? category.extraRequirements.map(String)
          : [],
      })),
      documents,
    };
  }

  /** Un documento suelto (el enlace venció mientras se revisaba): 5 min más, auditado. */
  async documentUrl(
    ctx: AdminContext,
    userId: string,
    documentId: string,
  ): Promise<DocumentUrlDto> {
    const document = await this.prisma.workerDocument.findFirst({
      where: { id: documentId, workerId: userId },
      select: { fileKey: true, worker: { select: { user: { select: { cityId: true } } } } },
    });
    if (!document) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'DOCUMENT_NOT_FOUND', 'El documento no existe.');
    }
    const ttl = this.config.get('DOCUMENT_URL_TTL_SEC', { infer: true });
    const url = await this.storage.presignDownload(document.fileKey, ttl, { noStore: true });
    await this.auditView(ctx, userId, document.worker.user.cityId, [documentId]);
    return { url, expiresAt: new Date(Date.now() + ttl * 1000).toISOString() };
  }

  approve(ctx: AdminContext, userId: string, note?: string): Promise<VerificationResultDto> {
    return this.decide(ctx, userId, { decision: 'approved', note: note ?? null });
  }

  reject(
    ctx: AdminContext,
    userId: string,
    reason: RejectionReason,
    note: string,
  ): Promise<VerificationResultDto> {
    return this.decide(ctx, userId, { decision: 'rejected', reason, note });
  }

  private async decide(
    ctx: AdminContext,
    userId: string,
    input:
      | { decision: 'approved'; note: string | null }
      | { decision: 'rejected'; reason: RejectionReason; note: string },
  ): Promise<VerificationResultDto> {
    assertNotSelf(ctx.adminId, [userId], SELF);
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { cityId: true, workerProfile: { select: { status: true } } },
    });
    if (!user?.workerProfile) throw notFound();
    const rejection =
      input.decision === 'rejected' ? rejectionText(input.reason, input.note) : null;
    const { profile } = await this.status.apply(
      userId,
      rejection ? { type: 'REJECT', reason: rejection } : { type: 'APPROVE' },
      ctx.adminId,
      async (tx, { from, to }) => {
        await this.audit.record(tx, ctx, {
          action: input.decision === 'approved' ? 'verification.approve' : 'verification.reject',
          targetType: 'worker',
          targetId: userId,
          before: { status: from },
          after: {
            status: to,
            ...(input.decision === 'rejected' ? { reason: input.reason } : {}),
          },
          reason: input.note,
          cityId: user.cityId,
        });
        await this.outbox.add(tx, 'worker.reviewed', userId, {
          workerId: userId,
          decision: input.decision,
          ...(input.decision === 'rejected' ? { reason: input.reason, note: input.note } : {}),
        });
      },
    );
    return {
      userId,
      status: profile.status,
      rejectionReason: profile.status === 'rechazado' ? profile.rejectionReason : null,
    };
  }

  private async auditView(
    ctx: AdminContext,
    userId: string,
    cityId: string,
    documentIds: string[],
  ): Promise<void> {
    if (documentIds.length === 0) return;
    await this.prisma.$transaction((tx) =>
      this.audit.record(tx, ctx, {
        action: 'verification.view_documents',
        targetType: 'worker',
        targetId: userId,
        after: { documentIds },
        cityId,
      }),
    );
  }
}

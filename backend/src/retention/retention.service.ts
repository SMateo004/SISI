import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';

/** Texto que reemplaza a un mensaje vencido (el chat ya estaba en solo lectura hace meses). */
export const EXPIRED_MESSAGE = 'Mensaje eliminado por antigüedad.';

export type RetentionTask =
  | 'rejected_documents'
  | 'stale_locations'
  | 'old_chat'
  | 'abandoned_drafts'
  | 'rejected_receipts'
  | 'read_notifications'
  | 'expired_refresh_tokens'
  | 'old_idempotency_keys';

export type RetentionReport = Record<RetentionTask, number>;

type RetentionDaysKey =
  | 'RETENTION_REJECTED_DOCS_DAYS'
  | 'RETENTION_LOCATION_DAYS'
  | 'RETENTION_CHAT_DAYS'
  | 'RETENTION_DRAFT_DAYS'
  | 'RETENTION_REJECTED_RECEIPT_DAYS'
  | 'RETENTION_NOTIFICATION_DAYS'
  | 'RETENTION_TOKEN_DAYS'
  | 'RETENTION_IDEMPOTENCY_DAYS';

const BATCH = 500;
const DAY = 86_400_000;

/**
 * Retención de datos (ADR-0050). Cada tarea borra lo que ya cumplió su plazo, por lotes y de
 * forma idempotente (correrla dos veces no cambia nada). Con dryRun solo cuenta. Va apagada
 * (RETENTION_ENABLED=false) hasta que se aprueben los plazos (docs/pendientes.md). Nunca toca
 * ledger_entries, job_events, offer_events, admin_audit_log ni legal_acceptances.
 */
@Injectable()
export class RetentionService {
  private readonly logger = new Logger(RetentionService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  private before(days: number, now: Date): Date {
    return new Date(now.getTime() - days * DAY);
  }

  private days(key: RetentionDaysKey): number {
    return this.config.get(key, { infer: true });
  }

  async run(opts: { dryRun?: boolean; now?: Date } = {}): Promise<RetentionReport> {
    const now = opts.now ?? new Date();
    const dry = opts.dryRun ?? false;
    const report: RetentionReport = {
      rejected_documents: await this.rejectedDocuments(now, dry),
      stale_locations: await this.staleLocations(now, dry),
      old_chat: await this.oldChat(now, dry),
      abandoned_drafts: await this.abandonedDrafts(now, dry),
      rejected_receipts: await this.rejectedReceipts(now, dry),
      read_notifications: await this.readNotifications(now, dry),
      expired_refresh_tokens: await this.expiredRefreshTokens(now, dry),
      old_idempotency_keys: await this.oldIdempotencyKeys(now, dry),
    };
    this.logger.log(`Retención${dry ? ' (prueba, sin borrar)' : ''}: ${JSON.stringify(report)}`);
    return report;
  }

  /** Carnet y selfie de quien fue rechazado y no volvió a enviar su solicitud. */
  private async rejectedDocuments(now: Date, dry: boolean): Promise<number> {
    const where = {
      worker: {
        status: 'rechazado' as const,
        reviewedAt: { lt: this.before(this.days('RETENTION_REJECTED_DOCS_DAYS'), now) },
      },
    };
    if (dry) return this.prisma.workerDocument.count({ where });
    let total = 0;
    for (;;) {
      const docs = await this.prisma.workerDocument.findMany({
        where,
        select: { id: true, fileKey: true },
        take: BATCH,
      });
      if (docs.length === 0) return total;
      // Primero el archivo y después la fila: si algo falla, la próxima corrida lo retoma.
      for (const d of docs) await this.storage.delete(d.fileKey);
      await this.prisma.workerDocument.deleteMany({ where: { id: { in: docs.map((d) => d.id) } } });
      total += docs.length;
    }
  }

  /** Última ubicación de un trabajador que lleva mucho sin conectarse (no hay historial). */
  private async staleLocations(now: Date, dry: boolean): Promise<number> {
    const where = {
      available: false,
      locatedAt: { lt: this.before(this.days('RETENTION_LOCATION_DAYS'), now) },
    };
    if (dry) return this.prisma.workerLocation.count({ where });
    return (await this.prisma.workerLocation.deleteMany({ where })).count;
  }

  /**
   * Mensajes de trabajos cerrados hace más del plazo, salvo que haya un reporte pendiente sobre
   * el trabajo o sobre un mensaje (un admin todavía puede necesitarlos).
   */
  private async oldChat(now: Date, dry: boolean): Promise<number> {
    const cutoff = this.before(this.days('RETENTION_CHAT_DAYS'), now);
    const count = async (): Promise<number> => {
      const [row] = await this.prisma.$queryRaw<{ n: bigint }[]>`
        SELECT count(*) AS n FROM chat_messages m JOIN jobs j ON j.id = m.job_id
        WHERE m.body <> ${EXPIRED_MESSAGE}
          AND j.status IN ('terminado', 'cancelado')
          AND COALESCE(j.completed_at, j.cancelled_at) < ${cutoff}
          AND NOT EXISTS (
            SELECT 1 FROM reports r WHERE r.status = 'pendiente'
              AND ((r.target_type = 'job' AND r.target_id = j.id)
                OR (r.target_type = 'chat_message' AND r.target_id = m.id)))`;
      return Number(row?.n ?? 0);
    };
    if (dry) return count();
    let total = 0;
    for (;;) {
      const n = await this.prisma.$executeRaw`
        UPDATE chat_messages SET body = ${EXPIRED_MESSAGE}, moderation_matches = NULL
        WHERE id IN (
          SELECT m.id FROM chat_messages m JOIN jobs j ON j.id = m.job_id
          WHERE m.body <> ${EXPIRED_MESSAGE}
            AND j.status IN ('terminado', 'cancelado')
            AND COALESCE(j.completed_at, j.cancelled_at) < ${cutoff}
            AND NOT EXISTS (
              SELECT 1 FROM reports r WHERE r.status = 'pendiente'
                AND ((r.target_type = 'job' AND r.target_id = j.id)
                  OR (r.target_type = 'chat_message' AND r.target_id = m.id)))
          LIMIT ${BATCH})`;
      total += n;
      if (n < BATCH) return total;
    }
  }

  /** Borradores nunca publicados (pendiente de la Fase 2), con sus fotos del bucket. */
  private async abandonedDrafts(now: Date, dry: boolean): Promise<number> {
    const where = {
      status: 'borrador' as const,
      createdAt: { lt: this.before(this.days('RETENTION_DRAFT_DAYS'), now) },
    };
    if (dry) return this.prisma.serviceRequest.count({ where });
    let total = 0;
    for (;;) {
      const drafts = await this.prisma.serviceRequest.findMany({
        where,
        select: { id: true, photos: { select: { fileKey: true } } },
        take: BATCH,
      });
      if (drafts.length === 0) return total;
      for (const d of drafts) for (const p of d.photos) await this.storage.delete(p.fileKey);
      // Fotos y eventos se van en cascada.
      await this.prisma.serviceRequest.deleteMany({
        where: { id: { in: drafts.map((d) => d.id) }, status: 'borrador' },
      });
      total += drafts.length;
    }
  }

  /** Archivo de un comprobante rechazado; la fila queda (historial del trabajador). */
  private async rejectedReceipts(now: Date, dry: boolean): Promise<number> {
    const where = {
      status: 'rechazado' as const,
      receiptPurgedAt: null,
      reviewedAt: { lt: this.before(this.days('RETENTION_REJECTED_RECEIPT_DAYS'), now) },
    };
    if (dry) return this.prisma.paymentSubmission.count({ where });
    let total = 0;
    for (;;) {
      const rows = await this.prisma.paymentSubmission.findMany({
        where,
        select: { id: true, receiptKey: true },
        take: BATCH,
      });
      if (rows.length === 0) return total;
      for (const r of rows) await this.storage.delete(r.receiptKey);
      await this.prisma.paymentSubmission.updateMany({
        where: { id: { in: rows.map((r) => r.id) } },
        data: { receiptPurgedAt: now },
      });
      total += rows.length;
    }
  }

  private async readNotifications(now: Date, dry: boolean): Promise<number> {
    const where = {
      readAt: { not: null, lt: this.before(this.days('RETENTION_NOTIFICATION_DAYS'), now) },
    };
    if (dry) return this.prisma.notification.count({ where });
    return (await this.prisma.notification.deleteMany({ where })).count;
  }

  private async expiredRefreshTokens(now: Date, dry: boolean): Promise<number> {
    const where = { expiresAt: { lt: this.before(this.days('RETENTION_TOKEN_DAYS'), now) } };
    if (dry) return this.prisma.refreshToken.count({ where });
    return (await this.prisma.refreshToken.deleteMany({ where })).count;
  }

  private async oldIdempotencyKeys(now: Date, dry: boolean): Promise<number> {
    const where = { createdAt: { lt: this.before(this.days('RETENTION_IDEMPOTENCY_DAYS'), now) } };
    if (dry) return this.prisma.idempotencyKey.count({ where });
    return (await this.prisma.idempotencyKey.deleteMany({ where })).count;
  }
}

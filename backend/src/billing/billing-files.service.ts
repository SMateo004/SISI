import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type { PresignedUploadDto } from '../storage/dto/upload.dto';
import { StorageService } from '../storage/storage.service';
import {
  type AllowedImageType,
  assertUploadAllowed,
  assertUploadedObject,
  newObjectKey,
  STORAGE_PREFIX,
} from '../storage/upload-policy';
import type { PaymentSubmissionDto } from './dto/billing-files.dto';

const QR_SETTING = 'billing.payment_qr';

/**
 * Archivos de cobro (ADR-0037): el QR de la empresa (configurable por el admin) y los
 * comprobantes que sube el trabajador. Todo en el bucket privado; se leen con URLs
 * temporales. Un comprobante enviado no cambia el ledger hasta que un admin registra el pago.
 */
@Injectable()
export class BillingFilesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  // ---- QR de la empresa ----

  async qrUploadUrl(contentType: string, sizeBytes: number): Promise<PresignedUploadDto> {
    return this.uploadUrl(STORAGE_PREFIX.company(), 'qr-cobro', contentType, sizeBytes);
  }

  async setQr(adminId: string, key: string): Promise<{ qrUrl: string }> {
    await this.assertUploaded(key, STORAGE_PREFIX.company());
    await this.prisma.appSetting.upsert({
      where: { key_scope: { key: QR_SETTING, scope: 'global' } },
      create: { key: QR_SETTING, scope: 'global', value: { key }, updatedById: adminId },
      update: { value: { key }, updatedById: adminId },
    });
    return { qrUrl: await this.signed(key) };
  }

  /** URL temporal del QR, o null si el admin todavía no lo cargó. */
  async qrUrl(): Promise<string | null> {
    const setting = await this.prisma.appSetting.findUnique({
      where: { key_scope: { key: QR_SETTING, scope: 'global' } },
    });
    const key = (setting?.value as { key?: unknown } | undefined)?.key;
    return typeof key === 'string' ? this.signed(key) : null;
  }

  // ---- Comprobantes del trabajador ----

  async submissionUploadUrl(
    workerId: string,
    contentType: string,
    sizeBytes: number,
  ): Promise<PresignedUploadDto> {
    await this.requireWorker(workerId);
    return this.uploadUrl(STORAGE_PREFIX.receipts(workerId), 'comprobante', contentType, sizeBytes);
  }

  async submit(
    workerId: string,
    input: { receiptKey: string; declaredAmountBs?: string; note?: string },
  ): Promise<PaymentSubmissionDto> {
    const user = await this.requireWorker(workerId);
    await this.assertUploaded(input.receiptKey, STORAGE_PREFIX.receipts(workerId));
    const note = input.note?.trim();
    const row = await this.prisma.paymentSubmission.create({
      data: {
        workerId,
        cityId: user.cityId,
        receiptKey: input.receiptKey,
        declaredAmountBs: input.declaredAmountBs ?? null,
        note: note === '' ? null : (note ?? null),
      },
    });
    return this.toDto(row);
  }

  async mySubmissions(workerId: string): Promise<PaymentSubmissionDto[]> {
    const rows = await this.prisma.paymentSubmission.findMany({
      where: { workerId },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
    return Promise.all(rows.map((r) => this.toDto(r)));
  }

  // ---- Admin ----

  async listSubmissions(
    status: 'pendiente' | 'registrado' | 'rechazado',
  ): Promise<PaymentSubmissionDto[]> {
    const rows = await this.prisma.paymentSubmission.findMany({
      where: { status },
      orderBy: { createdAt: 'asc' },
      take: 100,
    });
    return Promise.all(rows.map((r) => this.toDto(r)));
  }

  async rejectSubmission(adminId: string, id: string, note: string): Promise<PaymentSubmissionDto> {
    const row = await this.prisma.paymentSubmission.findUnique({ where: { id } });
    if (!row)
      throw new ApiError(HttpStatus.NOT_FOUND, 'SUBMISSION_NOT_FOUND', 'El comprobante no existe.');
    if (row.workerId === adminId) {
      throw new ApiError(
        HttpStatus.FORBIDDEN,
        'SELF_REVIEW_FORBIDDEN',
        'No puedes revisar comprobantes de tu propia cuenta de trabajador.',
      );
    }
    const { count } = await this.prisma.paymentSubmission.updateMany({
      where: { id, status: 'pendiente' },
      data: {
        status: 'rechazado',
        reviewNote: note,
        reviewedById: adminId,
        reviewedAt: new Date(),
      },
    });
    if (count === 0) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'SUBMISSION_ALREADY_REVIEWED',
        'Este comprobante ya fue revisado.',
      );
    }
    return this.toDto(await this.prisma.paymentSubmission.findUniqueOrThrow({ where: { id } }));
  }

  /** URL temporal de un archivo del bucket privado (comprobante o QR). */
  signed(key: string): Promise<string> {
    return this.storage.presignDownload(
      key,
      this.config.get('RECEIPT_URL_TTL_SEC', { infer: true }),
    );
  }

  private async uploadUrl(
    prefix: string,
    name: string,
    contentType: string,
    sizeBytes: number,
  ): Promise<PresignedUploadDto> {
    assertUploadAllowed(
      contentType,
      sizeBytes,
      this.config.get('UPLOAD_MAX_BYTES', { infer: true }),
    );
    const key = newObjectKey(prefix, contentType as AllowedImageType, name);
    const { url, ...rest } = await this.storage.presignUpload({
      key,
      contentType,
      sizeBytes,
      expiresInSec: this.config.get('UPLOAD_URL_TTL_SEC', { infer: true }),
    });
    return { key, uploadUrl: url, ...rest };
  }

  private async assertUploaded(key: string, prefix: string): Promise<void> {
    assertUploadedObject(
      key,
      prefix,
      key.startsWith(prefix) ? await this.storage.head(key) : null,
      this.config.get('UPLOAD_MAX_BYTES', { infer: true }),
    );
  }

  private async requireWorker(workerId: string): Promise<{ cityId: string }> {
    const user = await this.prisma.user.findUnique({
      where: { id: workerId },
      select: { cityId: true, workerProfile: { select: { userId: true } } },
    });
    if (!user?.workerProfile) {
      throw new ApiError(
        HttpStatus.FORBIDDEN,
        'NOT_A_WORKER',
        'Solo un trabajador puede enviar comprobantes de pago.',
      );
    }
    return { cityId: user.cityId };
  }

  private async toDto(row: {
    id: string;
    status: 'pendiente' | 'registrado' | 'rechazado';
    receiptKey: string;
    declaredAmountBs: Prisma.Decimal | null;
    note: string | null;
    reviewNote: string | null;
    paymentId: string | null;
    workerId: string;
    createdAt: Date;
  }): Promise<PaymentSubmissionDto> {
    return {
      id: row.id,
      workerId: row.workerId,
      status: row.status,
      declaredAmountBs: row.declaredAmountBs?.toFixed(2) ?? null,
      note: row.note,
      reviewNote: row.reviewNote,
      paymentId: row.paymentId,
      receiptUrl: await this.signed(row.receiptKey),
      createdAt: row.createdAt.toISOString(),
    };
  }
}

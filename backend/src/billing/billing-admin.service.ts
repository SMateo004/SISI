import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { assertNotSelf } from '../common/admin/self-review';
import { ApiError } from '../common/errors/api-error';
import { withIdempotency } from '../common/idempotency/idempotency';
import type { AppConfigService } from '../config/app-config';
import { Prisma } from '../generated/prisma/client';
import { OutboxService } from '../outbox/outbox.service';
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
import { BillingLedgerService } from './billing-ledger.service';
import { allocatePayment } from './billing.rules';
import type {
  AdjustmentResultDto,
  AdminWorkerBillingDto,
  PaymentResultDto,
  RegisterAdjustmentDto,
  RegisterPaymentDto,
} from './dto/billing-admin.dto';

const SELF_PAYMENT = 'No puedes registrar pagos ni ajustes sobre tu propia cuenta de trabajador.';

const workerNotFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'WORKER_NOT_FOUND', 'El trabajador no existe.');

/**
 * Pagos y ajustes del admin (R7.4, R7.9, ADR-0037). Cada operación va en una transacción
 * con su Idempotency-Key: un reintento devuelve el resultado original. Nunca se edita un
 * movimiento; se agrega uno nuevo. Un admin no opera sobre su propia cuenta.
 */
@Injectable()
export class BillingAdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly ledger: BillingLedgerService,
    private readonly outbox: OutboxService,
    private readonly storage: StorageService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async receiptUploadUrl(
    adminId: string,
    workerId: string,
    contentType: string,
    sizeBytes: number,
  ): Promise<PresignedUploadDto> {
    assertNotSelf(adminId, [workerId], SELF_PAYMENT);
    await this.requireWorker(workerId);
    assertUploadAllowed(
      contentType,
      sizeBytes,
      this.config.get('UPLOAD_MAX_BYTES', { infer: true }),
    );
    const key = newObjectKey(
      STORAGE_PREFIX.receipts(workerId),
      contentType as AllowedImageType,
      'pago',
    );
    const { url, ...rest } = await this.storage.presignUpload({
      key,
      contentType,
      sizeBytes,
      expiresInSec: this.config.get('UPLOAD_URL_TTL_SEC', { infer: true }),
    });
    return { key, uploadUrl: url, ...rest };
  }

  async registerPayment(
    adminId: string,
    idempotencyKey: string,
    dto: RegisterPaymentDto,
    now: Date = new Date(),
  ): Promise<PaymentResultDto> {
    assertNotSelf(adminId, [dto.workerId], SELF_PAYMENT);
    const amount = new Prisma.Decimal(dto.amountBs);
    if (amount.lte(0)) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'AMOUNT_INVALID', 'El monto debe ser mayor a 0.');
    }
    const paidAt = new Date(dto.paidAt);
    if (paidAt.getTime() > now.getTime() + 5 * 60_000) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'PAID_AT_INVALID',
        'La fecha de pago no puede ser futura.',
      );
    }
    await this.requireWorker(dto.workerId);
    if (dto.receiptKey) {
      const prefix = STORAGE_PREFIX.receipts(dto.workerId);
      assertUploadedObject(
        dto.receiptKey,
        prefix,
        dto.receiptKey.startsWith(prefix) ? await this.storage.head(dto.receiptKey) : null,
        this.config.get('UPLOAD_MAX_BYTES', { infer: true }),
      );
    }

    const { result } = await this.prisma.$transaction((tx) =>
      withIdempotency(
        tx,
        { scope: 'billing.payment', key: idempotencyKey, actorId: adminId, body: dto },
        async () => {
          // Primero el periodo actual (se crea si falta), después los anteriores en orden:
          // siempre el mismo orden de bloqueo.
          const current = await this.ledger.lockPeriodAt(tx, dto.workerId, now);
          const older = await tx.$queryRaw<{ id: string }[]>`
            SELECT id FROM billing_periods
            WHERE worker_id = ${dto.workerId}::uuid AND start_at < ${current.startAt}
              AND status <> 'pagado'
            ORDER BY start_at ASC
            FOR UPDATE`;
          const balances = await Promise.all(
            older.map(async (p) => ({
              periodId: p.id,
              balance: await this.ledger.periodBalance(tx, p.id),
            })),
          );
          const allocations = allocatePayment(amount, balances, current.id);
          const submission = dto.submissionId
            ? await tx.paymentSubmission.findUnique({ where: { id: dto.submissionId } })
            : null;
          if (
            dto.submissionId &&
            (submission?.workerId !== dto.workerId || submission.status !== 'pendiente')
          ) {
            throw new ApiError(
              HttpStatus.CONFLICT,
              'SUBMISSION_NOT_PENDING',
              'Ese comprobante no está pendiente para este trabajador.',
            );
          }
          const payment = await tx.payment.create({
            data: {
              workerId: dto.workerId,
              cityId: current.cityId,
              periodId: allocations[0]?.periodId ?? current.id,
              amountBs: amount.toFixed(2),
              method: dto.method,
              reference: BillingAdminService.optional(dto.reference),
              receiptKey: dto.receiptKey ?? submission?.receiptKey ?? null,
              submissionId: submission?.id ?? null,
              invoiceNumber: BillingAdminService.optional(dto.invoiceNumber),
              registeredById: adminId,
              paidAt,
            },
          });
          const applied = [];
          for (const a of allocations) {
            await tx.ledgerEntry.create({
              data: {
                workerId: dto.workerId,
                cityId: current.cityId,
                periodId: a.periodId,
                type: 'pago',
                amountBs: a.amount.neg().toFixed(2),
                paymentId: payment.id,
                createdById: adminId,
              },
            });
            const status = await this.ledger.refreshClosedStatus(tx, a.periodId, now);
            const period = await tx.billingPeriod.findUniqueOrThrow({
              where: { id: a.periodId },
              select: { paymentReference: true },
            });
            applied.push({
              periodId: a.periodId,
              paymentReference: period.paymentReference,
              amountBs: a.amount.toFixed(2),
              status,
            });
          }
          if (submission) {
            await tx.paymentSubmission.update({
              where: { id: submission.id },
              data: {
                status: 'registrado',
                paymentId: payment.id,
                reviewedById: adminId,
                reviewedAt: now,
              },
            });
          }
          await this.outbox.add(tx, 'billing.payment_registered', dto.workerId, {
            paymentId: payment.id,
            workerId: dto.workerId,
          });
          const balance = await this.ledger.workerBalance(tx, dto.workerId);
          return {
            paymentId: payment.id,
            workerId: dto.workerId,
            amountBs: amount.toFixed(2),
            allocations: applied,
            balanceBs: balance.toFixed(2),
          };
        },
      ),
    );
    return result;
  }

  async registerAdjustment(
    adminId: string,
    idempotencyKey: string,
    dto: RegisterAdjustmentDto,
    now: Date = new Date(),
  ): Promise<AdjustmentResultDto> {
    assertNotSelf(adminId, [dto.workerId], SELF_PAYMENT);
    const amount = new Prisma.Decimal(dto.amountBs);
    if (amount.isZero()) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'AMOUNT_INVALID', 'El ajuste no puede ser 0.');
    }
    await this.requireWorker(dto.workerId);

    const { result } = await this.prisma.$transaction((tx) =>
      withIdempotency(
        tx,
        { scope: 'billing.adjustment', key: idempotencyKey, actorId: adminId, body: dto },
        async () => {
          const periodId = await this.adjustmentPeriod(tx, dto, now);
          const [locked] = await tx.$queryRaw<{ id: string; cityId: string }[]>`
            SELECT id, city_id AS "cityId" FROM billing_periods
            WHERE id = ${periodId}::uuid FOR UPDATE`;
          if (!locked)
            throw new ApiError(HttpStatus.NOT_FOUND, 'PERIOD_NOT_FOUND', 'El periodo no existe.');
          const entry = await tx.ledgerEntry.create({
            data: {
              workerId: dto.workerId,
              cityId: locked.cityId,
              periodId,
              type: 'ajuste',
              amountBs: amount.toFixed(2),
              reason: dto.reason.trim(),
              correctsEntryId: dto.correctsEntryId ? BigInt(dto.correctsEntryId) : null,
              createdById: adminId,
            },
          });
          const status = await this.ledger.refreshClosedStatus(tx, periodId, now);
          await this.outbox.add(tx, 'billing.balance_changed', dto.workerId, {
            workerId: dto.workerId,
            cause: 'ajuste',
          });
          const balance = await this.ledger.workerBalance(tx, dto.workerId);
          return {
            entryId: entry.id.toString(),
            periodId,
            amountBs: amount.toFixed(2),
            periodStatus: status,
            balanceBs: balance.toFixed(2),
          };
        },
      ),
    );
    return result;
  }

  async workerBilling(workerId: string): Promise<AdminWorkerBillingDto> {
    await this.requireWorker(workerId);
    const periods = await this.prisma.billingPeriod.findMany({
      where: { workerId },
      orderBy: { startAt: 'desc' },
      take: 52,
    });
    const balances = await this.prisma.$queryRaw<{ periodId: string; balance: string }[]>`
      SELECT period_id AS "periodId", SUM(amount_bs)::text AS balance
      FROM ledger_entries WHERE worker_id = ${workerId}::uuid GROUP BY period_id`;
    const byPeriod = new Map(balances.map((b) => [b.periodId, b.balance]));
    const entries = await this.prisma.ledgerEntry.findMany({
      where: { workerId },
      orderBy: { id: 'desc' },
      take: 100,
    });
    return {
      workerId,
      balanceBs: (await this.ledger.workerBalance(this.prisma, workerId)).toFixed(2),
      periods: periods.map((p) => ({
        id: p.id,
        startAt: p.startAt.toISOString(),
        endAt: p.endAt.toISOString(),
        dueAt: p.dueAt.toISOString(),
        status: p.status,
        grossBs: p.grossBs.toFixed(2),
        commissionBs: p.commissionBs.toFixed(2),
        balanceBs: new Prisma.Decimal(byPeriod.get(p.id) ?? '0').toFixed(2),
        paymentReference: p.paymentReference,
      })),
      entries: entries.map((e) => ({
        id: e.id.toString(),
        type: e.type,
        amountBs: e.amountBs.toFixed(2),
        periodId: e.periodId,
        jobId: e.jobId,
        paymentId: e.paymentId,
        correctsEntryId: e.correctsEntryId?.toString() ?? null,
        reason: e.reason,
        createdById: e.createdById,
        createdAt: e.createdAt.toISOString(),
      })),
    };
  }

  /** Periodo del ajuste: el del movimiento que corrige, el indicado o el actual. */
  private async adjustmentPeriod(
    tx: Prisma.TransactionClient,
    dto: RegisterAdjustmentDto,
    now: Date,
  ): Promise<string> {
    if (dto.correctsEntryId) {
      const corrected = await tx.ledgerEntry.findUnique({
        where: { id: BigInt(dto.correctsEntryId) },
        select: { workerId: true, periodId: true },
      });
      if (corrected?.workerId !== dto.workerId) {
        throw new ApiError(HttpStatus.NOT_FOUND, 'ENTRY_NOT_FOUND', 'El movimiento no existe.');
      }
      return corrected.periodId;
    }
    if (dto.periodId) {
      const period = await tx.billingPeriod.findUnique({
        where: { id: dto.periodId },
        select: { workerId: true },
      });
      if (period?.workerId !== dto.workerId) {
        throw new ApiError(HttpStatus.NOT_FOUND, 'PERIOD_NOT_FOUND', 'El periodo no existe.');
      }
      return dto.periodId;
    }
    return (await this.ledger.lockPeriodAt(tx, dto.workerId, now)).id;
  }

  /** Texto opcional: vacío o solo espacios = null. */
  private static optional(value: string | undefined): string | null {
    const trimmed = value?.trim();
    return trimmed === undefined || trimmed === '' ? null : trimmed;
  }

  private async requireWorker(workerId: string): Promise<void> {
    const profile = await this.prisma.workerProfile.findUnique({
      where: { userId: workerId },
      select: { userId: true },
    });
    if (!profile) throw workerNotFound();
  }
}

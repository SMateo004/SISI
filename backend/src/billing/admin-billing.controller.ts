import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  Query,
  Res,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiHeader,
  ApiOkResponse,
  ApiOperation,
  ApiProduces,
  ApiTags,
} from '@nestjs/swagger';
import type { Response } from 'express';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin, AdminExport } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { requireIdempotencyKey } from '../common/idempotency/idempotency';
import { PresignedUploadDto } from '../storage/dto/upload.dto';
import { BillingAdminService } from './billing-admin.service';
import { BillingExportService, type ExportRange, exportRange } from './billing-export.service';
import { BillingFilesService } from './billing-files.service';
import { BillingPanelService } from './billing-panel.service';
import {
  AdjustmentPreviewDto,
  BalancePreviewDto,
  CurrentQrDto,
  ExportQueryDto,
  LedgerPageDto,
  LedgerQueryDto,
  OverdueListDto,
  PanelPeriodPageDto,
  PaymentPreviewDto,
  PeriodsQueryDto,
} from './dto/billing-panel.dto';
import {
  FileUploadDto,
  ListSubmissionsQuery,
  AdminPaymentSubmissionDto,
  PaymentSubmissionDto,
  QrResultDto,
  RejectSubmissionDto,
  SetQrDto,
} from './dto/billing-files.dto';
import {
  AdjustmentResultDto,
  AdminWorkerBillingDto,
  PaymentResultDto,
  ReceiptUploadDto,
  RegisterAdjustmentDto,
  RegisterPaymentDto,
} from './dto/billing-admin.dto';

const IDEMPOTENCY_HEADER = {
  name: 'Idempotency-Key',
  required: true,
  description:
    'Obligatorio (8 a 100 caracteres). Un reintento con la misma clave devuelve el resultado original.',
};

/**
 * Cobros del admin (mínimo; la consola llega en la Fase 6). Montos como texto con 2
 * decimales, nunca como número de punto flotante.
 */
@ApiTags('admin')
@ApiBearerAuth()
@Admin('cobros')
@ApiForbiddenResponse({
  type: ApiErrorBody,
  description: 'FORBIDDEN (no admin) o SELF_REVIEW_FORBIDDEN (su propia cuenta)',
})
@Controller('admin/billing')
export class AdminBillingController {
  constructor(
    private readonly billing: BillingAdminService,
    private readonly files: BillingFilesService,
    private readonly panel: BillingPanelService,
    private readonly exports: BillingExportService,
  ) {}

  @Get('export/ledger.csv')
  @AdminExport()
  @ApiProduces('text/csv')
  @ApiOperation({
    summary: 'CSV del ledger por rango de fechas [desde, hasta), para el contador',
    description:
      'UTF-8 con BOM, separador coma, montos con punto decimal y fechas en la hora local de la ciudad. Queda auditado.',
  })
  @ApiOkResponse({ description: 'Archivo CSV' })
  async exportLedger(
    @AdminCtx() ctx: AdminContext,
    @Query() query: ExportQueryDto,
    @Res() res: Response,
  ): Promise<void> {
    const range = exportRange(query.from, query.to);
    await streamCsv(res, `sisi-ledger-${fileDate(range)}.csv`, this.exports.ledger(ctx, range));
  }

  @Get('export/payments.csv')
  @AdminExport()
  @ApiProduces('text/csv')
  @ApiOperation({
    summary: 'CSV de pagos por fecha de pago [desde, hasta), para el contador',
    description: 'Mismo formato que el del ledger. Queda auditado.',
  })
  @ApiOkResponse({ description: 'Archivo CSV' })
  async exportPayments(
    @AdminCtx() ctx: AdminContext,
    @Query() query: ExportQueryDto,
    @Res() res: Response,
  ): Promise<void> {
    const range = exportRange(query.from, query.to);
    await streamCsv(res, `sisi-pagos-${fileDate(range)}.csv`, this.exports.payments(ctx, range));
  }

  @Get('periods')
  @ApiOperation({
    summary: 'Periodos de cobro con filtros por estado, semana y ciudad',
    description: 'Más nuevos primero, 25 por página. El saldo es la suma del ledger.',
  })
  @ApiOkResponse({ type: PanelPeriodPageDto })
  periods(@Query() query: PeriodsQueryDto): Promise<PanelPeriodPageDto> {
    return this.panel.periods(query);
  }

  @Get('overdue')
  @ApiOperation({ summary: 'Periodos vencidos con monto y días de atraso (R7.7)' })
  @ApiOkResponse({ type: OverdueListDto })
  overdue(): Promise<OverdueListDto> {
    return this.panel.overdue();
  }

  @Get('workers/:id/ledger')
  @ApiOperation({
    summary: 'Ledger completo de un trabajador con saldo acumulado',
    description: 'Del más nuevo al más viejo, 50 por página.',
  })
  @ApiOkResponse({ type: LedgerPageDto })
  ledger(
    @Param('id', ParseUUIDPipe) id: string,
    @Query() query: LedgerQueryDto,
  ): Promise<LedgerPageDto> {
    return this.panel.ledgerOf(id, query.cursor);
  }

  @Post('payments/preview')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Efecto de un pago antes de registrarlo',
    description: 'Saldo antes y después, periodos que cubre y si desbloquea. No guarda nada.',
  })
  @ApiOkResponse({ type: BalancePreviewDto })
  previewPayment(
    @AdminCtx() ctx: AdminContext,
    @Body() dto: PaymentPreviewDto,
  ): Promise<BalancePreviewDto> {
    return this.panel.previewPayment(ctx, dto);
  }

  @Post('adjustments/preview')
  @HttpCode(200)
  @ApiOperation({ summary: 'Efecto de un ajuste antes de registrarlo (no guarda nada)' })
  @ApiOkResponse({ type: BalancePreviewDto })
  previewAdjustment(
    @AdminCtx() ctx: AdminContext,
    @Body() dto: AdjustmentPreviewDto,
  ): Promise<BalancePreviewDto> {
    return this.panel.previewAdjustment(ctx, dto);
  }

  @Get('qr')
  @ApiOperation({ summary: 'QR de cobro actual (URL temporal), o null si no hay' })
  @ApiOkResponse({ type: CurrentQrDto })
  async currentQr(): Promise<CurrentQrDto> {
    return { qrUrl: await this.files.qrUrl() };
  }

  @Post('receipts/upload-url')
  @ApiOperation({ summary: 'URL para subir el comprobante de un pago (receipts/, privado)' })
  @ApiOkResponse({ type: PresignedUploadDto })
  receiptUploadUrl(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: ReceiptUploadDto,
  ): Promise<PresignedUploadDto> {
    return this.billing.receiptUploadUrl(current.id, dto.workerId, dto.contentType, dto.sizeBytes);
  }

  @Post('payments')
  @HttpCode(200)
  @ApiHeader(IDEMPOTENCY_HEADER)
  @ApiOperation({
    summary: 'Registrar un pago (R7.4)',
    description:
      'Se aplica a los periodos más antiguos primero; lo que sobra queda como adelanto o saldo a favor en el periodo actual. Desbloquea si ya no queda deuda vencida.',
  })
  @ApiOkResponse({ type: PaymentResultDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'IDEMPOTENCY_KEY_REQUIRED, AMOUNT_INVALID, PAID_AT_INVALID…',
  })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'IDEMPOTENCY_KEY_REUSED' })
  registerPayment(
    @AdminCtx() ctx: AdminContext,
    @Headers('idempotency-key') key: string | undefined,
    @Body() dto: RegisterPaymentDto,
  ): Promise<PaymentResultDto> {
    return this.billing.registerPayment(ctx, requireIdempotencyKey(key), dto);
  }

  @Post('adjustments')
  @HttpCode(200)
  @ApiHeader(IDEMPOTENCY_HEADER)
  @ApiOperation({
    summary: 'Registrar un ajuste (R7.9)',
    description:
      'Monto con signo y motivo obligatorio. Nunca se edita un movimiento: se agrega uno nuevo.',
  })
  @ApiOkResponse({ type: AdjustmentResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'IDEMPOTENCY_KEY_REUSED' })
  registerAdjustment(
    @AdminCtx() ctx: AdminContext,
    @Headers('idempotency-key') key: string | undefined,
    @Body() dto: RegisterAdjustmentDto,
  ): Promise<AdjustmentResultDto> {
    return this.billing.registerAdjustment(ctx, requireIdempotencyKey(key), dto);
  }

  @Get('workers/:id')
  @ApiOperation({ summary: 'Saldo, periodos y movimientos de un trabajador' })
  @ApiOkResponse({ type: AdminWorkerBillingDto })
  worker(@Param('id', ParseUUIDPipe) id: string): Promise<AdminWorkerBillingDto> {
    return this.billing.workerBilling(id);
  }

  @Post('qr/upload-url')
  @ApiOperation({ summary: 'URL para subir la imagen del QR de cobro de la empresa' })
  @ApiOkResponse({ type: PresignedUploadDto })
  qrUploadUrl(@Body() dto: FileUploadDto): Promise<PresignedUploadDto> {
    return this.files.qrUploadUrl(dto.contentType, dto.sizeBytes);
  }

  @Put('qr')
  @ApiOperation({
    summary: 'Configurar el QR de cobro (R7.4)',
    description: 'Después del PUT a la URL de subida. Los trabajadores lo ven en "Pagar comisión".',
  })
  @ApiOkResponse({ type: QrResultDto })
  setQr(@AdminCtx() ctx: AdminContext, @Body() dto: SetQrDto): Promise<QrResultDto> {
    return this.files.setQr(ctx, dto.key);
  }

  @Get('submissions')
  @ApiOperation({ summary: 'Comprobantes enviados por los trabajadores (por defecto, pendientes)' })
  @ApiOkResponse({ type: [AdminPaymentSubmissionDto] })
  submissions(@Query() q: ListSubmissionsQuery): Promise<AdminPaymentSubmissionDto[]> {
    return this.files.listSubmissions(q.status ?? 'pendiente');
  }

  @Post('submissions/:id/reject')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Rechazar un comprobante',
    description: 'Para aceptarlo se registra el pago con submissionId.',
  })
  @ApiOkResponse({ type: PaymentSubmissionDto })
  rejectSubmission(
    @AdminCtx() ctx: AdminContext,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: RejectSubmissionDto,
  ): Promise<PaymentSubmissionDto> {
    return this.files.rejectSubmission(ctx, id, dto.note.trim());
  }
}

const fileDate = (r: ExportRange): string =>
  `${r.from.toISOString().slice(0, 10)}_${r.to.toISOString().slice(0, 10)}`;

/** Escribe el CSV por partes; si falla a mitad, corta la respuesta (no queda un archivo "completo"). */
async function streamCsv(res: Response, filename: string, chunks: AsyncIterable<string>) {
  res.setHeader('Content-Type', 'text/csv; charset=utf-8');
  res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
  res.setHeader('Cache-Control', 'no-store');
  try {
    for await (const chunk of chunks) {
      if (!res.write(chunk)) await new Promise((r) => res.once('drain', r));
    }
    res.end();
  } catch (error) {
    res.destroy(error as Error);
  }
}

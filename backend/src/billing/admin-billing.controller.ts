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
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiHeader,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { requireIdempotencyKey } from '../common/idempotency/idempotency';
import { PresignedUploadDto } from '../storage/dto/upload.dto';
import { BillingAdminService } from './billing-admin.service';
import { BillingFilesService } from './billing-files.service';
import {
  FileUploadDto,
  ListSubmissionsQuery,
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
  ) {}

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
    @CurrentUser() current: AuthenticatedUser,
    @Headers('idempotency-key') key: string | undefined,
    @Body() dto: RegisterPaymentDto,
  ): Promise<PaymentResultDto> {
    return this.billing.registerPayment(current.id, requireIdempotencyKey(key), dto);
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
    @CurrentUser() current: AuthenticatedUser,
    @Headers('idempotency-key') key: string | undefined,
    @Body() dto: RegisterAdjustmentDto,
  ): Promise<AdjustmentResultDto> {
    return this.billing.registerAdjustment(current.id, requireIdempotencyKey(key), dto);
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
  setQr(@CurrentUser() current: AuthenticatedUser, @Body() dto: SetQrDto): Promise<QrResultDto> {
    return this.files.setQr(current.id, dto.key);
  }

  @Get('submissions')
  @ApiOperation({ summary: 'Comprobantes enviados por los trabajadores (por defecto, pendientes)' })
  @ApiOkResponse({ type: [PaymentSubmissionDto] })
  submissions(@Query() q: ListSubmissionsQuery): Promise<PaymentSubmissionDto[]> {
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
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: RejectSubmissionDto,
  ): Promise<PaymentSubmissionDto> {
    return this.files.rejectSubmission(current.id, id, dto.note.trim());
  }
}

import {
  Body,
  Controller,
  Get,
  Headers,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
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
import { type AuthenticatedUser, CurrentUser, Roles } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { requireIdempotencyKey } from '../common/idempotency/idempotency';
import { PresignedUploadDto } from '../storage/dto/upload.dto';
import { BillingAdminService } from './billing-admin.service';
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
@Roles('admin')
@ApiForbiddenResponse({
  type: ApiErrorBody,
  description: 'FORBIDDEN (no admin) o SELF_REVIEW_FORBIDDEN (su propia cuenta)',
})
@Controller('admin/billing')
export class AdminBillingController {
  constructor(private readonly billing: BillingAdminService) {}

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
}

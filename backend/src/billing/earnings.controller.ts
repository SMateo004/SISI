import { Controller, Get, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import {
  CursorQuery,
  EarningsSummaryDto,
  PayInfoDto,
  PaymentPageDto,
  PeriodPageDto,
} from './dto/earnings.dto';
import { EarningsService } from './earnings.service';

/**
 * Ganancias del trabajador (R8). Todos los montos son texto con 2 decimales ("19.50"),
 * nunca números de punto flotante. El historial de trabajos con comisión es GET /jobs?role=worker.
 */
@ApiTags('ganancias')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller('me')
export class EarningsController {
  constructor(private readonly earnings: EarningsService) {}

  @Get('earnings/summary')
  @ApiOperation({
    summary: 'Resumen de ganancias (R8.1)',
    description:
      'Periodo actual (bruto, comisión, neto), saldo pendiente total, próxima fecha límite y estado del tope.',
  })
  @ApiOkResponse({ type: EarningsSummaryDto })
  summary(@CurrentUser() current: AuthenticatedUser): Promise<EarningsSummaryDto> {
    return this.earnings.summary(current.id);
  }

  @Get('earnings/periods')
  @ApiOperation({ summary: 'Historial de periodos (cortes semanales)' })
  @ApiOkResponse({ type: PeriodPageDto })
  periods(
    @CurrentUser() current: AuthenticatedUser,
    @Query() q: CursorQuery,
  ): Promise<PeriodPageDto> {
    return this.earnings.periods(current.id, q.cursor);
  }

  @Get('payments')
  @ApiOperation({
    summary: 'Historial de pagos (R8.2)',
    description: 'Periodos cubiertos, monto, fecha, estado y enlace temporal al comprobante.',
  })
  @ApiOkResponse({ type: PaymentPageDto })
  payments(
    @CurrentUser() current: AuthenticatedUser,
    @Query() q: CursorQuery,
  ): Promise<PaymentPageDto> {
    return this.earnings.payments(current.id, q.cursor);
  }

  @Get('billing/pay-info')
  @ApiOperation({
    summary: 'Datos para pagar la comisión (R7.4)',
    description:
      'QR de la empresa, monto para ponerte al día, monto para volver a recibir solicitudes (si el tope está alcanzado), referencia para la glosa e instrucciones.',
  })
  @ApiOkResponse({ type: PayInfoDto })
  payInfo(@CurrentUser() current: AuthenticatedUser): Promise<PayInfoDto> {
    return this.earnings.payInfo(current.id);
  }
}

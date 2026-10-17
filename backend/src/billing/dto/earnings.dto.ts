import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsUUID } from 'class-validator';

const MONEY_NOTE = 'Monto en Bs como texto con 2 decimales (nunca número de punto flotante).';
const money = (example: string, description?: string) =>
  ApiProperty({
    type: String,
    example,
    description: description ? `${description} ${MONEY_NOTE}` : MONEY_NOTE,
  });

export class CurrentPeriodDto {
  @ApiProperty({
    type: String,
    nullable: true,
    format: 'uuid',
    description: 'null si todavía no hay trabajos esta semana',
  })
  id!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) startAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) endAt!: string;
  @ApiProperty({
    type: String,
    format: 'date-time',
    description: 'Vencimiento de este periodo (miércoles 23:59 siguiente)',
  })
  dueAt!: string;
  @money('150.00', 'Ganado en el periodo (bruto, R8.1).') grossBs!: string;
  @money('19.50', 'Comisión del periodo.') commissionBs!: string;
  @money('130.50', 'Neto del periodo: bruto − comisión.') netBs!: string;
  @ApiProperty({ type: String, nullable: true }) paymentReference!: string | null;
}

export class DebtCapStateDto {
  @money('150.00') capBs!: string;
  @ApiProperty({ description: 'El saldo supera el tope: no recibe solicitudes nuevas (R7.5)' })
  reached!: boolean;
  @money(
    '12.30',
    'Lo que hay que pagar para volver a recibir solicitudes (0 si no está sobre el tope).',
  )
  amountToUnlockBs!: string;
}

export class EarningsSummaryDto {
  @ApiProperty({ type: CurrentPeriodDto }) currentPeriod!: CurrentPeriodDto;
  @money(
    '29.90',
    'Saldo pendiente total = suma del ledger, periodo abierto incluido. Negativo = saldo a favor.',
  )
  balanceBs!: string;
  @money('19.50', 'Periodos cerrados impagos ("para ponerte al día").') overdueOrPendingBs!: string;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Próxima fecha límite con deuda',
  })
  nextDueAt!: string | null;
  @ApiProperty({ description: 'Tiene algún periodo vencido' }) overdue!: boolean;
  @ApiProperty({ description: 'Modo trabajador bloqueado por deuda (R7.7)' }) blocked!: boolean;
  @ApiProperty({ type: DebtCapStateDto }) debtCap!: DebtCapStateDto;
}

export class PeriodSummaryDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: String, format: 'date-time' }) startAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) endAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) dueAt!: string;
  @ApiProperty({ enum: ['abierto', 'cerrado_pendiente', 'pagado', 'vencido'] }) status!: string;
  @money('150.00') grossBs!: string;
  @money('19.50') commissionBs!: string;
  @money('130.50') netBs!: string;
  @money('0.00', 'Lo que queda por pagar de este periodo (negativo = a favor).') balanceBs!: string;
  @ApiProperty() paymentReference!: string;
}

export class PeriodPageDto {
  @ApiProperty({ type: [PeriodSummaryDto] }) items!: PeriodSummaryDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class PaymentAllocationDto {
  @ApiProperty({ format: 'uuid' }) periodId!: string;
  @ApiProperty() paymentReference!: string;
  @money('19.50') amountBs!: string;
}

export class MyPaymentDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @money('29.90') amountBs!: string;
  @ApiProperty({ type: String, format: 'date-time' }) paidAt!: string;
  @ApiProperty({ enum: ['qr_transferencia', 'efectivo', 'otro'] }) method!: string;
  @ApiProperty({
    enum: ['registrado'],
    description:
      'Un pago del historial ya está registrado; los comprobantes en revisión están en /me/billing/submissions',
  })
  status!: 'registrado';
  @ApiProperty({ type: String, nullable: true }) reference!: string | null;
  @ApiProperty({ type: [PaymentAllocationDto], description: 'Periodos que cubrió' })
  periods!: PaymentAllocationDto[];
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Enlace temporal al comprobante (R8.2)',
  })
  receiptUrl!: string | null;
}

export class PaymentPageDto {
  @ApiProperty({ type: [MyPaymentDto] }) items!: MyPaymentDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class PayInfoDto {
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'URL temporal del QR de la empresa (null si no está cargado)',
  })
  qrUrl!: string | null;
  @money('19.50', '"Para ponerte al día": periodos cerrados impagos.') catchUpAmountBs!: string;
  @money(
    '12.30',
    '"Para volver a recibir solicitudes": lo que deja el saldo en el tope (0 si no está sobre el tope).',
  )
  unlockAmountBs!: string;
  @money('29.90', 'Saldo total, periodo abierto incluido (pago anticipado).')
  totalBalanceBs!: string;
  @ApiProperty({
    type: String,
    nullable: true,
    example: 'SISI-2643-K7M2QX',
    description: 'Para la glosa: la del periodo más antiguo con deuda',
  })
  paymentReference!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) dueAt!: string | null;
  @ApiProperty({ type: [String], description: 'Pasos en español' }) instructions!: string[];
  @ApiProperty({ description: 'Pago en línea (pasarela) disponible; hoy siempre false' })
  gatewayEnabled!: boolean;
}

export class CursorQuery {
  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID('all', { message: 'Cursor inválido.' })
  cursor?: string;
}

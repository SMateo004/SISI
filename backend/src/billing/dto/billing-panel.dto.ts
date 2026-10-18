import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsIn, IsOptional, IsUUID, Matches } from 'class-validator';

const MONEY = /^\d{1,8}(\.\d{1,2})?$/;
const SIGNED_MONEY = /^-?\d{1,8}(\.\d{1,2})?$/;
export const PERIOD_STATUSES = ['abierto', 'cerrado_pendiente', 'pagado', 'vencido'] as const;

export class PeriodsQueryDto {
  @ApiPropertyOptional({ enum: PERIOD_STATUSES })
  @IsOptional()
  @IsIn(PERIOD_STATUSES)
  status?: (typeof PERIOD_STATUSES)[number];

  @ApiPropertyOptional({ example: '2026-W42', description: 'Semana ISO del inicio del periodo' })
  @IsOptional()
  @Matches(/^\d{4}-W(0[1-9]|[1-4]\d|5[0-3])$/, { message: 'La semana es AAAA-Www.' })
  week?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  cityId?: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'nextCursor de la página anterior' })
  @IsOptional()
  @IsUUID()
  cursor?: string;
}

export class PanelPeriodDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) workerId!: string;
  @ApiProperty({ type: String, nullable: true }) workerName!: string | null;
  @ApiProperty() workerPhone!: string;
  @ApiProperty({ enum: PERIOD_STATUSES }) status!: string;
  @ApiProperty() paymentReference!: string;
  @ApiProperty({ type: String, format: 'date-time' }) startAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) endAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) dueAt!: string;
  @ApiProperty({ example: '150.00' }) grossBs!: string;
  @ApiProperty({ example: '19.50' }) commissionBs!: string;
  @ApiProperty({ example: '19.50', description: 'Saldo del periodo (suma del ledger)' })
  balanceBs!: string;
}

export class PanelPeriodPageDto {
  @ApiProperty({ type: PanelPeriodDto, isArray: true }) items!: PanelPeriodDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class OverdueRowDto extends PanelPeriodDto {
  @ApiProperty({ example: 3, description: 'Días de atraso en la zona de la ciudad' })
  daysLate!: number;
  @ApiProperty({ example: 'bloqueado_deuda' }) workerStatus!: string;
}

export class OverdueListDto {
  @ApiProperty({ type: OverdueRowDto, isArray: true }) items!: OverdueRowDto[];
  @ApiProperty({ example: '89.70', description: 'Suma de los saldos vencidos' })
  totalBs!: string;
}

export class LedgerQueryDto {
  @ApiPropertyOptional({ example: '40', description: 'nextCursor de la página anterior' })
  @IsOptional()
  @Matches(/^\d{1,19}$/)
  cursor?: string;
}

export class LedgerRowDto {
  @ApiProperty({ example: '42' }) id!: string;
  @ApiProperty({ enum: ['comision', 'pago', 'ajuste'] }) type!: string;
  @ApiProperty({ example: '19.50', description: 'Con signo: + debe, − paga' }) amountBs!: string;
  @ApiProperty({ example: '29.90', description: 'Saldo acumulado después de este movimiento' })
  runningBs!: string;
  @ApiProperty() paymentReference!: string;
  @ApiProperty({ type: String, nullable: true }) jobId!: string | null;
  @ApiProperty({ type: String, nullable: true }) paymentId!: string | null;
  @ApiProperty({ type: String, nullable: true }) correctsEntryId!: string | null;
  @ApiProperty({ type: String, nullable: true }) reason!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class LedgerPageDto {
  @ApiProperty({ example: '29.90' }) balanceBs!: string;
  @ApiProperty({ type: LedgerRowDto, isArray: true, description: 'Del más nuevo al más viejo' })
  items!: LedgerRowDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class PaymentPreviewDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('all', { message: 'El trabajador no es válido.' })
  workerId!: string;

  @ApiProperty({ example: '29.90' })
  @Matches(MONEY, { message: 'El monto no es válido.' })
  amountBs!: string;
}

export class AdjustmentPreviewDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('all', { message: 'El trabajador no es válido.' })
  workerId!: string;

  @ApiProperty({ example: '-19.50', description: 'Con signo: + aumenta la deuda' })
  @Matches(SIGNED_MONEY, { message: 'El monto no es válido.' })
  amountBs!: string;

  @ApiPropertyOptional({ example: '42' })
  @IsOptional()
  @Matches(/^\d{1,19}$/)
  correctsEntryId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  periodId?: string;
}

export class PreviewAllocationDto {
  @ApiProperty({
    type: String,
    nullable: true,
    format: 'uuid',
    description: 'null = periodo actual que todavía no existe',
  })
  periodId!: string | null;
  @ApiProperty({ type: String, nullable: true }) paymentReference!: string | null;
  @ApiProperty({ example: '19.50' }) amountBs!: string;
  @ApiProperty({ example: '0.00' }) periodBalanceAfterBs!: string;
  @ApiProperty({ enum: PERIOD_STATUSES }) statusAfter!: string;
}

export class BalancePreviewDto {
  @ApiProperty({ example: '29.90' }) balanceBeforeBs!: string;
  @ApiProperty({ example: '0.00' }) balanceAfterBs!: string;
  @ApiProperty({ type: PreviewAllocationDto, isArray: true }) allocations!: PreviewAllocationDto[];
  @ApiProperty({ description: 'Hoy está bloqueado por deuda' }) blockedNow!: boolean;
  @ApiProperty({ description: 'Después de esto no quedaría ningún periodo vencido' })
  unblocks!: boolean;
}

export class ExportQueryDto {
  @ApiProperty({ type: String, format: 'date-time', example: '2026-10-01T04:00:00.000Z' })
  @IsDateString({}, { message: 'La fecha "desde" no es válida.' })
  from!: string;

  @ApiProperty({ type: String, format: 'date-time', example: '2026-11-01T04:00:00.000Z' })
  @IsDateString({}, { message: 'La fecha "hasta" no es válida.' })
  to!: string;
}

export class CurrentQrDto {
  @ApiProperty({ type: String, nullable: true, description: 'URL temporal; null si no hay QR' })
  qrUrl!: string | null;
}

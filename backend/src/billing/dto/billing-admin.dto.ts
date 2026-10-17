import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsDateString,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

const MONEY = /^\d{1,8}(\.\d{1,2})?$/;
const SIGNED_MONEY = /^-?\d{1,8}(\.\d{1,2})?$/;

export const PAYMENT_METHODS = ['qr_transferencia', 'efectivo', 'otro'] as const;
export type PaymentMethodValue = (typeof PAYMENT_METHODS)[number];

export class RegisterPaymentDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('all', { message: 'El trabajador no es válido.' })
  workerId!: string;

  @ApiProperty({ example: '29.90', description: 'Monto pagado en Bs (texto, 2 decimales)' })
  @Matches(MONEY, { message: 'El monto no es válido.' })
  amountBs!: string;

  @ApiProperty({ enum: PAYMENT_METHODS })
  @IsIn(PAYMENT_METHODS, { message: 'El método de pago no es válido.' })
  method!: PaymentMethodValue;

  @ApiProperty({ type: String, format: 'date-time', description: 'Cuándo pagó (no futuro)' })
  @IsDateString({}, { message: 'La fecha de pago no es válida.' })
  paidAt!: string;

  @ApiPropertyOptional({ example: 'SISI-2643-K7M2QX' })
  @IsOptional()
  @IsString()
  @MaxLength(60)
  reference?: string;

  @ApiPropertyOptional({ description: 'Clave del comprobante subido (receipts/{worker}/…)' })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  receiptKey?: string;

  @ApiPropertyOptional({ description: 'Número de factura (sin uso hasta la revisión tributaria)' })
  @IsOptional()
  @IsString()
  @MaxLength(40)
  invoiceNumber?: string;
}

export class RegisterAdjustmentDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('all', { message: 'El trabajador no es válido.' })
  workerId!: string;

  @ApiProperty({
    example: '-19.50',
    description: 'Con signo: positivo aumenta la deuda; negativo la reduce (ADR-0034)',
  })
  @Matches(SIGNED_MONEY, { message: 'El monto no es válido.' })
  amountBs!: string;

  @ApiProperty({ example: 'Comisión cobrada dos veces por error', minLength: 5, maxLength: 300 })
  @IsString()
  @MinLength(5, { message: 'Escribe el motivo del ajuste.' })
  @MaxLength(300)
  reason!: string;

  @ApiPropertyOptional({ description: 'Id del movimiento que corrige' })
  @IsOptional()
  @Matches(/^\d{1,18}$/, { message: 'El movimiento no es válido.' })
  correctsEntryId?: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Periodo (por defecto, el del movimiento corregido o el actual)',
  })
  @IsOptional()
  @IsUUID('all')
  periodId?: string;
}

export class ReceiptUploadDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('all')
  workerId!: string;

  @ApiProperty({ example: 'image/jpeg' })
  @IsString()
  contentType!: string;

  @ApiProperty({ example: 120000 })
  @IsInt()
  @Min(1)
  sizeBytes!: number;
}

export class AllocationDto {
  @ApiProperty({ format: 'uuid' }) periodId!: string;
  @ApiProperty({ example: 'SISI-2643-K7M2QX' }) paymentReference!: string;
  @ApiProperty({ example: '19.50' }) amountBs!: string;
  @ApiProperty({ enum: ['abierto', 'cerrado_pendiente', 'pagado', 'vencido'] }) status!: string;
}

export class PaymentResultDto {
  @ApiProperty({ format: 'uuid' }) paymentId!: string;
  @ApiProperty({ format: 'uuid' }) workerId!: string;
  @ApiProperty({ example: '29.90' }) amountBs!: string;
  @ApiProperty({ type: [AllocationDto], description: 'Cómo se aplicó: más antiguo primero' })
  allocations!: AllocationDto[];
  @ApiProperty({ example: '0.00', description: 'Saldo después del pago (negativo = a favor)' })
  balanceBs!: string;
}

export class AdjustmentResultDto {
  @ApiProperty({ example: '42' }) entryId!: string;
  @ApiProperty({ format: 'uuid' }) periodId!: string;
  @ApiProperty({ example: '-19.50' }) amountBs!: string;
  @ApiProperty({ enum: ['abierto', 'cerrado_pendiente', 'pagado', 'vencido'] })
  periodStatus!: string;
  @ApiProperty({ example: '0.00' }) balanceBs!: string;
}

export class AdminPeriodDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: String, format: 'date-time' }) startAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) endAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) dueAt!: string;
  @ApiProperty({ enum: ['abierto', 'cerrado_pendiente', 'pagado', 'vencido'] }) status!: string;
  @ApiProperty({ example: '150.00' }) grossBs!: string;
  @ApiProperty({ example: '19.50' }) commissionBs!: string;
  @ApiProperty({ example: '19.50' }) balanceBs!: string;
  @ApiProperty() paymentReference!: string;
}

export class AdminLedgerEntryDto {
  @ApiProperty({ example: '42' }) id!: string;
  @ApiProperty({ enum: ['comision', 'pago', 'ajuste'] }) type!: string;
  @ApiProperty({ example: '19.50' }) amountBs!: string;
  @ApiProperty({ format: 'uuid' }) periodId!: string;
  @ApiProperty({ type: String, nullable: true }) jobId!: string | null;
  @ApiProperty({ type: String, nullable: true }) paymentId!: string | null;
  @ApiProperty({ type: String, nullable: true }) correctsEntryId!: string | null;
  @ApiProperty({ type: String, nullable: true }) reason!: string | null;
  @ApiProperty({ type: String, nullable: true }) createdById!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class AdminWorkerBillingDto {
  @ApiProperty({ format: 'uuid' }) workerId!: string;
  @ApiProperty({ example: '19.50', description: 'Saldo total = suma del ledger' })
  balanceBs!: string;
  @ApiProperty({ type: [AdminPeriodDto] }) periods!: AdminPeriodDto[];
  @ApiProperty({ type: [AdminLedgerEntryDto], description: 'Últimos 100 movimientos' })
  entries!: AdminLedgerEntryDto[];
}

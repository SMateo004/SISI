import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';
import { JOB_ACTIONS, JOB_STATUSES, type JobAction, type JobStatus } from '../job-status.machine';

export class JobCategoryDto {
  @ApiProperty({ example: 'plomeria' }) slug!: string;
  @ApiProperty({ example: 'Plomería' }) name!: string;
}

export class JobCounterpartDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty({ example: 'María P.' }) shortName!: string;
}

/** Línea de tiempo: un timestamp por estado (R6.1). null = todavía no pasó. */
export class JobTimelineDto {
  @ApiProperty({ type: String, format: 'date-time' }) assignedAt!: string;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) onTheWayAt!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) startedAt!: string | null;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'El trabajador marcó "Terminé"',
  })
  workerFinishedAt!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) disputedAt!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) completedAt!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) cancelledAt!: string | null;
}

export const JOB_CANCEL_REASONS = [
  'cambio_de_planes',
  'no_llega_o_no_responde',
  'desacuerdo_de_precio',
  'emergencia',
  'otro',
] as const;
export type JobCancelReason = (typeof JOB_CANCEL_REASONS)[number];

export class JobCancellationDto {
  @ApiProperty({ enum: ['worker', 'employer', 'admin'], description: 'Quién canceló' })
  by!: 'worker' | 'employer' | 'admin';
  @ApiProperty({ enum: JOB_CANCEL_REASONS, nullable: true, type: String })
  reason!: JobCancelReason | null;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Nota de quien canceló. Si la moderación la retuvo, solo la ve quien la escribió.',
  })
  note!: string | null;
  @ApiProperty({
    description: 'La nota quedó retenida por moderación (solo para quien la escribió)',
  })
  noteHeld!: boolean;
}

export class JobDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) requestId!: string;
  @ApiProperty({ enum: JOB_STATUSES }) status!: JobStatus;
  @ApiProperty({ enum: ['worker', 'employer'], description: 'Mi rol en este trabajo' })
  myRole!: 'worker' | 'employer';
  @ApiProperty({ type: JobCategoryDto }) category!: JobCategoryDto;
  @ApiProperty() description!: string;
  @ApiProperty({ type: JobCounterpartDto }) counterpart!: JobCounterpartDto;
  @ApiProperty({ example: '150.00' }) finalPriceBs!: string;
  @ApiProperty({
    type: String,
    nullable: true,
    example: '19.50',
    description: 'Comisión (R6.3, R8.3). Solo para el trabajador y con el trabajo terminado.',
  })
  commissionBs!: string | null;
  @ApiProperty({
    type: String,
    nullable: true,
    example: '130.50',
    description: 'Lo que recibe el trabajador: precio final − comisión. Solo para el trabajador.',
  })
  netBs!: string | null;
  @ApiProperty({ type: JobTimelineDto }) timeline!: JobTimelineDto;
  @ApiProperty({ description: 'Se confirmó solo, pasado el plazo sin respuesta del empleador' })
  autoConfirmed!: boolean;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Cuándo se confirmará solo, si el empleador no responde',
  })
  autoConfirmAt!: string | null;
  @ApiProperty({ type: JobCancellationDto, nullable: true })
  cancellation!: JobCancellationDto | null;
  @ApiProperty({
    enum: JOB_ACTIONS,
    isArray: true,
    description: 'Lo que puedo hacer ahora (para mostrar los botones)',
  })
  allowedActions!: JobAction[];
}

export class JobPageDto {
  @ApiProperty({ type: [JobDto] }) items!: JobDto[];
  @ApiProperty({ type: String, nullable: true, description: 'Cursor para la siguiente página' })
  nextCursor!: string | null;
}

export class ListJobsQuery {
  @ApiProperty({
    enum: ['worker', 'employer'],
    description: 'Historial como trabajador o como empleador',
  })
  @IsIn(['worker', 'employer'], { message: 'El rol no es válido.' })
  role!: 'worker' | 'employer';

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID('all', { message: 'Cursor inválido.' })
  cursor?: string;

  @ApiPropertyOptional({ default: 20, maximum: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;
}

export class DisputeJobDto {
  @ApiPropertyOptional({ example: 'El trabajo quedó a medias.', maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500, { message: 'El detalle no puede pasar de 500 caracteres.' })
  note?: string;
}

export class CancelJobDto {
  @ApiProperty({ enum: JOB_CANCEL_REASONS })
  @IsIn(JOB_CANCEL_REASONS, { message: 'Elige un motivo de la lista.' })
  reason!: JobCancelReason;

  @ApiPropertyOptional({ example: 'Me surgió una emergencia familiar.', maxLength: 300 })
  @IsOptional()
  @IsString()
  @MaxLength(300, { message: 'La nota no puede pasar de 300 caracteres.' })
  note?: string;
}

export class ResolveDisputeDto {
  @ApiProperty({
    enum: ['confirm', 'cancel'],
    description: 'confirm = terminado con comisión; cancel = cancelado sin comisión',
  })
  @IsIn(['confirm', 'cancel'], { message: 'La decisión no es válida.' })
  decision!: 'confirm' | 'cancel';

  @ApiProperty({ example: 'Se verificó con ambas partes.', minLength: 3, maxLength: 500 })
  @IsString()
  @MinLength(3, { message: 'Escribe la nota de la resolución.' })
  @MaxLength(500)
  note!: string;
}

/** Trabajo con disputa abierta, para el admin. */
export class AdminDisputedJobDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) requestId!: string;
  @ApiProperty({ format: 'uuid' }) workerId!: string;
  @ApiProperty({ format: 'uuid' }) employerId!: string;
  @ApiProperty({ type: JobCategoryDto }) category!: JobCategoryDto;
  @ApiProperty({ example: '150.00' }) finalPriceBs!: string;
  @ApiProperty({ type: String, format: 'date-time' }) workerFinishedAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) disputedAt!: string;
  @ApiProperty({ type: String, nullable: true }) disputeNote!: string | null;
}

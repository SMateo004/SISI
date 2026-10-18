import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
  MinLength,
} from 'class-validator';
import {
  REPORT_REASONS,
  REPORT_TARGETS,
  type ReportReasonValue,
  type ReportTargetValue,
} from '../report.rules';

export class CreateReportDto {
  @ApiProperty({ enum: REPORT_TARGETS })
  @IsIn(REPORT_TARGETS, { message: 'No se puede reportar eso.' })
  targetType!: ReportTargetValue;

  @ApiProperty({ format: 'uuid' })
  @IsUUID('all', { message: 'El objetivo no es válido.' })
  targetId!: string;

  @ApiProperty({ enum: REPORT_REASONS })
  @IsIn(REPORT_REASONS, { message: 'Elige un motivo de la lista.' })
  reason!: ReportReasonValue;

  @ApiPropertyOptional({ maxLength: 500, example: 'Me pidió pagar por fuera de la app.' })
  @IsOptional()
  @IsString()
  @MaxLength(500, { message: 'El detalle no puede pasar de 500 caracteres.' })
  note?: string;
}

export class ReportDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: REPORT_TARGETS }) targetType!: ReportTargetValue;
  @ApiProperty({ format: 'uuid' }) targetId!: string;
  @ApiProperty({ enum: REPORT_REASONS }) reason!: ReportReasonValue;
  @ApiProperty({ enum: ['pendiente', 'valido', 'descartado'] }) status!:
    'pendiente' | 'valido' | 'descartado';
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class ReportedUserDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty() phone!: string;
  @ApiProperty({ description: 'Personas distintas con un reporte válido contra este usuario' })
  validReporters!: number;
  @ApiProperty({ type: String, nullable: true }) workerStatus!: string | null;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Marcado para revisión (solo empleador con 3 reportes válidos)',
  })
  flaggedAt!: string | null;
}

export class AdminReportDto extends ReportDto {
  @ApiProperty({ format: 'uuid' }) reporterId!: string;
  @ApiProperty({ type: String, nullable: true }) reporterName!: string | null;
  @ApiProperty() reporterPhone!: string;
  @ApiProperty({ description: 'Qué se reportó, en una línea' }) targetSummary!: string;
  @ApiProperty({ type: String, nullable: true }) note!: string | null;
  @ApiProperty() noteHeld!: boolean;
  @ApiProperty({ type: String, nullable: true }) resolution!: string | null;
  @ApiProperty({ type: ReportedUserDto }) reportedUser!: ReportedUserDto;
}

export class ListReportsQuery {
  @ApiPropertyOptional({ enum: ['pendiente', 'valido', 'descartado'], default: 'pendiente' })
  @IsOptional()
  @IsIn(['pendiente', 'valido', 'descartado'])
  status?: 'pendiente' | 'valido' | 'descartado';

  @ApiPropertyOptional({ format: 'uuid', description: 'nextCursor de la página anterior' })
  @IsOptional()
  @IsUUID()
  cursor?: string;
}

export class AdminReportPageDto {
  @ApiProperty({ type: AdminReportDto, isArray: true }) items!: AdminReportDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class ResolveReportDto {
  @ApiProperty({ description: 'true = válido (cuenta para la suspensión); false = descartado' })
  @IsBoolean()
  valid!: boolean;

  @ApiProperty({ example: 'Se verificó el mensaje.', minLength: 3, maxLength: 500 })
  @IsString()
  @MinLength(3, { message: 'Escribe la resolución.' })
  @MaxLength(500)
  resolution!: string;
}

export class ResolveReportResultDto {
  @ApiProperty({ type: AdminReportDto }) report!: AdminReportDto;
  @ApiProperty({
    enum: ['suspend', 'flag', 'none'],
    description: 'suspend = el trabajador quedó suspendido; flag = marcado para revisión',
  })
  outcome!: 'suspend' | 'flag' | 'none';
}

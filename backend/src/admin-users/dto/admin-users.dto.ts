import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsOptional, IsString, IsUUID, MaxLength, MinLength } from 'class-validator';

export class UserSearchQueryDto {
  @ApiPropertyOptional({
    example: '7001',
    description: 'Teléfono (dígitos, con o sin +591) o parte del nombre. Vacío: los más nuevos.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(64)
  @Transform(({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value))
  q?: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'nextCursor de la página anterior' })
  @IsOptional()
  @IsUUID()
  cursor?: string;
}

export class UserRowDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ example: '+59170012345' }) phone!: string;
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty({ enum: ['user', 'admin'] }) role!: string;
  @ApiProperty({ enum: ['employer', 'worker'] }) activeMode!: string;
  @ApiProperty() cityName!: string;
  @ApiProperty({ type: String, nullable: true, description: 'Estado del perfil de trabajador' })
  workerStatus!: string | null;
  @ApiProperty({ description: 'Empleador marcado para revisión (3 reportes válidos)' })
  flagged!: boolean;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class UserPageDto {
  @ApiProperty({ type: UserRowDto, isArray: true }) items!: UserRowDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class RatingDto {
  @ApiProperty({ example: '4.50' }) avg!: string;
  @ApiProperty({ example: 12 }) count!: number;
}

export class WorkerSummaryDto {
  @ApiProperty() status!: string;
  @ApiProperty({ type: String, format: 'date-time' }) statusChangedAt!: string;
  @ApiProperty({ type: RatingDto }) rating!: RatingDto;
  @ApiProperty({ type: String, nullable: true }) rejectionReason!: string | null;
  @ApiProperty({ type: String, nullable: true }) moderationResolution!: string | null;
  @ApiProperty({ type: String, isArray: true }) categories!: string[];
  @ApiProperty({ type: String, nullable: true }) transport!: string | null;
  @ApiProperty({ type: Number, nullable: true }) maxRadiusKm!: number | null;
  @ApiProperty({ example: '29.90', description: 'Saldo del ledger (positivo = debe)' })
  balanceBs!: string;
  @ApiProperty({ type: () => PeriodRowDto, isArray: true, description: 'Últimos 8' })
  periods!: PeriodRowDto[];
}

export class PeriodRowDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() status!: string;
  @ApiProperty() paymentReference!: string;
  @ApiProperty({ type: String, format: 'date-time' }) startAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) dueAt!: string;
  @ApiProperty({ example: '19.50' }) commissionBs!: string;
}

export class ReportRowDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() targetType!: string;
  @ApiProperty() reason!: string;
  @ApiProperty() status!: string;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class ReportCountsDto {
  @ApiProperty() pendiente!: number;
  @ApiProperty() valido!: number;
  @ApiProperty() descartado!: number;
}

export class JobRowDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: ['worker', 'employer'] }) as!: 'worker' | 'employer';
  @ApiProperty() status!: string;
  @ApiProperty() categoryName!: string;
  @ApiProperty({ example: '150.00' }) finalPriceBs!: string;
  @ApiProperty({ type: String, format: 'date-time' }) assignedAt!: string;
}

export class UserProfileDto extends UserRowDto {
  @ApiProperty({ type: RatingDto, description: 'Como empleador' }) employerRating!: RatingDto;
  @ApiProperty() cancellationsCount!: number;
  @ApiProperty({ type: String, nullable: true, format: 'date-time' })
  flaggedAt!: string | null;
  @ApiProperty({ type: WorkerSummaryDto, nullable: true }) worker!: WorkerSummaryDto | null;
  @ApiProperty({ type: ReportCountsDto, description: 'Reportes recibidos' })
  reportCounts!: ReportCountsDto;
  @ApiProperty({ type: ReportRowDto, isArray: true, description: 'Últimos 10 recibidos' })
  reports!: ReportRowDto[];
  @ApiProperty({ example: 14, description: 'Trabajos como trabajador o empleador' })
  jobsCount!: number;
  @ApiProperty({ type: JobRowDto, isArray: true, description: 'Últimos 10' }) jobs!: JobRowDto[];
}

export class ReasonDto {
  @ApiProperty({ example: 'Tres reportes de acoso verificados por el equipo.' })
  @IsString({ message: 'Escribe el motivo.' })
  @MinLength(5, { message: 'Escribe el motivo (al menos 5 letras).' })
  @MaxLength(500)
  @Transform(({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value))
  reason!: string;
}

export class WorkerStatusResultDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty() status!: string;
  @ApiProperty() modeForcedToEmployer!: boolean;
}

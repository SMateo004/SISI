import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsUUID } from 'class-validator';

export class DashboardQueryDto {
  @ApiPropertyOptional({ enum: ['day', 'week'], default: 'day' })
  @IsOptional()
  @IsIn(['day', 'week'])
  range?: 'day' | 'week';

  @ApiPropertyOptional({ format: 'uuid', description: 'Por defecto, la ciudad principal' })
  @IsOptional()
  @IsUUID()
  cityId?: string;
}

/** Colas pendientes (para el menú del panel y el dashboard). */
export class CountersDto {
  @ApiProperty({ description: 'Solicitudes de trabajador por revisar' }) verifications!: number;
  @ApiProperty({ description: 'Solicitudes retenidas por moderación' }) heldRequests!: number;
  @ApiProperty({ description: 'Mensajes de chat retenidos' }) heldMessages!: number;
  @ApiProperty({ description: 'Reportes pendientes' }) reports!: number;
  @ApiProperty({ description: 'Disputas abiertas' }) disputes!: number;
  @ApiProperty({ description: 'Comprobantes por revisar' }) submissions!: number;
}

export class CancellationCountDto {
  @ApiProperty({ example: 'cambio_de_planes' }) reason!: string;
  @ApiProperty() count!: number;
}

export class DashboardDto {
  @ApiProperty({ enum: ['day', 'week'] }) range!: 'day' | 'week';
  @ApiProperty({ format: 'uuid' }) cityId!: string;
  @ApiProperty() cityName!: string;
  @ApiProperty({ type: String, format: 'date-time' }) from!: string;
  @ApiProperty({ type: String, format: 'date-time' }) to!: string;
  @ApiProperty({ description: 'Publicadas en el rango (sin borradores)' }) requestsCreated!: number;
  @ApiProperty({ type: Number, nullable: true, example: 72.5 })
  assignmentRatePct!: number | null;
  @ApiProperty({ type: Number, nullable: true, example: 12.5 })
  expirationRatePct!: number | null;
  @ApiProperty({ type: Number, nullable: true, description: 'Desde la publicación, en segundos' })
  avgFirstOfferSec!: number | null;
  @ApiProperty() jobsCompleted!: number;
  @ApiProperty({ type: CancellationCountDto, isArray: true })
  cancellationsByReason!: CancellationCountDto[];
  @ApiProperty({ example: '195.00' }) commissionGeneratedBs!: string;
  @ApiProperty({ example: '120.00' }) commissionCollectedBs!: string;
  @ApiProperty({ example: '58.50', description: 'Saldo de los periodos vencidos (ahora)' })
  overdueDebtBs!: string;
  @ApiProperty() overdueWorkers!: number;
  @ApiProperty({ description: 'Disponibles con ubicación reciente' }) workersAvailableNow!: number;
  @ApiProperty({ type: CountersDto }) queues!: CountersDto;
}

export class PilotFunnelDto {
  @ApiProperty({ description: 'Solicitudes publicadas (sin borradores)' }) created!: number;
  @ApiProperty({ description: 'Con al menos una oferta' }) withOffer!: number;
  @ApiProperty({ description: 'Asignadas (trabajo creado)' }) assigned!: number;
  @ApiProperty({ description: 'Trabajo terminado' }) completed!: number;
  @ApiProperty({ description: 'Terminado y con la comisión ya cobrada (periodo pagado)' })
  commissionCollected!: number;
}

export class PilotWeekDto {
  @ApiProperty({ example: '2026-11-02', description: 'Lunes de la semana (hora local)' })
  weekStart!: string;
  @ApiProperty({ description: 'Trabajadores que ofertaron esa semana' }) activeWorkers!: number;
  @ApiProperty({ description: 'Empleadores que publicaron esa semana' }) activeEmployers!: number;
  @ApiProperty({
    type: Number,
    nullable: true,
    description: '% de los trabajadores activos la semana anterior que volvieron',
  })
  workerRetentionPct!: number | null;
  @ApiProperty({ type: Number, nullable: true }) employerRetentionPct!: number | null;
}

export class PilotMetricsDto {
  @ApiProperty({ format: 'uuid' }) cityId!: string;
  @ApiProperty() cityName!: string;
  @ApiProperty({
    type: String,
    nullable: true,
    example: '2026-11-02',
    description: 'Inicio del piloto (parámetro PILOT_STARTED_AT); sin él, las últimas 8 semanas',
  })
  startedAt!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) from!: string;
  @ApiProperty({ type: String, format: 'date-time' }) to!: string;
  @ApiProperty({ type: PilotFunnelDto }) funnel!: PilotFunnelDto;
  @ApiProperty({ type: Number, nullable: true }) avgFirstOfferSec!: number | null;
  @ApiProperty({ type: Number, nullable: true }) expirationRatePct!: number | null;
  @ApiProperty({
    type: Number,
    nullable: true,
    description: 'Comisión cobrada sobre generada, en el rango',
  })
  collectionRatePct!: number | null;
  @ApiProperty({
    type: PilotWeekDto,
    isArray: true,
    description: 'Hasta 8 semanas, la última es la actual',
  })
  weekly!: PilotWeekDto[];
}

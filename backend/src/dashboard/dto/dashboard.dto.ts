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

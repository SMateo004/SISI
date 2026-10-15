import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsLatitude, IsLongitude, IsOptional } from 'class-validator';

export class SetAvailabilityDto {
  @ApiProperty({ description: 'true = recibir solicitudes cercanas' })
  @IsBoolean({ message: 'Indica si estás disponible.' })
  available!: boolean;

  @ApiPropertyOptional({ example: -17.7834, description: 'Obligatoria para activar' })
  @IsOptional()
  @IsLatitude({ message: 'La latitud no es válida.' })
  latitude?: number;

  @ApiPropertyOptional({ example: -63.1821, description: 'Obligatoria para activar' })
  @IsOptional()
  @IsLongitude({ message: 'La longitud no es válida.' })
  longitude?: number;
}

export class LocationUpdateDto {
  @ApiProperty({ example: -17.7834 })
  @IsLatitude({ message: 'La latitud no es válida.' })
  latitude!: number;

  @ApiProperty({ example: -63.1821 })
  @IsLongitude({ message: 'La longitud no es válida.' })
  longitude!: number;
}

export class AvailabilityDto {
  @ApiProperty()
  available!: boolean;

  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  availableSince!: string | null;

  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Última ubicación recibida por la API',
  })
  locatedAt!: string | null;

  @ApiProperty({
    description:
      'Cada cuántos segundos debe la app enviar la ubicación mientras está disponible (en primer plano)',
  })
  sendEverySec!: number;

  @ApiProperty({ description: 'Sin ubicación en este tiempo, deja de estar disponible' })
  staleAfterSec!: number;
}

export class LocationUpdateResultDto {
  @ApiProperty({ description: 'false si se guardó solo la copia en vivo (throttling)' })
  persisted!: boolean;
}

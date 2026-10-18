import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsLatitude,
  IsLongitude,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  MinLength,
  ValidateIf,
} from 'class-validator';

export class CityAreaDto {
  @ApiProperty() cityId!: string;
  @ApiProperty({ type: Number, nullable: true }) centerLat!: number | null;
  @ApiProperty({ type: Number, nullable: true }) centerLng!: number | null;
  @ApiProperty({ type: Number, nullable: true, description: 'Radio si no hay polígono' })
  radiusKm!: number | null;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Polígono GeoJSON (texto); null = se usa el radio',
  })
  geojson!: string | null;
}

export class SetCityAreaDto {
  @ApiProperty({
    type: String,
    nullable: true,
    example:
      '{"type":"Polygon","coordinates":[[[-63.25,-17.72],[-63.1,-17.72],[-63.1,-17.85],[-63.25,-17.85],[-63.25,-17.72]]]}',
    description: 'GeoJSON Polygon ([longitud, latitud]); null para volver al radio',
  })
  @ValidateIf((_, v) => v !== null)
  @IsString({ message: 'Pega el GeoJSON como texto.' })
  @MaxLength(200_000)
  geojson!: string | null;

  @ApiPropertyOptional({ example: 15 })
  @IsOptional()
  @IsNumber({}, { message: 'El radio es un número.' })
  @Min(1)
  @Max(50)
  radiusKm?: number;

  @ApiProperty({ example: 'Zona del piloto acordada con operaciones' })
  @IsString({ message: 'Escribe el motivo.' })
  @MinLength(5, { message: 'Escribe el motivo (al menos 5 letras).' })
  @MaxLength(300)
  reason!: string;
}

export class TestPointDto {
  @ApiProperty({ example: -17.7834 }) @IsLatitude() lat!: number;
  @ApiProperty({ example: -63.1821 }) @IsLongitude() lng!: number;
}

export class TestPointResultDto {
  @ApiProperty() inside!: boolean;
  @ApiProperty({ enum: ['polygon', 'radius', 'none'] }) by!: 'polygon' | 'radius' | 'none';
}

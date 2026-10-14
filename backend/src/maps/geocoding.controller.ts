import { Controller, Get, Inject, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsLatitude, IsLongitude } from 'class-validator';
import type { Redis } from 'ioredis';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { assertValidCoordinates } from '../requests/location';
import { GEOCODING_SERVICE, type GeocodingService } from './geocoding.service';

export class ReverseGeocodeQuery {
  @ApiProperty({ example: -17.7834 })
  @Type(() => Number)
  @IsLatitude({ message: 'La ubicación no es válida.' })
  lat!: number;

  @ApiProperty({ example: -63.1821 })
  @Type(() => Number)
  @IsLongitude({ message: 'La ubicación no es válida.' })
  lng!: number;
}

export class ReverseGeocodeDto {
  @ApiPropertyOptional({
    nullable: true,
    type: String,
    example: 'Calle Junín 150, Santa Cruz de la Sierra, Bolivia',
    description: 'Sugerencia editable; null si no hay resultado',
  })
  address!: string | null;
}

/** Resultados en caché ~11 m (4 decimales), 7 días (dentro del límite de caché de Google). */
const CACHE_TTL_SEC = 7 * 24 * 3600;

@ApiTags('maps')
@ApiBearerAuth()
@Controller('geocoding')
export class GeocodingController {
  constructor(
    @Inject(GEOCODING_SERVICE) private readonly geocoding: GeocodingService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  @Get('reverse')
  @RateLimit('geocodeIp')
  @ApiOperation({
    summary: 'Dirección sugerida para unas coordenadas',
    description: 'La geocodificación se hace en el backend: la llave de Maps nunca llega a la app.',
  })
  @ApiOkResponse({ type: ReverseGeocodeDto })
  async reverse(@Query() query: ReverseGeocodeQuery): Promise<ReverseGeocodeDto> {
    const point = { lat: query.lat, lng: query.lng };
    assertValidCoordinates(point);
    const key = `geo:rev:${this.geocoding.name}:${point.lat.toFixed(4)},${point.lng.toFixed(4)}`;
    const cached = await this.redis.get(key);
    if (cached !== null) return { address: cached === '' ? null : cached };
    const address = await this.geocoding.reverse(point);
    await this.redis.set(key, address ?? '', 'EX', CACHE_TTL_SEC);
    return { address };
  }
}

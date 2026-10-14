import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { GeocodingController } from './geocoding.controller';
import { createGeocodingService, GEOCODING_SERVICE } from './geocoding.service';

@Module({
  controllers: [GeocodingController],
  providers: [
    {
      // Valida al arrancar: production exige Google con llave (ADR-0021).
      provide: GEOCODING_SERVICE,
      inject: [ConfigService],
      useFactory: (config: AppConfigService) =>
        createGeocodingService({
          APP_ENV: config.get('APP_ENV', { infer: true }),
          GEOCODING_PROVIDER: config.get('GEOCODING_PROVIDER', { infer: true }),
          MAPS_API_KEY: config.get('MAPS_API_KEY', { infer: true }),
        }),
    },
  ],
  exports: [GEOCODING_SERVICE],
})
export class MapsModule {}

import type { Provider } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { AppSettingsService } from '../settings/app-settings.service';
import { type MatchingConfig, parseRings } from './matching.config';

export const MATCHING_CONFIG = Symbol('MATCHING_CONFIG');

/**
 * Configuración del matching (ADR-0025). Los parámetros de negocio se leen en cada uso desde
 * AppSettingsService (panel o entorno, ADR-0043): un cambio se aplica a la próxima decisión
 * del matching sin redeploy. Los técnicos (ubicación vieja, reescaneo) siguen en el entorno.
 */
export const matchingConfigProvider: Provider = {
  provide: MATCHING_CONFIG,
  inject: [ConfigService, AppSettingsService],
  useFactory: (config: AppConfigService, settings: AppSettingsService): MatchingConfig => ({
    get rings() {
      return parseRings(settings.value('MATCHING_RINGS'));
    },
    get ringWaitMs() {
      return settings.value('MATCHING_RING_WAIT_MS');
    },
    get enoughOffers() {
      return settings.value('MATCHING_ENOUGH_OFFERS');
    },
    get offersGraceMs() {
      return settings.value('MATCHING_OFFERS_GRACE_MS');
    },
    staleLocationMs: config.get('WORKER_LOCATION_STALE_MS', { infer: true }),
    get minSearchMs() {
      return settings.value('MATCHING_MIN_SEARCH_MS');
    },
    rescanMs: config.get('MATCHING_RESCAN_MS', { infer: true }),
  }),
};

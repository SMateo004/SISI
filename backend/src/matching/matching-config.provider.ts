import type { Provider } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { type MatchingConfig, parseRings } from './matching.config';

export const MATCHING_CONFIG = Symbol('MATCHING_CONFIG');

/** Configuración del matching leída del entorno (ADR-0025). */
export const matchingConfigProvider: Provider = {
  provide: MATCHING_CONFIG,
  inject: [ConfigService],
  useFactory: (config: AppConfigService): MatchingConfig => ({
    rings: parseRings(config.get('MATCHING_RINGS', { infer: true })),
    ringWaitMs: config.get('MATCHING_RING_WAIT_MS', { infer: true }),
    enoughOffers: config.get('MATCHING_ENOUGH_OFFERS', { infer: true }),
    offersGraceMs: config.get('MATCHING_OFFERS_GRACE_MS', { infer: true }),
    staleLocationMs: config.get('WORKER_LOCATION_STALE_MS', { infer: true }),
    minSearchMs: config.get('MATCHING_MIN_SEARCH_MS', { infer: true }),
    rescanMs: config.get('MATCHING_RESCAN_MS', { infer: true }),
  }),
};

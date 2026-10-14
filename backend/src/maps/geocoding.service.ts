import { Logger } from '@nestjs/common';
import type { Env } from '../config/env.schema';
import type { LatLng } from '../requests/location';

/** Geocodificación inversa: coordenadas → dirección sugerida (editable por el usuario). */
export interface GeocodingService {
  readonly name: 'fake' | 'google';
  /** Dirección sugerida o null si no hay resultado (la app deja escribirla a mano). */
  reverse(point: LatLng): Promise<string | null>;
}

export const GEOCODING_SERVICE = Symbol('GEOCODING_SERVICE');

/** Para local, test y staging sin llave: dirección de prueba determinística. */
export class FakeGeocodingService implements GeocodingService {
  readonly name = 'fake' as const;

  reverse(point: LatLng): Promise<string | null> {
    return Promise.resolve(
      `Dirección de prueba (${point.lat.toFixed(5)}, ${point.lng.toFixed(5)}), Santa Cruz de la Sierra`,
    );
  }
}

interface GoogleGeocodeResponse {
  status: string;
  results?: { formatted_address?: string }[];
  error_message?: string;
}

/**
 * Google Geocoding API con fetch nativo (sin SDK). La llave es de servidor y solo vive
 * en el backend (ADR-0021).
 */
export class GoogleGeocodingService implements GeocodingService {
  readonly name = 'google' as const;
  private readonly logger = new Logger('GoogleGeocoding');

  constructor(
    private readonly apiKey: string,
    private readonly fetchFn: typeof fetch = fetch,
  ) {}

  async reverse(point: LatLng): Promise<string | null> {
    const url = new URL('https://maps.googleapis.com/maps/api/geocode/json');
    url.searchParams.set('latlng', `${point.lat},${point.lng}`);
    url.searchParams.set('language', 'es');
    url.searchParams.set('region', 'bo');
    url.searchParams.set('key', this.apiKey);
    try {
      const res = await this.fetchFn(url, { signal: AbortSignal.timeout(5000) });
      const body = (await res.json()) as GoogleGeocodeResponse;
      if (body.status === 'OK') return body.results?.[0]?.formatted_address ?? null;
      if (body.status !== 'ZERO_RESULTS') {
        this.logger.warn(`Geocoding respondió ${body.status}: ${body.error_message ?? ''}`);
      }
      return null;
    } catch (error) {
      this.logger.warn(`Geocoding no respondió: ${String(error)}`);
      return null;
    }
  }
}

/**
 * Elige la implementación y valida al arrancar: production exige Google con llave.
 */
export function createGeocodingService(
  env: Pick<Env, 'APP_ENV' | 'GEOCODING_PROVIDER' | 'MAPS_API_KEY'>,
): GeocodingService {
  if (env.GEOCODING_PROVIDER === 'fake') {
    if (env.APP_ENV === 'production') {
      throw new Error('GEOCODING_PROVIDER=fake no está permitido con APP_ENV=production.');
    }
    return new FakeGeocodingService();
  }
  if (!env.MAPS_API_KEY) throw new Error('GEOCODING_PROVIDER=google requiere MAPS_API_KEY.');
  return new GoogleGeocodingService(env.MAPS_API_KEY);
}

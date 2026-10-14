import {
  createGeocodingService,
  FakeGeocodingService,
  GoogleGeocodingService,
} from './geocoding.service';

const point = { lat: -17.7834, lng: -63.1821 };

describe('GoogleGeocodingService', () => {
  it('llama a la Geocoding API en español con la llave del servidor', async () => {
    const fetchFn = jest.fn().mockResolvedValue(
      new Response(
        JSON.stringify({
          status: 'OK',
          results: [{ formatted_address: 'Calle Junín 150, Santa Cruz de la Sierra, Bolivia' }],
        }),
      ),
    );
    const google = new GoogleGeocodingService('llave-servidor', fetchFn);
    await expect(google.reverse(point)).resolves.toBe(
      'Calle Junín 150, Santa Cruz de la Sierra, Bolivia',
    );
    const calls = fetchFn.mock.calls as [URL][];
    const url = calls[0]?.[0] ?? new URL('about:blank');
    expect(url.origin + url.pathname).toBe('https://maps.googleapis.com/maps/api/geocode/json');
    expect(url.searchParams.get('latlng')).toBe('-17.7834,-63.1821');
    expect(url.searchParams.get('language')).toBe('es');
    expect(url.searchParams.get('key')).toBe('llave-servidor');
  });

  it('sin resultados, con error o sin red devuelve null (la app deja escribir la dirección)', async () => {
    for (const fetchFn of [
      () => Promise.resolve(new Response(JSON.stringify({ status: 'ZERO_RESULTS' }))),
      () =>
        Promise.resolve(
          new Response(JSON.stringify({ status: 'REQUEST_DENIED', error_message: 'x' })),
        ),
      () => Promise.reject(new Error('sin red')),
    ]) {
      const google = new GoogleGeocodingService('k', fetchFn);
      await expect(google.reverse(point)).resolves.toBeNull();
    }
  });
});

describe('createGeocodingService', () => {
  it('usa la falsa en local, test y staging', () => {
    for (const APP_ENV of ['local', 'test', 'staging'] as const) {
      expect(
        createGeocodingService({ APP_ENV, GEOCODING_PROVIDER: 'fake', MAPS_API_KEY: undefined }),
      ).toBeInstanceOf(FakeGeocodingService);
    }
  });

  it('production exige Google con llave', () => {
    expect(() =>
      createGeocodingService({
        APP_ENV: 'production',
        GEOCODING_PROVIDER: 'fake',
        MAPS_API_KEY: undefined,
      }),
    ).toThrow(/no está permitido/);
    expect(() =>
      createGeocodingService({
        APP_ENV: 'production',
        GEOCODING_PROVIDER: 'google',
        MAPS_API_KEY: undefined,
      }),
    ).toThrow(/MAPS_API_KEY/);
    expect(
      createGeocodingService({
        APP_ENV: 'production',
        GEOCODING_PROVIDER: 'google',
        MAPS_API_KEY: 'k',
      }),
    ).toBeInstanceOf(GoogleGeocodingService);
  });

  it('la falsa es determinística', async () => {
    await expect(new FakeGeocodingService().reverse(point)).resolves.toBe(
      'Dirección de prueba (-17.78340, -63.18210), Santa Cruz de la Sierra',
    );
  });
});

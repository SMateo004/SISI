import { validateEnv } from './env.schema';

const base = {
  DATABASE_URL: 'postgresql://sisi:sisi@localhost:5432/sisi',
  REDIS_URL: 'redis://localhost:6379',
  JWT_SECRET: 'x'.repeat(32),
  JWT_REFRESH_SECRET: 'y'.repeat(32),
};

describe('validateEnv', () => {
  it('aplica valores por defecto', () => {
    const env = validateEnv(base);
    expect(env.PORT).toBe(3000);
    expect(env.TZ_DEFAULT).toBe('America/La_Paz');
    expect(env.CORS_ORIGINS).toEqual([]);
    expect(env.OTP_PROVIDER_KEY).toBeUndefined();
  });

  it('separa CORS_ORIGINS y trata vacíos como no configurados', () => {
    const env = validateEnv({
      ...base,
      CORS_ORIGINS: 'https://app.ejemplo.bo, https://admin.ejemplo.bo,',
      MAPS_API_KEY: '',
    });
    expect(env.CORS_ORIGINS).toEqual(['https://app.ejemplo.bo', 'https://admin.ejemplo.bo']);
    expect(env.MAPS_API_KEY).toBeUndefined();
  });

  it('falla si falta una variable obligatoria', () => {
    expect(() => validateEnv({ ...base, DATABASE_URL: undefined })).toThrow(/DATABASE_URL/);
  });

  it('rechaza secretos JWT cortos y zonas horarias inválidas', () => {
    expect(() => validateEnv({ ...base, JWT_SECRET: 'corto' })).toThrow(/JWT_SECRET/);
    expect(() => validateEnv({ ...base, TZ_DEFAULT: 'Marte/Olympus' })).toThrow(/TZ_DEFAULT/);
  });

  it('aplica los valores propuestos de la Fase 1', () => {
    const env = validateEnv(base);
    expect(env.APP_ENV).toBe('local');
    expect(env.OTP_PROVIDER).toBe('console');
    expect(env.JWT_ACCESS_TTL_SEC).toBe(900);
    expect(env.JWT_REFRESH_TTL_SEC).toBe(2_592_000);
    expect(env.PHONE_ALLOWED_COUNTRY_CODES).toEqual(['591']);
    expect(env.UPLOAD_MAX_BYTES).toBe(8 * 1024 * 1024);
    expect(env.STORAGE_FORCE_PATH_STYLE).toBe(false);
  });

  it('infiere APP_ENV=test con NODE_ENV=test y lee booleanos', () => {
    const env = validateEnv({ ...base, NODE_ENV: 'test', STORAGE_FORCE_PATH_STYLE: 'true' });
    expect(env.APP_ENV).toBe('test');
    expect(env.STORAGE_FORCE_PATH_STYLE).toBe(true);
  });

  it('exige APP_ENV explícito en un build de producción', () => {
    expect(() => validateEnv({ ...base, NODE_ENV: 'production' })).toThrow(/APP_ENV/);
    const env = validateEnv({ ...base, NODE_ENV: 'production', APP_ENV: 'staging' });
    expect(env.APP_ENV).toBe('staging');
  });

  describe('APP_ENV=production (ADR-0047)', () => {
    const prod = {
      ...base,
      NODE_ENV: 'production',
      APP_ENV: 'production',
      SENTRY_DSN: 'https://abc@o1.ingest.sentry.io/1',
      AVATAR_URL_TTL_SEC: '900',
      REQUEST_PHOTO_URL_TTL_SEC: '900',
    };

    it('arranca con Sentry y URLs firmadas cortas', () => {
      expect(validateEnv(prod).APP_ENV).toBe('production');
    });

    it('exige SENTRY_DSN', () => {
      expect(() => validateEnv({ ...prod, SENTRY_DSN: '' })).toThrow(/SENTRY_DSN/);
    });

    it('rechaza URLs firmadas de más de 15 minutos', () => {
      expect(() => validateEnv({ ...prod, AVATAR_URL_TTL_SEC: '3600' })).toThrow(
        /AVATAR_URL_TTL_SEC/,
      );
      expect(() => validateEnv({ ...prod, DOCUMENT_URL_TTL_SEC: '901' })).toThrow(
        /DOCUMENT_URL_TTL_SEC/,
      );
    });

    it('staging no exige lo de producción', () => {
      expect(() =>
        validateEnv({ ...base, NODE_ENV: 'production', APP_ENV: 'staging' }),
      ).not.toThrow();
    });
  });
});

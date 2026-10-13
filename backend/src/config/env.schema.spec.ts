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
});

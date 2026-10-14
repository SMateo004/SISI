/**
 * Entorno de los tests e2e: base `sisi_test`, Redis db 1 y bucket `sisi-test` de
 * infra/docker-compose.yml. En CI se usan las variables E2E_* (services del workflow).
 * Estas variables tienen prioridad sobre backend/.env.
 */
export function applyE2eEnv(): void {
  process.env.NODE_ENV = 'test';
  process.env.APP_ENV = 'test';
  process.env.DATABASE_URL =
    process.env.E2E_DATABASE_URL ?? 'postgresql://sisi:sisi@localhost:55432/sisi_test';
  process.env.REDIS_URL = process.env.E2E_REDIS_URL ?? 'redis://localhost:56379/1';
  process.env.JWT_SECRET ??= 'e2e-solo-pruebas-secreto-jwt-000000';
  process.env.JWT_REFRESH_SECRET ??= 'e2e-solo-pruebas-secreto-refresh-00';
  process.env.CORS_ORIGINS ??= 'http://localhost:8080';
  process.env.OTP_PROVIDER = 'console';

  process.env.STORAGE_ENDPOINT = process.env.E2E_STORAGE_ENDPOINT ?? 'http://localhost:59000';
  process.env.STORAGE_REGION = 'us-east-1';
  process.env.STORAGE_FORCE_PATH_STYLE = 'true';
  process.env.STORAGE_BUCKET = process.env.E2E_STORAGE_BUCKET ?? 'sisi-test';
  process.env.STORAGE_ACCESS_KEY = process.env.E2E_STORAGE_ACCESS_KEY ?? 'sisi-local';
  process.env.STORAGE_SECRET_KEY = process.env.E2E_STORAGE_SECRET_KEY ?? 'sisi-local-secret';
}

applyE2eEnv();

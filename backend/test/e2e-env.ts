/**
 * Entorno de los tests e2e: base `sisi_test` y Redis db 1 de infra/docker-compose.yml.
 * En CI se usan E2E_DATABASE_URL y E2E_REDIS_URL (services del workflow).
 */
export function applyE2eEnv(): void {
  process.env.NODE_ENV = 'test';
  process.env.DATABASE_URL =
    process.env.E2E_DATABASE_URL ?? 'postgresql://sisi:sisi@localhost:55432/sisi_test';
  process.env.REDIS_URL = process.env.E2E_REDIS_URL ?? 'redis://localhost:56379/1';
  process.env.JWT_SECRET ??= 'e2e-solo-pruebas-secreto-jwt-000000';
  process.env.JWT_REFRESH_SECRET ??= 'e2e-solo-pruebas-secreto-refresh-00';
  process.env.CORS_ORIGINS ??= 'http://localhost:8080';
}

applyE2eEnv();

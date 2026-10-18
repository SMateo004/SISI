/**
 * Entorno de los tests e2e: base `sisi_test`, Redis db 1 y bucket `sisi-test` de
 * infra/docker-compose.yml. En CI se usan las variables E2E_* (services del workflow).
 * Estas variables tienen prioridad sobre backend/.env.
 */
/** Clave TOTP del panel solo para los e2e (no es un secreto: nunca sirve fuera de los tests). */
export const E2E_ADMIN_TOTP_SECRET = 'KRSXG5CTKNEVGSKFGJSUMVSGKRSXG5CT';

export function applyE2eEnv(): void {
  process.env.NODE_ENV = 'test';
  process.env.APP_ENV = 'test';
  process.env.DATABASE_URL =
    process.env.E2E_DATABASE_URL ?? 'postgresql://sisi:sisi@localhost:15432/sisi_test';
  process.env.REDIS_URL = process.env.E2E_REDIS_URL ?? 'redis://localhost:16379/1';
  process.env.JWT_SECRET ??= 'e2e-solo-pruebas-secreto-jwt-000000';
  process.env.JWT_REFRESH_SECRET ??= 'e2e-solo-pruebas-secreto-refresh-00';
  process.env.CORS_ORIGINS ??= 'http://localhost:8080';
  process.env.OTP_PROVIDER = 'console';
  process.env.GEOCODING_PROVIDER = 'fake';
  // Colas propias de los e2e y tiempos en milisegundos (ADR-0028).
  process.env.QUEUE_PREFIX = 'bull-e2e';
  process.env.OUTBOX_POLL_MS = '50';
  process.env.ADMIN_COUNTERS_EMIT_MS = '300';
  // Fijo: el .env local puede tener /auth/admin (panel sin proxy en desarrollo).
  process.env.ADMIN_COOKIE_PATH = '/api/auth/admin';
  // Panel (ADR-0055): usuario y clave fijos de los e2e; pisan los del .env local.
  process.env.ADMIN_USERNAME = 'admin';
  process.env.ADMIN_TOTP_SECRET = E2E_ADMIN_TOTP_SECRET;
  process.env.RATE_ADMIN_LOGIN_PER_15MIN = '20';
  // El reconciliador se dispara a mano en los tests (runOnce).
  process.env.MATCHING_RECONCILE_MS = '3600000';
  process.env.LOCATION_SWEEP_MS = '3600000';
  process.env.OUTBOX_CLEANUP_MS = '3600000';
  process.env.JOB_AUTOCONFIRM_MS = '3000';
  process.env.JOB_LOCATION_EMIT_MS = '1000';
  process.env.JOB_CHAT_OPEN_AFTER_MS = '2000';
  process.env.JOB_CONTACT_VISIBLE_AFTER_MS = '2000';
  process.env.REVIEW_WINDOW_MS = '3000';
  // Con la máquina cargada, 50 ms puede no alcanzar y retener un texto limpio. El corte por
  // tiempo se prueba en regex-safety; aquí solo importa el resultado de la moderación.
  process.env.MODERATION_REGEX_TIMEOUT_MS = '2000';
  // Anillos y plazos en milisegundos (nunca los 45 s reales). 3 s deja margen para actuar
  // dentro de un anillo (ofertar, cancelar) aunque la máquina esté cargada.
  process.env.MATCHING_RING_WAIT_MS = '3000';
  process.env.MATCHING_OFFERS_GRACE_MS = '3000';
  // Tiempo mínimo de búsqueda corto: sin candidatos, reintenta cada 1 s durante 4 s.
  process.env.MATCHING_MIN_SEARCH_MS = '4000';
  process.env.MATCHING_RESCAN_MS = '1000';

  process.env.STORAGE_ENDPOINT = process.env.E2E_STORAGE_ENDPOINT ?? 'http://localhost:19000';
  process.env.STORAGE_REGION = 'us-east-1';
  process.env.STORAGE_FORCE_PATH_STYLE = 'true';
  process.env.STORAGE_BUCKET = process.env.E2E_STORAGE_BUCKET ?? 'sisi-test';
  process.env.STORAGE_ACCESS_KEY = process.env.E2E_STORAGE_ACCESS_KEY ?? 'sisi-local';
  process.env.STORAGE_SECRET_KEY = process.env.E2E_STORAGE_SECRET_KEY ?? 'sisi-local-secret';
}

applyE2eEnv();

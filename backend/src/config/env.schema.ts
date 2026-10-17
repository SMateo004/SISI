import { z } from 'zod';
import { parseRings } from '../matching/matching.config';

/** Una cadena vacía en .env significa "no configurada". */
const emptyAsUndefined = (v: unknown): unknown => (v === '' ? undefined : v);
const optionalString = z.preprocess(emptyAsUndefined, z.string().optional());
const positiveInt = (fallback: number) => z.coerce.number().int().positive().default(fallback);

const isValidTimeZone = (tz: string): boolean => {
  try {
    new Intl.DateTimeFormat('es-BO', { timeZone: tz });
    return true;
  } catch {
    return false;
  }
};

const commaList = z
  .string()
  .default('')
  .transform((value) =>
    value
      .split(',')
      .map((item) => item.trim())
      .filter((item) => item.length > 0),
  );

/**
 * Variables de entorno del backend (doc 02 §11, ADR-0002).
 * Las de servicios externos son opcionales aquí; cada módulo que las usa
 * (auth/OTP, storage) valida al arrancar lo que necesita, para que worker y
 * billing-cron no las exijan.
 */
export const envSchema = z
  .object({
    NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
    /** Ambiente lógico. Staging corre con NODE_ENV=production pero APP_ENV=staging (ADR-0011). */
    APP_ENV: z.preprocess(
      emptyAsUndefined,
      z.enum(['local', 'test', 'staging', 'production']).optional(),
    ),
    PORT: z.coerce.number().int().positive().default(3000),

    DATABASE_URL: z.url({ protocol: /^postgres(ql)?$/ }),
    REDIS_URL: z.url({ protocol: /^rediss?$/ }),

    JWT_SECRET: z.string().min(32),
    JWT_REFRESH_SECRET: z.string().min(32),
    /** Propuesta: 15 minutos (docs/pendientes.md). */
    JWT_ACCESS_TTL_SEC: positiveInt(900),
    /** Propuesta: 30 días (docs/pendientes.md). */
    JWT_REFRESH_TTL_SEC: positiveInt(2_592_000),

    // OTP (ADR-0009, ADR-0011)
    OTP_PROVIDER: z.enum(['console', 'bird']).default('console'),
    /** Clave de API de Bird (bk_{región}_...). */
    OTP_PROVIDER_KEY: optionalString,
    /** Remitente del SMS en Bird: número propio o sender ID alfanumérico. */
    OTP_SENDER: optionalString,
    OTP_TTL_SEC: positiveInt(300),
    OTP_MAX_ATTEMPTS: positiveInt(5),
    /** Prefijos de país permitidos, sin "+". MVP: solo Bolivia (docs/pendientes.md). */
    PHONE_ALLOWED_COUNTRY_CODES: commaList.default(['591']),

    // Rate limits (propuesta, docs/pendientes.md)
    /** Límite general por IP para toda la API (excepto /health). */
    RATE_GLOBAL_IP_PER_MIN: positiveInt(300),
    RATE_OTP_PHONE_COOLDOWN_SEC: positiveInt(60),
    RATE_OTP_PHONE_PER_HOUR: positiveInt(5),
    RATE_OTP_PHONE_PER_DAY: positiveInt(10),
    RATE_OTP_IP_PER_HOUR: positiveInt(20),
    RATE_OTP_VERIFY_IP_PER_15MIN: positiveInt(30),
    RATE_AUTH_IP_PER_MIN: positiveInt(30),

    // Almacenamiento S3 (ADR-0012)
    STORAGE_ENDPOINT: z.preprocess(emptyAsUndefined, z.url().optional()),
    STORAGE_REGION: z.string().default('auto'),
    STORAGE_FORCE_PATH_STYLE: z
      .preprocess(emptyAsUndefined, z.stringbool().optional())
      .transform((v) => v ?? false),
    STORAGE_BUCKET: optionalString,
    STORAGE_ACCESS_KEY: optionalString,
    STORAGE_SECRET_KEY: optionalString,
    /** Propuesta: 8 MB (docs/pendientes.md). */
    UPLOAD_MAX_BYTES: positiveInt(8 * 1024 * 1024),
    UPLOAD_URL_TTL_SEC: positiveInt(300),
    DOCUMENT_URL_TTL_SEC: positiveInt(300),
    AVATAR_URL_TTL_SEC: positiveInt(3600),

    DEFAULT_CITY_SLUG: z.string().default('santa-cruz'),

    // Solicitudes (R3, ADR-0019). Propuestas en docs/pendientes.md.
    REQUEST_DESCRIPTION_MIN: positiveInt(20),
    REQUEST_DESCRIPTION_MAX: positiveInt(1000),
    REQUEST_MAX_PHOTOS: positiveInt(4),
    REQUEST_PHOTO_URL_TTL_SEC: positiveInt(3600),
    RATE_REQUEST_PUBLISH_PER_HOUR: positiveInt(10),
    RATE_REQUEST_PUBLISH_PER_DAY: positiveInt(30),
    RATE_REQUEST_CREATE_IP_PER_HOUR: positiveInt(30),

    // Outbox y colas (ADR-0022). Los e2e usan tiempos en milisegundos.
    OUTBOX_POLL_MS: positiveInt(500),
    OUTBOX_BATCH_SIZE: positiveInt(100),
    QUEUE_PREFIX: z
      .string()
      .regex(/^[a-z0-9-]+$/)
      .default('bull'),
    /** Cuánto se guarda un job completado: mientras exista, su jobId no se repite. */
    QUEUE_KEEP_COMPLETED_SEC: positiveInt(86_400),
    MATCHING_RECONCILE_MS: positiveInt(60_000),
    /** Eventos publicados del outbox que se conservan (luego se borran). */
    OUTBOX_RETENTION_DAYS: positiveInt(7),
    /** Plazo para que el empleador confirme después del "Terminé" (ADR-0029). */
    JOB_AUTOCONFIRM_MS: positiveInt(86_400_000),
    /** job:location al empleador como máximo cada N ms (ADR-0029). */
    JOB_LOCATION_EMIT_MS: positiveInt(5000),
    /** El chat sigue abierto N ms después de terminado o cancelado; luego, solo lectura. */
    JOB_CHAT_OPEN_AFTER_MS: positiveInt(86_400_000),
    /** El contacto se oculta N ms después de terminado o cancelado. */
    JOB_CONTACT_VISIBLE_AFTER_MS: positiveInt(86_400_000),
    /** Plazo para calificar desde que terminó el trabajo (7 días; ADR-0032). */
    REVIEW_WINDOW_MS: positiveInt(604_800_000),
    /** Presencia de un socket en Redis (se renueva con un latido; ADR-0031). */
    PRESENCE_TTL_MS: positiveInt(60_000),
    OUTBOX_CLEANUP_MS: positiveInt(86_400_000),

    // Matching por anillos (R4, ADR-0025). Valores en propuesta: docs/pendientes.md.
    /** km:límite por anillo, separados por coma. */
    MATCHING_RINGS: z
      .string()
      .default('2:5,5:10,10:10')
      .refine((v) => {
        try {
          parseRings(v);
          return true;
        } catch {
          return false;
        }
      }, 'Formato km:límite separado por comas, con radios crecientes (p. ej. 2:5,5:10,10:10)'),
    MATCHING_RING_WAIT_MS: positiveInt(45_000),
    MATCHING_ENOUGH_OFFERS: positiveInt(3),
    MATCHING_OFFERS_GRACE_MS: positiveInt(600_000),
    /** Tiempo mínimo de búsqueda aunque no haya candidatos (propuesta: 3 min). */
    MATCHING_MIN_SEARCH_MS: z.coerce.number().int().min(0).default(180_000),
    MATCHING_RESCAN_MS: positiveInt(45_000),

    // Ofertas (R5, ADR-0026). Propuestas en docs/pendientes.md.
    /** Velocidad media por medio de transporte, para el tiempo estimado de llegada. */
    ETA_SPEEDS_KMH: z
      .string()
      .default('a_pie:4.5,bicicleta:12,moto:25,auto:20,transporte_publico:15'),
    /** Recorrido real ≈ línea recta × este factor. */
    ETA_ROUTE_FACTOR: z.coerce.number().min(1).max(3).default(1.3),
    /** Tope de la contraoferta: este factor × el máximo de referencia de la categoría. */
    OFFER_COUNTER_MAX_FACTOR: z.coerce.number().positive().default(3),
    RATE_OFFER_PER_MIN: positiveInt(10),
    RATE_OFFER_IP_PER_MIN: positiveInt(60),
    /** Mensajes de chat por usuario (ADR-0031). */
    RATE_CHAT_PER_MIN: positiveInt(30),

    // Ubicación y disponibilidad del trabajador (ADR-0024). Propuestas en docs/pendientes.md.
    WORKER_LOCATION_PERSIST_MS: positiveInt(30_000),
    WORKER_LOCATION_PERSIST_M: positiveInt(100),
    WORKER_LOCATION_STALE_MS: positiveInt(600_000),
    LOCATION_SWEEP_MS: positiveInt(60_000),
    RATE_WORKER_LOCATION_PER_MIN: positiveInt(30),

    // Push (ADR-0027). production exige fcm. La credencial va en JSON o base64.
    PUSH_PROVIDER: z.enum(['fake', 'fcm']).default('fake'),
    FIREBASE_SERVICE_ACCOUNT: optionalString,

    // Mapas (ADR-0021). La llave del backend nunca se envía a la app.
    GEOCODING_PROVIDER: z.enum(['fake', 'google']).default('fake'),
    MAPS_API_KEY: optionalString,
    RATE_GEOCODE_IP_PER_MIN: positiveInt(60),
    SENTRY_DSN: z.preprocess(emptyAsUndefined, z.url().optional()),

    CORS_ORIGINS: commaList,
    TZ_DEFAULT: z
      .string()
      .default('America/La_Paz')
      .refine(isValidTimeZone, 'Zona horaria IANA inválida'),
  })
  .superRefine((env, ctx) => {
    // En un build de producción el ambiente lógico debe ser explícito: si faltara,
    // caeríamos en "local" y se podría activar el OTP por consola.
    if (env.NODE_ENV === 'production' && env.APP_ENV === undefined) {
      ctx.addIssue({
        code: 'custom',
        path: ['APP_ENV'],
        message: 'Obligatorio cuando NODE_ENV=production (staging o production)',
      });
    }
  })
  .transform((env) => ({
    ...env,
    APP_ENV: env.APP_ENV ?? (env.NODE_ENV === 'test' ? ('test' as const) : ('local' as const)),
  }));

export type Env = z.infer<typeof envSchema>;
export type AppEnv = Env['APP_ENV'];

export function validateEnv(config: Record<string, unknown>): Env {
  const result = envSchema.safeParse(config);
  if (!result.success) {
    throw new Error(`Variables de entorno inválidas:\n${z.prettifyError(result.error)}`);
  }
  return result.data;
}

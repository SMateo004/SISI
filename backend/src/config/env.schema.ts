import { z } from 'zod';

/** Una cadena vacía en .env significa "no configurada". */
const optionalString = z.preprocess((v) => (v === '' ? undefined : v), z.string().optional());

const isValidTimeZone = (tz: string): boolean => {
  try {
    new Intl.DateTimeFormat('es-BO', { timeZone: tz });
    return true;
  } catch {
    return false;
  }
};

/**
 * Variables de entorno del backend (doc 02 §11, ADR-0002).
 * Las de servicios externos son opcionales hasta la fase que las usa.
 */
export const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(3000),

  DATABASE_URL: z.url({ protocol: /^postgres(ql)?$/ }),
  REDIS_URL: z.url({ protocol: /^rediss?$/ }),

  JWT_SECRET: z.string().min(32),
  JWT_REFRESH_SECRET: z.string().min(32),

  OTP_PROVIDER_KEY: optionalString,
  FIREBASE_SERVICE_ACCOUNT: optionalString,
  STORAGE_BUCKET: optionalString,
  STORAGE_ACCESS_KEY: optionalString,
  STORAGE_SECRET_KEY: optionalString,
  MAPS_API_KEY: optionalString,
  SENTRY_DSN: z.preprocess((v) => (v === '' ? undefined : v), z.url().optional()),

  CORS_ORIGINS: z
    .string()
    .default('')
    .transform((value) =>
      value
        .split(',')
        .map((origin) => origin.trim())
        .filter((origin) => origin.length > 0),
    ),
  TZ_DEFAULT: z
    .string()
    .default('America/La_Paz')
    .refine(isValidTimeZone, 'Zona horaria IANA inválida'),
});

export type Env = z.infer<typeof envSchema>;

export function validateEnv(config: Record<string, unknown>): Env {
  const result = envSchema.safeParse(config);
  if (!result.success) {
    throw new Error(`Variables de entorno inválidas:\n${z.prettifyError(result.error)}`);
  }
  return result.data;
}

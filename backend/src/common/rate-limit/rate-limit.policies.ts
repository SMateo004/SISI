import type { Env } from '../../config/env.schema';

type NumericEnvKey = {
  [K in keyof Env]: Env[K] extends number ? K : never;
}[keyof Env];

export interface RateLimitPolicyDef {
  /** Variable de configuración con el límite (ver env.schema.ts). */
  limitFrom: NumericEnvKey;
  windowSec: number;
}

/**
 * Políticas de límite por IP aplicables con @RateLimit(). Para una fase nueva:
 * agrega la variable en env.schema.ts, la política aquí y decora el endpoint.
 */
export const RATE_LIMIT_POLICIES = {
  otpRequestIp: { limitFrom: 'RATE_OTP_IP_PER_HOUR', windowSec: 3600 },
  otpVerifyIp: { limitFrom: 'RATE_OTP_VERIFY_IP_PER_15MIN', windowSec: 900 },
  authIp: { limitFrom: 'RATE_AUTH_IP_PER_MIN', windowSec: 60 },
  geocodeIp: { limitFrom: 'RATE_GEOCODE_IP_PER_MIN', windowSec: 60 },
  requestCreateIp: { limitFrom: 'RATE_REQUEST_CREATE_IP_PER_HOUR', windowSec: 3600 },
} satisfies Record<string, RateLimitPolicyDef>;

export type RateLimitPolicy = keyof typeof RATE_LIMIT_POLICIES;

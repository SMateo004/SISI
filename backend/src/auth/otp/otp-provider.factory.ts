import type { Env } from '../../config/env.schema';
import { BirdOtpProvider } from './bird-otp.provider';
import { ConsoleOtpProvider } from './console-otp.provider';
import type { OtpProvider } from './otp-provider';

type OtpEnv = Pick<
  Env,
  'APP_ENV' | 'OTP_PROVIDER' | 'OTP_PROVIDER_KEY' | 'OTP_SENDER' | 'OTP_TTL_SEC'
>;

/**
 * Elige el proveedor según la configuración y valida al arrancar (ADR-0011):
 * - APP_ENV=production nunca usa la consola.
 * - Bird exige clave y remitente.
 */
export function createOtpProvider(env: OtpEnv): OtpProvider {
  if (env.OTP_PROVIDER === 'console') {
    if (env.APP_ENV === 'production') {
      throw new Error(
        'OTP_PROVIDER=console no está permitido con APP_ENV=production. Configura OTP_PROVIDER=bird.',
      );
    }
    return new ConsoleOtpProvider();
  }

  if (!env.OTP_PROVIDER_KEY || !env.OTP_SENDER) {
    throw new Error('OTP_PROVIDER=bird requiere OTP_PROVIDER_KEY y OTP_SENDER.');
  }
  return new BirdOtpProvider({
    apiKey: env.OTP_PROVIDER_KEY,
    sender: env.OTP_SENDER,
    ttlMinutes: Math.round(env.OTP_TTL_SEC / 60),
  });
}

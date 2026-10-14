/** Envía el código de verificación por un canal externo (SMS, WhatsApp). ADR-0011. */
export interface OtpProvider {
  readonly name: 'console' | 'bird';
  send(phoneE164: string, code: string): Promise<void>;
}

export const OTP_PROVIDER = Symbol('OTP_PROVIDER');

/** Texto del mensaje. El nombre comercial es provisional (docs/pendientes.md). */
export function otpMessage(code: string, ttlMinutes: number): string {
  return `Tu código de SISI es ${code}. Vence en ${ttlMinutes} minutos. No lo compartas con nadie.`;
}

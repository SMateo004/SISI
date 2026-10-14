import { createHash, createHmac, hkdfSync, randomInt } from 'node:crypto';

/**
 * Hash de códigos OTP (ADR-0009). HMAC-SHA256 con una clave derivada por HKDF de
 * JWT_SECRET: si Redis se filtra, los códigos de 6 dígitos no se pueden probar
 * por fuerza bruta sin el secreto del servidor.
 */
export class OtpHasher {
  private readonly key: Buffer;

  constructor(secret: string) {
    this.key = Buffer.from(hkdfSync('sha256', secret, 'sisi', 'otp-hmac-v1', 32));
  }

  hash(phoneE164: string, code: string): string {
    return createHmac('sha256', this.key).update(`${phoneE164}:${code}`).digest('hex');
  }

  /** Clave de Redis sin el teléfono en claro. */
  phoneKey(phoneE164: string): string {
    return createHash('sha256').update(phoneE164).digest('hex').slice(0, 32);
  }

  static generateCode(): string {
    return randomInt(0, 1_000_000).toString().padStart(6, '0');
  }
}

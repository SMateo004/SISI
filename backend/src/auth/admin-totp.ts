import { createHmac, randomBytes, timingSafeEqual } from 'node:crypto';

/**
 * Códigos de una app autenticadora (TOTP, RFC 6238: HMAC-SHA1, 6 dígitos, cada 30 s) para el
 * ingreso al panel (ADR-0055). Sin dependencias: Google Authenticator, Microsoft Authenticator,
 * Authy y similares usan estos mismos valores por defecto.
 */
export const TOTP_STEP_SEC = 30;
export const TOTP_DIGITS = 6;

const ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

/** Normaliza una clave base32 tal como la copia una persona (espacios, minúsculas, relleno). */
export const normalizeBase32 = (value: string): string =>
  value.replace(/[\s=-]/g, '').toUpperCase();

export function base32Decode(value: string): Buffer {
  const clean = normalizeBase32(value);
  let bits = 0;
  let acc = 0;
  const out: number[] = [];
  for (const char of clean) {
    const index = ALPHABET.indexOf(char);
    if (index < 0) throw new Error('La clave TOTP no es base32 válida.');
    acc = (acc << 5) | index;
    bits += 5;
    if (bits >= 8) {
      bits -= 8;
      out.push((acc >>> bits) & 0xff);
    }
  }
  return Buffer.from(out);
}

export function base32Encode(bytes: Buffer): string {
  let bits = 0;
  let acc = 0;
  let out = '';
  for (const byte of bytes) {
    acc = (acc << 8) | byte;
    bits += 8;
    while (bits >= 5) {
      bits -= 5;
      out += ALPHABET.charAt((acc >>> bits) & 31);
    }
  }
  if (bits > 0) out += ALPHABET.charAt((acc << (5 - bits)) & 31);
  return out;
}

/** Clave nueva de 160 bits (lo que recomienda el RFC 4226 para HMAC-SHA1). */
export const generateTotpSecret = (): string => base32Encode(randomBytes(20));

export const totpStep = (nowMs: number): number => Math.floor(nowMs / 1000 / TOTP_STEP_SEC);

/** Código de un paso de 30 s (RFC 4226 §5.3, truncado dinámico). */
export function totpAt(secret: Buffer, step: number, digits = TOTP_DIGITS): string {
  const counter = Buffer.alloc(8);
  counter.writeBigUInt64BE(BigInt(step));
  const mac = createHmac('sha1', secret).update(counter).digest();
  const offset = (mac[mac.length - 1] ?? 0) & 0x0f;
  const binary = mac.readUInt32BE(offset) & 0x7fffffff;
  return String(binary % 10 ** digits).padStart(digits, '0');
}

/**
 * Paso al que corresponde `code`, o null. Acepta un paso antes y uno después del actual: el
 * reloj del teléfono puede estar algo corrido. Compara en tiempo constante.
 */
export function matchTotp(secret: Buffer, code: string, nowMs: number, window = 1): number | null {
  if (!/^\d{6}$/.test(code)) return null;
  const given = Buffer.from(code);
  const current = totpStep(nowMs);
  let match: number | null = null;
  for (let step = current - window; step <= current + window; step++) {
    if (timingSafeEqual(Buffer.from(totpAt(secret, step)), given)) match = step;
  }
  return match;
}

/** Enlace que leen las apps autenticadoras (también como QR). */
export function otpauthUri(secretBase32: string, account: string, issuer = 'SISI'): string {
  const label = encodeURIComponent(`${issuer}:${account}`);
  const params = new URLSearchParams({
    secret: normalizeBase32(secretBase32),
    issuer,
    algorithm: 'SHA1',
    digits: String(TOTP_DIGITS),
    period: String(TOTP_STEP_SEC),
  });
  return `otpauth://totp/${label}?${params.toString()}`;
}

import { maskPhone } from '../phone/phone';

/**
 * Datos personales fuera de los logs y de Sentry (ADR-0047). Teléfonos enmascarados,
 * direcciones ocultas y nunca documentos, tokens ni códigos OTP.
 */

/** Claves cuyo valor nunca se registra. */
const SECRET_KEYS = new Set(
  [
    'code',
    'otp',
    'token',
    'accesstoken',
    'refreshtoken',
    'apptoken',
    'authorization',
    'cookie',
    'set-cookie',
    'password',
    'secret',
    'filekey',
    'receiptkey',
    'photokey',
    'key',
    'uploadurl',
    'url',
    'birthdate',
    'private_key',
  ].map((k) => k.toLowerCase()),
);
/** Claves con datos personales que se enmascaran. */
const PHONE_KEYS = new Set(['phone', 'phonee164', 'workerphone', 'to']);
const ADDRESS_KEYS = new Set(['address', 'direccion']);

const JWT = /eyJ[\w-]{5,}\.[\w-]{5,}\.[\w-]{5,}/g;
const BEARER = /Bearer\s+[^\s"',]+/gi;
// +591 y 8 dígitos, o un celular boliviano suelto (6/7 + 7 dígitos).
const PHONE = /\+?591\s?[67]\d{7}|\b[67]\d{7}\b/g;
// Un código OTP (6 dígitos sueltos). Solo en textos de terceros (p. ej. la respuesta de Bird).
const OTP_CODE = /\b\d{6}\b/g;

export function redactText(text: string, options: { codes?: boolean } = {}): string {
  let out = text
    .replace(JWT, '[jwt]')
    .replace(BEARER, 'Bearer [redactado]')
    .replace(PHONE, (m) => maskPhone(m.startsWith('+') ? m : `+591${m.slice(-8)}`));
  if (options.codes) out = out.replace(OTP_CODE, '••••••');
  return out;
}

/** Copia profunda con los campos sensibles reemplazados. No modifica el original. */
export function redactValue(value: unknown, depth = 0): unknown {
  if (depth > 8) return '[…]';
  if (typeof value === 'string') return redactText(value);
  if (Array.isArray(value)) return value.map((v) => redactValue(v, depth + 1));
  if (value === null || typeof value !== 'object') return value;
  const out: Record<string, unknown> = {};
  for (const [key, v] of Object.entries(value as Record<string, unknown>)) {
    const k = key.toLowerCase();
    if (SECRET_KEYS.has(k)) out[key] = '[redactado]';
    else if (PHONE_KEYS.has(k) && typeof v === 'string') out[key] = maskPhone(v);
    else if (ADDRESS_KEYS.has(k)) out[key] = '[dirección]';
    else out[key] = redactValue(v, depth + 1);
  }
  return out;
}

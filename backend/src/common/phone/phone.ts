import { type CountryCode, parsePhoneNumberWithError } from 'libphonenumber-js/max';

export type PhoneErrorCode = 'PHONE_INVALID' | 'PHONE_COUNTRY_NOT_ALLOWED' | 'PHONE_NOT_MOBILE';

const MESSAGES: Record<PhoneErrorCode, string> = {
  PHONE_INVALID: 'El número de teléfono no es válido.',
  PHONE_COUNTRY_NOT_ALLOWED: 'Por ahora solo aceptamos números de Bolivia (+591).',
  PHONE_NOT_MOBILE: 'Usa un número de celular para recibir el código.',
};

export class PhoneValidationError extends Error {
  constructor(readonly code: PhoneErrorCode) {
    super(MESSAGES[code]);
    this.name = 'PhoneValidationError';
  }
}

/**
 * Normaliza un teléfono a E.164 (R1.1). Sin prefijo se asume Bolivia (+591).
 * Solo celulares (el código llega por SMS) y solo de los prefijos permitidos.
 */
export function normalizePhone(
  input: string,
  allowedCallingCodes: readonly string[],
  defaultCountry: CountryCode = 'BO',
): string {
  const cleaned = input.trim().replace(/^00/, '+');
  let parsed;
  try {
    parsed = parsePhoneNumberWithError(cleaned, defaultCountry);
  } catch {
    throw new PhoneValidationError('PHONE_INVALID');
  }
  if (!parsed.isValid()) {
    throw new PhoneValidationError('PHONE_INVALID');
  }
  if (!allowedCallingCodes.includes(parsed.countryCallingCode)) {
    throw new PhoneValidationError('PHONE_COUNTRY_NOT_ALLOWED');
  }
  const type = parsed.getType();
  if (type !== 'MOBILE' && type !== 'FIXED_LINE_OR_MOBILE') {
    throw new PhoneValidationError('PHONE_NOT_MOBILE');
  }
  return parsed.number;
}

/** Oculta el número para logs: +591700•••45. */
export function maskPhone(e164: string): string {
  return e164.length <= 6 ? '•••' : `${e164.slice(0, 7)}•••${e164.slice(-2)}`;
}

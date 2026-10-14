import { maskPhone, normalizePhone, PhoneValidationError } from './phone';

const BO = ['591'];

describe('normalizePhone', () => {
  it.each([
    ['70012345', '+59170012345'],
    ['7 001 2345', '+59170012345'],
    ['+591 70012345', '+59170012345'],
    ['+591-700-12345', '+59170012345'],
    ['0059170012345', '+59170012345'],
    ['  67891234 ', '+59167891234'],
  ])('normaliza %p a %p', (input, expected) => {
    expect(normalizePhone(input, BO)).toBe(expected);
  });

  it('rechaza números inválidos', () => {
    expect(() => normalizePhone('123', BO)).toThrow(PhoneValidationError);
    expect(() => normalizePhone('abc', BO)).toThrow('El número de teléfono no es válido.');
    expect(() => normalizePhone('', BO)).toThrow(PhoneValidationError);
  });

  it('rechaza teléfonos fijos de Bolivia', () => {
    // 3 = fijo de Santa Cruz.
    expect(() => normalizePhone('33456789', BO)).toThrow(
      expect.objectContaining({ code: 'PHONE_NOT_MOBILE' }) as Error,
    );
  });

  it('rechaza países fuera de la lista permitida', () => {
    expect(() => normalizePhone('+5491123456789', BO)).toThrow(
      expect.objectContaining({ code: 'PHONE_COUNTRY_NOT_ALLOWED' }) as Error,
    );
  });

  it('acepta otro país si está en la configuración', () => {
    expect(normalizePhone('+5491123456789', ['591', '54'])).toBe('+5491123456789');
  });
});

describe('maskPhone', () => {
  it('oculta los dígitos centrales', () => {
    expect(maskPhone('+59170012345')).toBe('+591700•••45');
  });
});

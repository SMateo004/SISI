import { requireIdempotencyKey } from './idempotency';

describe('Idempotency-Key', () => {
  it('obligatoria y con formato', () => {
    expect(() => requireIdempotencyKey(undefined)).toThrow('Falta el header Idempotency-Key.');
    expect(() => requireIdempotencyKey('corta')).toThrow(/8 a 100/);
    expect(() => requireIdempotencyKey('con espacios 123')).toThrow(/8 a 100/);
    expect(requireIdempotencyKey('pago-2026-10-17_a1')).toBe('pago-2026-10-17_a1');
  });
});

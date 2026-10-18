import { redactText, redactValue } from './redact';

describe('redact (ADR-0047)', () => {
  it('enmascara teléfonos, JWT y Bearer en texto libre', () => {
    const out = redactText(
      'Bird rechazó +59170012345 (o 71234567) con Bearer bk_us1_secreto y eyJhbGciOi.eyJzdWIiOi.c2lnbmF0dXJl',
    );
    expect(out).not.toContain('70012345');
    expect(out).not.toContain('71234567');
    expect(out).toContain('+591700•••45');
    expect(out).toContain('Bearer [redactado]');
    expect(out).toContain('[jwt]');
    expect(out).not.toContain('secreto');
  });

  it('borra códigos de 6 dígitos solo si se pide', () => {
    expect(redactText('Tu código es 123456')).toContain('123456');
    expect(redactText('Tu código es 123456', { codes: true })).not.toContain('123456');
  });

  it('reemplaza claves sensibles en objetos anidados sin tocar el original', () => {
    const input = {
      phone: '+59170012345',
      code: '123456',
      refreshToken: 'abc',
      nested: { address: 'Calle Junín 150', fileKey: 'identity/u/ci_front-1.jpg', ok: 1 },
      list: [{ authorization: 'Bearer x' }],
    };
    const out = redactValue(input) as typeof input;
    expect(out.phone).toBe('+591700•••45');
    expect(out.code).toBe('[redactado]');
    expect(out.refreshToken).toBe('[redactado]');
    expect(out.nested.address).toBe('[dirección]');
    expect(out.nested.fileKey).toBe('[redactado]');
    expect(out.nested.ok).toBe(1);
    expect(out.list[0]?.authorization).toBe('[redactado]');
    expect(input.code).toBe('123456');
  });
});

import {
  base32Decode,
  base32Encode,
  generateTotpSecret,
  matchTotp,
  otpauthUri,
  totpAt,
  totpStep,
} from './admin-totp';

// Clave de los vectores de prueba del RFC 6238 (apéndice B, SHA1): "12345678901234567890".
const RFC_SECRET = Buffer.from('12345678901234567890');
const RFC_BASE32 = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';

describe('TOTP del panel (RFC 6238, ADR-0055)', () => {
  it('reproduce los vectores del RFC (8 dígitos)', () => {
    const cases: [number, string][] = [
      [59, '94287082'],
      [1111111109, '07081804'],
      [1111111111, '14050471'],
      [1234567890, '89005924'],
      [2000000000, '69279037'],
    ];
    for (const [seconds, code] of cases) {
      expect(totpAt(RFC_SECRET, totpStep(seconds * 1000), 8)).toBe(code);
    }
  });

  it('base32 ida y vuelta, tolerante a espacios y minúsculas', () => {
    expect(base32Encode(RFC_SECRET)).toBe(RFC_BASE32);
    expect(base32Decode('gezd gnbv gy3t qojq gezd gnbv gy3t qojq')).toEqual(RFC_SECRET);
    expect(() => base32Decode('NO-ES-BASE32!')).toThrow(/base32/);
    expect(base32Decode(generateTotpSecret())).toHaveLength(20);
  });

  it('acepta el paso actual y uno de cada lado; nada más', () => {
    const now = 1_792_350_000_000;
    const step = totpStep(now);
    expect(matchTotp(RFC_SECRET, totpAt(RFC_SECRET, step), now)).toBe(step);
    expect(matchTotp(RFC_SECRET, totpAt(RFC_SECRET, step - 1), now)).toBe(step - 1);
    expect(matchTotp(RFC_SECRET, totpAt(RFC_SECRET, step + 1), now)).toBe(step + 1);
    expect(matchTotp(RFC_SECRET, totpAt(RFC_SECRET, step - 3), now)).toBeNull();
    expect(matchTotp(RFC_SECRET, '12345', now)).toBeNull();
    expect(matchTotp(RFC_SECRET, 'abcdef', now)).toBeNull();
  });

  it('arma el enlace otpauth para la app autenticadora', () => {
    const uri = otpauthUri('gezd gnbv', 'admin');
    expect(uri).toBe(
      'otpauth://totp/SISI%3Aadmin?secret=GEZDGNBV&issuer=SISI&algorithm=SHA1&digits=6&period=30',
    );
  });
});

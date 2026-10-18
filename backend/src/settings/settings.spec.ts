import { SETTINGS, settingDef, validateSetting } from './settings.catalog';

const def = (key: string) => {
  const found = settingDef(key);
  if (!found) throw new Error(key);
  return found;
};

describe('catálogo de parámetros (ADR-0043)', () => {
  it('cada parámetro tiene rango o es de anillos, y las claves no se repiten', () => {
    expect(new Set(SETTINGS.map((s) => s.key)).size).toBe(SETTINGS.length);
    for (const s of SETTINGS) {
      if (s.kind !== 'rings') {
        expect(s.min).toBeDefined();
        expect(s.max).toBeDefined();
      }
    }
  });

  it('valida el rango y los enteros', () => {
    const wait = def('MATCHING_RING_WAIT_MS');
    expect(validateSetting(wait, 45_000)).toEqual({ ok: true, value: 45_000 });
    expect(validateSetting(wait, '45000')).toEqual({ ok: true, value: 45_000 });
    expect(validateSetting(wait, 1000)).toMatchObject({ ok: false });
    expect(validateSetting(wait, 45_000.5)).toMatchObject({ ok: false });
    expect(validateSetting(wait, 'abc')).toMatchObject({ ok: false });
  });

  it('montos en Bs con 2 decimales, como texto', () => {
    const cap = def('BILLING_DEBT_CAP_BS');
    expect(validateSetting(cap, 200)).toEqual({ ok: true, value: '200.00' });
    expect(validateSetting(cap, '150.5')).toEqual({ ok: true, value: '150.50' });
    expect(validateSetting(cap, 1.234)).toMatchObject({ ok: false });
    expect(validateSetting(cap, -1)).toMatchObject({ ok: false });
  });

  it('anillos: crecientes, hasta 6, hasta 30 km y 50 trabajadores; se normalizan', () => {
    const rings = def('MATCHING_RINGS');
    expect(validateSetting(rings, ' 2:5, 5:10 ')).toEqual({ ok: true, value: '2:5,5:10' });
    expect(validateSetting(rings, '5:10,2:5')).toMatchObject({ ok: false });
    expect(validateSetting(rings, '1:1,2:1,3:1,4:1,5:1,6:1,7:1')).toMatchObject({ ok: false });
    expect(validateSetting(rings, '40:5')).toMatchObject({ ok: false });
    expect(validateSetting(rings, 5)).toMatchObject({ ok: false });
  });

  it('la hora de los avisos va de 6 a 21', () => {
    const hour = def('BILLING_REMINDER_HOUR');
    expect(validateSetting(hour, 9)).toMatchObject({ ok: true });
    expect(validateSetting(hour, 3)).toMatchObject({ ok: false });
  });
});

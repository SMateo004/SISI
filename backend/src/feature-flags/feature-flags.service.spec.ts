import { FLAG_KEY_PATTERN, resolveFlag } from './feature-flags.service';

describe('resolveFlag', () => {
  it('sin filas está apagado', () => {
    expect(resolveFlag({ global: null, cities: {} }, 'scz')).toBe(false);
  });

  it('usa el valor global si la ciudad no tiene uno propio', () => {
    expect(resolveFlag({ global: true, cities: {} }, 'scz')).toBe(true);
    expect(resolveFlag({ global: true, cities: {} })).toBe(true);
  });

  it('la ciudad tiene prioridad sobre el global, en ambos sentidos', () => {
    expect(resolveFlag({ global: true, cities: { scz: false } }, 'scz')).toBe(false);
    expect(resolveFlag({ global: false, cities: { scz: true } }, 'scz')).toBe(true);
    expect(resolveFlag({ global: false, cities: { scz: true } }, 'lpz')).toBe(false);
  });
});

describe('FLAG_KEY_PATTERN', () => {
  it('acepta keys en minúsculas con punto, guion o guion bajo', () => {
    expect(FLAG_KEY_PATTERN.test('payments.in_app')).toBe(true);
    expect(FLAG_KEY_PATTERN.test('requests-scheduled')).toBe(true);
  });

  it('rechaza mayúsculas, espacios y longitudes fuera de rango', () => {
    expect(FLAG_KEY_PATTERN.test('Pagos')).toBe(false);
    expect(FLAG_KEY_PATTERN.test('con espacio')).toBe(false);
    expect(FLAG_KEY_PATTERN.test('a')).toBe(false);
  });
});

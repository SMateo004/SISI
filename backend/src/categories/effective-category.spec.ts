import {
  type BaseCategory,
  decimal,
  effectiveCategory,
  formatBs,
  MONEY_PATTERN,
  toBs,
} from './effective-category';

const base: BaseCategory = {
  id: 'c1',
  slug: 'plomeria',
  name: 'Plomería',
  description: null,
  priceMinBs: decimal('80.00'),
  priceMaxBs: decimal('300.00'),
  commissionPct: decimal('13.00'),
  active: true,
};

const override = (
  values: Partial<Record<'priceMinBs' | 'priceMaxBs' | 'commissionPct', string>>,
  active = true,
) => ({
  active,
  priceMinBs: values.priceMinBs ? decimal(values.priceMinBs) : null,
  priceMaxBs: values.priceMaxBs ? decimal(values.priceMaxBs) : null,
  commissionPct: values.commissionPct ? decimal(values.commissionPct) : null,
});

describe('effectiveCategory (resolvedor por ciudad)', () => {
  it('sin override hereda la base', () => {
    const e = effectiveCategory(base, 'scz', override({}));
    expect(toBs(e.priceMinBs)).toBe('80.00');
    expect(toBs(e.priceMaxBs)).toBe('300.00');
    expect(toBs(e.commissionPct)).toBe('13.00');
    expect(e.active).toBe(true);
  });

  it('el override de la ciudad reemplaza solo los campos definidos', () => {
    const e = effectiveCategory(
      base,
      'lpz',
      override({ priceMinBs: '100', commissionPct: '10.5' }),
    );
    expect(toBs(e.priceMinBs)).toBe('100.00');
    expect(toBs(e.priceMaxBs)).toBe('300.00');
    expect(toBs(e.commissionPct)).toBe('10.50');
  });

  it('sin fila de ciudad, o desactivada allí, no está activa', () => {
    expect(effectiveCategory(base, 'cbba', null).active).toBe(false);
    expect(effectiveCategory(base, 'scz', override({}, false)).active).toBe(false);
  });

  it('una categoría desactivada globalmente no se activa por ciudad', () => {
    expect(effectiveCategory({ ...base, active: false }, 'scz', override({})).active).toBe(false);
  });

  it('montos como Decimal exacto, sin errores de float', () => {
    const e = effectiveCategory(base, 'scz', override({ priceMinBs: '0.1' }));
    expect(toBs(e.priceMinBs.plus(decimal('0.2')))).toBe('0.30');
    expect(formatBs(decimal('19.5'))).toBe('Bs 19,50');
  });

  it('MONEY_PATTERN acepta hasta 2 decimales y rechaza negativos o notación científica', () => {
    for (const ok of ['80', '80.5', '80.50', '12345678.99'])
      expect(MONEY_PATTERN.test(ok)).toBe(true);
    for (const bad of ['-1', '1e3', '80.555', '123456789', '', 'abc'])
      expect(MONEY_PATTERN.test(bad)).toBe(false);
  });
});

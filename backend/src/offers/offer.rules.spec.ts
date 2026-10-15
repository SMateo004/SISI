import { ApiError } from '../common/errors/api-error';
import { counterCap, estimateEtaMin, offerAmount, parseSpeeds, shortName } from './offer.rules';

const SPEEDS = parseSpeeds('a_pie:4.5,bicicleta:12,moto:25,auto:20,transporte_publico:15');

describe('ETA (R5.3)', () => {
  it('distancia × factor de recorrido a la velocidad del medio, en minutos hacia arriba', () => {
    // 5 km × 1,3 = 6,5 km en moto a 25 km/h = 15,6 min → 16.
    expect(estimateEtaMin(5000, 'moto', SPEEDS, 1.3)).toBe(16);
    // 1 km × 1,3 a pie a 4,5 km/h = 17,3 min → 18.
    expect(estimateEtaMin(1000, 'a_pie', SPEEDS, 1.3)).toBe(18);
  });

  it('mínimo 1 minuto; sin medio de transporte asume a pie', () => {
    expect(estimateEtaMin(10, 'auto', SPEEDS, 1.3)).toBe(1);
    expect(estimateEtaMin(1000, null, SPEEDS, 1.3)).toBe(18);
  });

  it('ETA_SPEEDS_KMH debe traer todos los medios', () => {
    expect(() => parseSpeeds('a_pie:4.5,moto:25')).toThrow(/bicicleta/);
    expect(() => parseSpeeds('a_pie:0,bicicleta:1,moto:1,auto:1,transporte_publico:1')).toThrow(
      /a_pie/,
    );
  });
});

describe('Monto de la oferta (R5.2)', () => {
  const base = { proposedPriceBs: '150.00', priceMaxBs: '300.00', maxFactor: 3 };

  it('aceptar usa el precio propuesto', () => {
    expect(offerAmount({ ...base, type: 'accept', amountBs: '999' })).toBe('150.00');
  });

  it('contraoferta: normaliza a 2 decimales y acepta coma decimal', () => {
    expect(offerAmount({ ...base, type: 'counter', amountBs: '180' })).toBe('180.00');
    expect(offerAmount({ ...base, type: 'counter', amountBs: '180,5' })).toBe('180.50');
  });

  it('contraoferta: rechaza 0, negativos, más de 2 decimales y vacíos', () => {
    for (const amountBs of ['0', '-5', '10.555', 'abc', undefined, '']) {
      expect(() => offerAmount({ ...base, type: 'counter', amountBs })).toThrow(ApiError);
    }
  });

  it('contraoferta: tope de 3 × el máximo de referencia', () => {
    expect(offerAmount({ ...base, type: 'counter', amountBs: '900' })).toBe('900.00');
    try {
      offerAmount({ ...base, type: 'counter', amountBs: '900.01' });
      throw new Error('debía fallar');
    } catch (err) {
      expect((err as ApiError).getResponse()).toMatchObject({
        code: 'OFFER_AMOUNT_TOO_HIGH',
        maxBs: '900.00',
      });
    }
    expect(counterCap('300.00', 3)).toBe('900.00');
  });
});

describe('Nombre corto (R5.3)', () => {
  it('nombre y la inicial del apellido', () => {
    expect(shortName('María Pérez Gómez')).toBe('María P.');
    expect(shortName('  juan  carlos ')).toBe('juan C.');
    expect(shortName('Ana')).toBe('Ana');
    expect(shortName(null)).toBe('Trabajador');
    expect(shortName('')).toBe('Trabajador');
  });
});

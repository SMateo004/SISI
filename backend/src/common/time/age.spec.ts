import { ageOn, calendarDateIn, isAdult, parseIsoDate } from './age';

const LA_PAZ = 'America/La_Paz'; // UTC-4 todo el año

describe('parseIsoDate', () => {
  it('acepta fechas reales y rechaza las imposibles', () => {
    expect(parseIsoDate('2008-02-29')).toEqual({ year: 2008, month: 2, day: 29 });
    expect(parseIsoDate('2007-02-29')).toBeNull();
    expect(parseIsoDate('2008-13-01')).toBeNull();
    expect(parseIsoDate('08-01-2008')).toBeNull();
  });
});

describe('calendarDateIn', () => {
  it('usa la fecha de Bolivia, no la de UTC', () => {
    // 2026-10-15 02:00 UTC = 2026-10-14 22:00 en La Paz.
    expect(calendarDateIn(new Date('2026-10-15T02:00:00Z'), LA_PAZ)).toEqual({
      year: 2026,
      month: 10,
      day: 14,
    });
  });
});

describe('isAdult (límite del cumpleaños)', () => {
  const birth = '2008-10-15';

  it('no es mayor de edad el día anterior a cumplir 18', () => {
    expect(isAdult(birth, new Date('2026-10-14T12:00:00Z'), LA_PAZ)).toBe(false);
  });

  it('es mayor de edad desde las 00:00 del cumpleaños en Bolivia', () => {
    // 2026-10-15 04:00 UTC = 00:00 en La Paz.
    expect(isAdult(birth, new Date('2026-10-15T04:00:00Z'), LA_PAZ)).toBe(true);
  });

  it('todavía no lo es a las 23:59 de la víspera en Bolivia aunque en UTC ya sea el cumpleaños', () => {
    // 2026-10-15 03:59 UTC = 2026-10-14 23:59 en La Paz.
    expect(isAdult(birth, new Date('2026-10-15T03:59:00Z'), LA_PAZ)).toBe(false);
  });

  it('nacidos un 29 de febrero cumplen el 1 de marzo en años no bisiestos', () => {
    const leap = { year: 2008, month: 2, day: 29 };
    expect(ageOn(leap, new Date('2026-02-28T12:00:00Z'), LA_PAZ)).toBe(17);
    expect(ageOn(leap, new Date('2026-03-01T12:00:00Z'), LA_PAZ)).toBe(18);
  });

  it('rechaza fechas inválidas', () => {
    expect(isAdult('no-es-fecha', new Date(), LA_PAZ)).toBe(false);
  });
});

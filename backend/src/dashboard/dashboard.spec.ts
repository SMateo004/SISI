import { rangeBounds } from './dashboard.service';

describe('rangeBounds (hora local de la ciudad)', () => {
  const tz = 'America/La_Paz';

  it('día: de las 00:00 a las 00:00 del día siguiente en Bolivia', () => {
    // Domingo 18/10/2026 a las 23:30 en La Paz = lunes 03:30 UTC.
    const { from, to } = rangeBounds('day', new Date('2026-10-19T03:30:00.000Z'), tz);
    expect(from.toISOString()).toBe('2026-10-18T04:00:00.000Z');
    expect(to.toISOString()).toBe('2026-10-19T04:00:00.000Z');
  });

  it('semana: de lunes a lunes, local', () => {
    const { from, to } = rangeBounds('week', new Date('2026-10-21T15:00:00.000Z'), tz);
    expect(from.toISOString()).toBe('2026-10-19T04:00:00.000Z');
    expect(to.toISOString()).toBe('2026-10-26T04:00:00.000Z');
  });

  it('un domingo sigue en la semana que empezó el lunes anterior', () => {
    const { from } = rangeBounds('week', new Date('2026-10-26T03:00:00.000Z'), tz);
    expect(from.toISOString()).toBe('2026-10-19T04:00:00.000Z');
  });
});

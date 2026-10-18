import { daysLate, isoWeekRange } from './billing-panel.service';

describe('isoWeekRange', () => {
  it('cubre el lunes 00:00 local de esa semana ISO en Bolivia', () => {
    // 2026-W43 empieza el lunes 19/10/2026; en La Paz, a las 04:00 UTC.
    const range = isoWeekRange('2026-W43');
    const start = new Date('2026-10-19T04:00:00.000Z');
    expect(range.gte.getTime()).toBeLessThanOrEqual(start.getTime());
    expect(range.lt.getTime()).toBeGreaterThan(start.getTime());
    // No incluye el lunes anterior ni el siguiente.
    expect(new Date('2026-10-12T04:00:00.000Z') < range.gte).toBe(true);
    expect(new Date('2026-10-26T04:00:00.000Z') >= range.lt).toBe(true);
  });

  it('la semana 1 puede empezar en diciembre (ISO)', () => {
    // 2026-W01 empieza el lunes 29/12/2025.
    const range = isoWeekRange('2026-W01');
    const start = new Date('2025-12-29T04:00:00.000Z');
    expect(start >= range.gte && start < range.lt).toBe(true);
  });
});

describe('daysLate', () => {
  const due = new Date('2026-10-22T04:00:00.000Z'); // jueves 00:00 en La Paz ("miércoles 23:59")
  const tz = 'America/La_Paz';

  it('el jueves es 1 día de atraso; el viernes, 2', () => {
    expect(daysLate(due, new Date('2026-10-22T13:00:00.000Z'), tz)).toBe(1);
    expect(daysLate(due, new Date('2026-10-24T03:59:00.000Z'), tz)).toBe(2);
  });

  it('antes del plazo, 0', () => {
    expect(daysLate(due, new Date('2026-10-21T20:00:00.000Z'), tz)).toBe(0);
  });
});

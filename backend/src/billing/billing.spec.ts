import { Prisma } from '../generated/prisma/client';
import {
  allocatePayment,
  amountToUnlockCap,
  capTransition,
  dueLabel,
  newBillingCode,
  paymentReference,
  periodStatus,
  periodWindow,
  reminderTimes,
  sumLedger,
} from './billing.rules';
import { fromLocal, isoWeek, toLocal } from './zoned-time';

const d = (v: string): Prisma.Decimal => new Prisma.Decimal(v);
const LA_PAZ = { timeZone: 'America/La_Paz', dueAfterDays: 3, reminderHour: 9 };

describe('zona horaria (ADR-0035)', () => {
  it('La Paz es UTC−4 y se calcula con Intl, no con un número fijo', () => {
    expect(fromLocal({ year: 2026, month: 10, day: 19 }, 'America/La_Paz').toISOString()).toBe(
      '2026-10-19T04:00:00.000Z',
    );
    expect(toLocal(new Date('2026-10-19T03:59:59Z'), 'America/La_Paz')).toMatchObject({
      day: 18,
      hour: 23,
      minute: 59,
      weekday: 7,
    });
  });

  it('respeta el horario de verano en una zona que lo tiene', () => {
    // Nueva York: 8 de marzo de 2026 a las 02:00 pasa a las 03:00 (UTC−5 → UTC−4).
    const before = fromLocal({ year: 2026, month: 3, day: 7 }, 'America/New_York');
    const after = fromLocal({ year: 2026, month: 3, day: 9 }, 'America/New_York');
    expect(before.toISOString()).toBe('2026-03-07T05:00:00.000Z');
    expect(after.toISOString()).toBe('2026-03-09T04:00:00.000Z');
    const w = periodWindow(new Date('2026-03-08T12:00:00Z'), {
      ...LA_PAZ,
      timeZone: 'America/New_York',
    });
    // La semana dura 167 h, no 168.
    expect((w.endAt.getTime() - w.startAt.getTime()) / 3_600_000).toBe(167);
  });

  it('semana ISO', () => {
    expect(isoWeek({ year: 2026, month: 10, day: 19 })).toEqual({ year: 2026, week: 43 });
    expect(isoWeek({ year: 2027, month: 1, day: 1 })).toEqual({ year: 2026, week: 53 });
  });
});

describe('periodo de un trabajo (R7.2)', () => {
  // Domingo 18 de octubre de 2026 en La Paz.
  it('domingo 23:59:59 cae en la semana que termina', () => {
    const w = periodWindow(new Date('2026-10-19T03:59:59.999Z'), LA_PAZ);
    expect(w.startAt.toISOString()).toBe('2026-10-12T04:00:00.000Z');
    expect(w.endAt.toISOString()).toBe('2026-10-19T04:00:00.000Z');
  });

  it('lunes 00:00:00 empieza la semana siguiente (intervalo semiabierto)', () => {
    const w = periodWindow(new Date('2026-10-19T04:00:00.000Z'), LA_PAZ);
    expect(w.startAt.toISOString()).toBe('2026-10-19T04:00:00.000Z');
    expect(w.endAt.toISOString()).toBe('2026-10-26T04:00:00.000Z');
  });

  it('la fecha límite se muestra como miércoles 23:59 local', () => {
    expect(dueLabel(new Date('2026-10-22T04:00:00.000Z'), 'America/La_Paz')).toBe(
      'miércoles 21/10 a las 23:59',
    );
  });

  it('vence el jueves 00:00 local (miércoles 23:59) y recuerda martes y miércoles a las 09:00', () => {
    const w = periodWindow(new Date('2026-10-15T15:00:00Z'), LA_PAZ);
    expect(w.dueAt.toISOString()).toBe('2026-10-22T04:00:00.000Z');
    const r = reminderTimes(w.dueAt, LA_PAZ);
    expect(r.vispera.toISOString()).toBe('2026-10-20T13:00:00.000Z');
    expect(r.dia.toISOString()).toBe('2026-10-21T13:00:00.000Z');
  });
});

describe('referencia de pago (ADR-0035)', () => {
  it('SISI-<AASS>-<código> con la semana ISO local', () => {
    const start = new Date('2026-10-19T04:00:00.000Z');
    expect(paymentReference(start, 'America/La_Paz', 'K7M2QX')).toBe('SISI-2643-K7M2QX');
  });

  it('código de 6 caracteres sin caracteres ambiguos', () => {
    const codes = new Set(Array.from({ length: 500 }, () => newBillingCode()));
    for (const c of codes) expect(c).toMatch(/^[2-9A-HJKMNP-Z]{6}$/);
    // 31^6 combinaciones: 500 códigos al azar no deberían repetirse.
    expect(codes.size).toBe(500);
  });

  it('distintos trabajadores o semanas dan referencias distintas', () => {
    const a = new Date('2026-10-19T04:00:00.000Z');
    const b = new Date('2026-10-26T04:00:00.000Z');
    const refs = new Set([
      paymentReference(a, 'America/La_Paz', 'AAAAAA'),
      paymentReference(b, 'America/La_Paz', 'AAAAAA'),
      paymentReference(a, 'America/La_Paz', 'BBBBBB'),
    ]);
    expect(refs.size).toBe(3);
  });
});

describe('ledger (ADR-0034)', () => {
  it('la comisión suma, el pago y el ajuste a favor restan', () => {
    expect(sumLedger([d('19.50'), d('10.40'), d('-20.00'), d('-1.00')]).toFixed(2)).toBe('8.90');
    expect(sumLedger([]).toFixed(2)).toBe('0.00');
  });
});

describe('estado del periodo (R7.8)', () => {
  const endAt = new Date('2026-10-19T04:00:00Z');
  const dueAt = new Date('2026-10-22T04:00:00Z');
  const at = (iso: string, balance: string) =>
    periodStatus({ endAt, dueAt, balance: d(balance), now: new Date(iso) });

  it('abierto, cerrado_pendiente, pagado y vencido', () => {
    expect(at('2026-10-19T03:59:59Z', '19.50')).toBe('abierto');
    expect(at('2026-10-19T04:00:00Z', '19.50')).toBe('cerrado_pendiente');
    expect(at('2026-10-19T04:00:00Z', '0.00')).toBe('pagado');
    expect(at('2026-10-19T04:00:00Z', '-5.00')).toBe('pagado');
    expect(at('2026-10-22T03:59:59Z', '19.50')).toBe('cerrado_pendiente');
    expect(at('2026-10-22T04:00:00Z', '19.50')).toBe('vencido');
    expect(at('2026-10-25T00:00:00Z', '0.00')).toBe('pagado');
  });
});

describe('aplicación de pagos (ADR-0037)', () => {
  const periods = [
    { periodId: 'p1', balance: d('19.50') },
    { periodId: 'p2', balance: d('30.00') },
    { periodId: 'abierto', balance: d('10.40') },
  ];
  const show = (r: { periodId: string; amount: Prisma.Decimal }[]) =>
    r.map((a) => [a.periodId, a.amount.toFixed(2)]);

  it('parcial: cubre el más antiguo primero', () => {
    expect(show(allocatePayment(d('25.00'), periods, 'abierto'))).toEqual([
      ['p1', '19.50'],
      ['p2', '5.50'],
    ]);
  });

  it('total de los cerrados', () => {
    expect(show(allocatePayment(d('49.50'), periods, 'abierto'))).toEqual([
      ['p1', '19.50'],
      ['p2', '30.00'],
    ]);
  });

  it('en exceso: el resto va al periodo abierto (adelanto y saldo a favor)', () => {
    expect(show(allocatePayment(d('100.00'), periods, 'abierto'))).toEqual([
      ['p1', '19.50'],
      ['p2', '30.00'],
      ['abierto', '50.50'],
    ]);
  });

  it('salta periodos sin saldo', () => {
    expect(
      show(
        allocatePayment(d('5.00'), [{ periodId: 'p0', balance: d('0.00') }, ...periods], 'abierto'),
      ),
    ).toEqual([['p1', '5.00']]);
  });
});

describe('tope de deuda (R7.5, ADR-0038)', () => {
  const cap = d('150.00');

  it('avisa al cruzarlo una vez y limpia al bajar', () => {
    expect(capTransition(d('150.00'), cap, false)).toBe('none');
    expect(capTransition(d('150.01'), cap, false)).toBe('notify');
    expect(capTransition(d('200.00'), cap, true)).toBe('none');
    expect(capTransition(d('150.00'), cap, true)).toBe('clear');
    expect(capTransition(d('10.00'), cap, false)).toBe('none');
  });

  it('monto para volver a recibir solicitudes', () => {
    expect(amountToUnlockCap(d('162.30'), cap).toFixed(2)).toBe('12.30');
    expect(amountToUnlockCap(d('150.00'), cap).toFixed(2)).toBe('0.00');
  });
});

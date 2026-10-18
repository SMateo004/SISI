import { Prisma } from '../generated/prisma/client';
import { toAuditJson } from './admin-audit.service';

describe('toAuditJson', () => {
  it('montos con 2 decimales, fechas ISO, bigint como texto y sin undefined', () => {
    expect(
      toAuditJson({
        amountBs: new Prisma.Decimal('19.5'),
        at: new Date('2026-10-19T04:05:00.000Z'),
        entryId: 42n,
        nested: [{ cap: new Prisma.Decimal('150') }],
        skipped: undefined,
        note: null,
      }),
    ).toEqual({
      amountBs: '19.50',
      at: '2026-10-19T04:05:00.000Z',
      entryId: '42',
      nested: [{ cap: '150.00' }],
      note: null,
    });
  });

  it('sin valor: NULL de la base', () => {
    expect(toAuditJson(undefined)).toBe(Prisma.DbNull);
    expect(toAuditJson(null)).toBe(Prisma.DbNull);
  });
});

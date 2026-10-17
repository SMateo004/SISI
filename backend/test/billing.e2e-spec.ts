import { randomUUID } from 'node:crypto';
import { ledgerMismatches } from './utils/billing';
import { createTestApp, login, type TestApp } from './utils/test-app';

describe('Cobros (e2e, ADR-0034)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterEach(async () => {
    // Consistencia después de cada prueba: los totales de los periodos salen del ledger.
    expect(await ledgerMismatches(t)).toEqual([]);
  });

  afterAll(async () => {
    await t.close();
  });

  it('el ledger es append-only: la base rechaza UPDATE y DELETE', async () => {
    const worker = await login(t);
    const city = await t.prisma.city.findFirstOrThrow();
    const period = await t.prisma.billingPeriod.create({
      data: {
        workerId: worker.user.id,
        cityId: city.id,
        timezone: city.timezone,
        startAt: new Date('2026-10-12T04:00:00Z'),
        endAt: new Date('2026-10-19T04:00:00Z'),
        dueAt: new Date('2026-10-22T04:00:00Z'),
        paymentReference: `SISI-TEST-${worker.user.id.slice(0, 8)}`,
      },
    });
    const entry = await t.prisma.ledgerEntry.create({
      data: {
        workerId: worker.user.id,
        cityId: city.id,
        periodId: period.id,
        type: 'ajuste',
        amountBs: '1.00',
        reason: 'Prueba del trigger',
        createdById: worker.user.id,
      },
    });
    await expect(
      t.prisma.$executeRaw`UPDATE ledger_entries SET amount_bs = 0.50 WHERE id = ${entry.id}`,
    ).rejects.toThrow(/append-only/);
    await expect(
      t.prisma.$executeRaw`DELETE FROM ledger_entries WHERE id = ${entry.id}`,
    ).rejects.toThrow(/append-only/);
    // Y el signo se valida en la base: un pago positivo no entra.
    await expect(
      t.prisma.ledgerEntry.create({
        data: {
          workerId: worker.user.id,
          cityId: city.id,
          periodId: period.id,
          type: 'pago',
          amountBs: '5.00',
          paymentId: randomUUID(),
        },
      }),
    ).rejects.toThrow();
    const left = await t.prisma.ledgerEntry.findUniqueOrThrow({ where: { id: entry.id } });
    expect(left.amountBs.toFixed(2)).toBe('1.00');
  });
});

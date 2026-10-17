import { randomUUID } from 'node:crypto';
import { BillingCatchUpService } from '../src/billing/billing-catchup.service';
import { BillingLedgerService } from '../src/billing/billing-ledger.service';
import { connectSocket } from './utils/socket';
import { EventHandlersRegistry } from '../src/outbox/event-handlers.registry';
import { ledgerBalance, ledgerMismatches } from './utils/billing';
import { assignJob, completeJob } from './utils/jobs';
import { bearer, createTestApp, login, type TestApp, waitFor } from './utils/test-app';
import request from 'supertest';

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

  const commissionsOf = (workerId: string) =>
    t.prisma.ledgerEntry.findMany({ where: { workerId, type: 'comision' } });

  const waitCommission = (workerId: string, count = 1) =>
    waitFor(
      async () => {
        const rows = await commissionsOf(workerId);
        return rows.length >= count ? rows : undefined;
      },
      { what: 'la comisión en el ledger' },
    );

  describe('comisión desde job.completed', () => {
    it('un trabajo de 150 Bs deja 19,50 en el periodo de la semana, y un evento repetido no duplica', async () => {
      const job = await assignJob(t);
      await completeJob(t, job);
      const [entry] = await waitCommission(job.worker.id);
      expect(entry?.amountBs.toFixed(2)).toBe('19.50');
      expect(entry?.jobId).toBe(job.jobId);

      const period = await t.prisma.billingPeriod.findUniqueOrThrow({
        where: { id: entry?.periodId ?? '' },
      });
      expect(period).toMatchObject({ status: 'abierto', timezone: 'America/La_Paz' });
      expect([period.grossBs.toFixed(2), period.commissionBs.toFixed(2)]).toEqual([
        '150.00',
        '19.50',
      ]);
      expect(period.paymentReference).toMatch(/^SISI-\d{4}-[2-9A-HJKMNP-Z]{6}$/);
      const now = Date.now();
      expect(period.startAt.getTime()).toBeLessThanOrEqual(now);
      expect(period.endAt.getTime()).toBeGreaterThan(now);

      // El mismo job.completed otra vez (el outbox garantiza al menos una vez).
      const event = await t.prisma.outboxEvent.findFirstOrThrow({
        where: { aggregateId: job.jobId, type: 'job.completed' },
      });
      await t.app.get(EventHandlersRegistry).dispatch('job.completed', {
        outboxId: event.id.toString(),
        aggregateId: job.jobId,
        payload: event.payload as never,
      });
      expect(await commissionsOf(job.worker.id)).toHaveLength(1);
      expect(await ledgerBalance(t, job.worker.id)).toBe('19.50');
    });

    it('si llega tarde y su periodo ya cerró, va al periodo abierto actual', async () => {
      const job = await assignJob(t);
      await completeJob(t, job);
      await waitCommission(job.worker.id);
      const ledger = t.app.get(BillingLedgerService);

      // Un trabajo que terminó la semana pasada, cuyo periodo ya está cerrado.
      const lastWeek = new Date(Date.now() - 7 * 24 * 3600_000);
      const closed = await t.prisma.$transaction((tx) =>
        ledger.lockPeriodAt(tx, job.worker.id, lastWeek),
      );
      await t.prisma.billingPeriod.update({
        where: { id: closed.id },
        data: { status: 'pagado', closedAt: new Date() },
      });
      const late = await assignJob(t, { worker: job.worker, categoryId: job.categoryId });
      const result = await ledger.recordCommission({
        jobId: late.jobId,
        workerId: job.worker.id,
        // Los montos reales del trabajo (la consistencia los compara con jobs.final_price_bs).
        finalPriceBs: '150.00',
        commissionBs: '19.50',
        completedAt: lastWeek,
      });
      expect(result.inserted).toBe(true);
      expect(result.periodId).not.toBe(closed.id);
      const current = await t.prisma.billingPeriod.findUniqueOrThrow({
        where: { id: result.periodId ?? '' },
      });
      expect(current.status).toBe('abierto');
      expect(current.commissionBs.toFixed(2)).toBe('39.00');
      // El cerrado no cambió.
      const after = await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: closed.id } });
      expect(after.commissionBs.toFixed(2)).toBe('0.00');
      // Se cancela el trabajo de prueba que quedó asignado (no genera comisión).
      await request(t.app.getHttpServer())
        .post(`/jobs/${late.jobId}/cancel`)
        .set(...bearer(late.employer.accessToken))
        .send({ reason: 'otro' })
        .expect(200);
    });

    it('cancelados y disputados sin resolver no generan comisión', async () => {
      const cancelled = await assignJob(t);
      await request(t.app.getHttpServer())
        .post(`/jobs/${cancelled.jobId}/cancel`)
        .set(...bearer(cancelled.employer.accessToken))
        .send({ reason: 'cambio_de_planes' })
        .expect(200);

      const disputed = await assignJob(t);
      for (const step of ['on-the-way', 'start', 'finish']) {
        await request(t.app.getHttpServer())
          .post(`/jobs/${disputed.jobId}/${step}`)
          .set(...bearer(disputed.worker.accessToken))
          .expect(200);
      }
      await request(t.app.getHttpServer())
        .post(`/jobs/${disputed.jobId}/dispute`)
        .set(...bearer(disputed.employer.accessToken))
        .send({})
        .expect(200);
      // Más que el plazo de autoconfirmación de e2e (3 s): sigue sin comisión.
      await new Promise((r) => setTimeout(r, 3500));
      expect(await commissionsOf(cancelled.worker.id)).toHaveLength(0);
      expect(await commissionsOf(disputed.worker.id)).toHaveLength(0);
    });
  });

  /**
   * Un instante dentro de una semana pasada propia de cada prueba (miércoles 12:00 en La Paz),
   * para que el reloj simulado del cron no cierre periodos de otras pruebas.
   */
  const pastWeek = (n: number): Date =>
    new Date(Date.parse('2025-03-05T16:00:00.000Z') + n * 7 * 24 * 3600_000);

  /** Periodo de esa semana con una comisión real (trabajo asignado, sin terminar). */
  const periodWithCommission = async (week: number) => {
    const job = await assignJob(t);
    const ledger = t.app.get(BillingLedgerService);
    const result = await ledger.recordCommission({
      jobId: job.jobId,
      workerId: job.worker.id,
      finalPriceBs: '150.00',
      commissionBs: '19.50',
      completedAt: pastWeek(week),
    });
    const period = await t.prisma.billingPeriod.findUniqueOrThrow({
      where: { id: result.periodId ?? '' },
    });
    return { job, period };
  };

  const catchUp = (now: Date) => t.app.get(BillingCatchUpService).run(now);
  const minutes = (d: Date, m: number) => new Date(d.getTime() + m * 60_000);

  describe('corte y avisos (cron de puesta al día, ADR-0036)', () => {
    it('cierra al pasar el fin, avisa con referencia y una segunda corrida no hace nada', async () => {
      const { job, period } = await periodWithCommission(0);
      const live = await connectSocket(t, job.worker.accessToken);
      try {
        // Un minuto antes del corte sigue abierto.
        await catchUp(minutes(period.endAt, -1));
        expect(
          (await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: period.id } })).status,
        ).toBe('abierto');

        const first = await catchUp(minutes(period.endAt, 5));
        expect(first.closed).toBeGreaterThanOrEqual(1);
        const closed = await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: period.id } });
        expect(closed.status).toBe('cerrado_pendiente');
        expect(closed.closedAt).not.toBeNull();

        const due = await live.next('billing:due', (p) => p.periodId === period.id);
        expect(due).toEqual({
          periodId: period.id,
          kind: 'cierre',
          amountBs: '19.50',
          paymentReference: period.paymentReference,
          dueAt: period.dueAt.toISOString(),
        });
        const notice = await waitFor(
          async () =>
            (await t.prisma.notification.findFirst({
              where: { userId: job.worker.id, type: 'billing_due' },
            })) ?? undefined,
          { what: 'el aviso del corte' },
        );
        expect(notice.body).toContain(period.paymentReference);
        expect(notice.body).toContain('Bs 19,50');

        // El cron corre otra vez (y otra): nada cambia ni se repite.
        await catchUp(minutes(period.endAt, 5));
        await catchUp(minutes(period.endAt, 65));
        expect(await t.prisma.billingNotice.count({ where: { periodId: period.id } })).toBe(1);
        expect(
          await t.prisma.outboxEvent.count({
            where: { type: 'billing.notice', aggregateId: period.id },
          }),
        ).toBe(1);
        await new Promise((r) => setTimeout(r, 300));
        expect(
          await t.prisma.notification.count({
            where: { userId: job.worker.id, type: 'billing_due' },
          }),
        ).toBe(1);
      } finally {
        live.close();
      }
    });

    it('recuerda la víspera y el día del vencimiento a las 09:00 locales, una sola vez cada uno', async () => {
      const { job, period } = await periodWithCommission(1);
      await catchUp(minutes(period.endAt, 5));
      // dueAt es jueves 00:00 local: martes 09:00 = dueAt − 2 días + 9 h.
      const tuesday9 = new Date(period.dueAt.getTime() - 2 * 24 * 3600_000 + 9 * 3600_000);
      await catchUp(minutes(tuesday9, -1));
      expect(await t.prisma.billingNotice.count({ where: { periodId: period.id } })).toBe(1);
      await catchUp(minutes(tuesday9, 5));
      await catchUp(minutes(tuesday9, 65));
      const wednesday9 = new Date(tuesday9.getTime() + 24 * 3600_000);
      await catchUp(minutes(wednesday9, 5));
      await catchUp(minutes(wednesday9, 5));
      const kinds = (await t.prisma.billingNotice.findMany({ where: { periodId: period.id } })).map(
        (n) => n.kind,
      );
      expect(kinds.sort()).toEqual(['cierre', 'dia', 'vispera']);
      const reminders = await waitFor(
        async () => {
          const rows = await t.prisma.notification.findMany({
            where: { userId: job.worker.id, type: 'billing_reminder' },
            orderBy: { createdAt: 'asc' },
          });
          return rows.length >= 2 ? rows : undefined;
        },
        { what: 'los recordatorios' },
      );
      expect(reminders.map((r) => r.title)).toEqual([
        'Mañana vence tu comisión',
        'Hoy vence tu comisión',
      ]);
    });

    it('una semana sin deuda se cierra como pagada y no avisa', async () => {
      const worker = await login(t);
      const ledger = t.app.get(BillingLedgerService);
      // Periodo creado sin trabajos (lo crearía, por ejemplo, un pago anticipado).
      const empty = await t.prisma.$transaction((tx) =>
        ledger.lockPeriodAt(tx, worker.user.id, pastWeek(2)),
      );
      await catchUp(minutes(empty.endAt, 5));
      const after = await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: empty.id } });
      expect(after.status).toBe('pagado');
      expect(await t.prisma.billingNotice.count({ where: { periodId: empty.id } })).toBe(0);
    });

    it('una comisión que entra durante el cierre queda en un solo periodo', async () => {
      const ledger = t.app.get(BillingLedgerService);
      for (let i = 0; i < 5; i++) {
        const job = await assignJob(t);
        // El periodo de esa semana existe y está abierto, sin movimientos.
        const target = await t.prisma.$transaction((tx) =>
          ledger.lockPeriodAt(tx, job.worker.id, pastWeek(3 + i)),
        );
        const [result] = await Promise.all([
          ledger.recordCommission({
            jobId: job.jobId,
            workerId: job.worker.id,
            finalPriceBs: '150.00',
            commissionBs: '19.50',
            completedAt: pastWeek(3 + i),
          }),
          catchUp(minutes(target.endAt, 5)),
        ]);
        const entries = await t.prisma.ledgerEntry.findMany({ where: { jobId: job.jobId } });
        expect(entries).toHaveLength(1);
        expect(entries[0]?.periodId).toBe(result.periodId);
        const closed = await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: target.id } });
        if (result.periodId === target.id) {
          // Entró antes del cierre: el corte la incluye.
          expect(closed.status).toBe('cerrado_pendiente');
          expect(closed.commissionBs.toFixed(2)).toBe('19.50');
        } else {
          // Vio el periodo cerrado: fue al periodo abierto actual.
          expect(closed.status).toBe('pagado');
          const current = await t.prisma.billingPeriod.findUniqueOrThrow({
            where: { id: result.periodId ?? '' },
          });
          expect(current.status).toBe('abierto');
        }
      }
    });
  });
});

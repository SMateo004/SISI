import { randomUUID } from 'node:crypto';
import { BillingCatchUpService } from '../src/billing/billing-catchup.service';
import { BillingLedgerService } from '../src/billing/billing-ledger.service';
import { DebtCapService } from '../src/billing/debt-cap.service';
import { connectSocket } from './utils/socket';
import { EventHandlersRegistry } from '../src/outbox/event-handlers.registry';
import type { PresignedUploadDto } from '../src/storage/dto/upload.dto';
import { ledgerBalance, ledgerMismatches } from './utils/billing';
import { fakeJpeg, putPresigned } from './utils/upload';
import { assignJob, completeJob, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { createApprovedWorker, makeAvailable } from './utils/workers';
import {
  bearer,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueSuffix,
  waitFor,
} from './utils/test-app';
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

  describe('vencimiento y bloqueo por deuda (R7.7, ADR-0038)', () => {
    it('vencido sin pagar: bloqueado_deuda, modo employer, fuera del matching y account:blocked', async () => {
      const { job, period } = await periodWithCommission(10);
      const worker = job.worker;
      const live = await connectSocket(t, worker.accessToken);
      try {
        await catchUp(minutes(period.endAt, 5));
        // Antes de la fecha límite no pasa nada.
        await catchUp(minutes(period.dueAt, -1));
        expect(
          (await t.prisma.workerProfile.findUniqueOrThrow({ where: { userId: worker.id } })).status,
        ).toBe('aprobado');

        const result = await catchUp(minutes(period.dueAt, 5));
        expect(result.overdue).toBeGreaterThanOrEqual(1);
        expect(
          (await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: period.id } })).status,
        ).toBe('vencido');

        expect(await live.next('account:blocked')).toEqual({
          reason: 'deuda',
          status: 'bloqueado_deuda',
        });
        const user = await t.prisma.user.findUniqueOrThrow({
          where: { id: worker.id },
          include: { workerProfile: true },
        });
        expect(user.workerProfile?.status).toBe('bloqueado_deuda');
        expect(user.activeMode).toBe('employer');
        const location = await t.prisma.workerLocation.findUnique({
          where: { workerId: worker.id },
        });
        expect(location?.available ?? false).toBe(false);

        // El interruptor explica el motivo y lleva a pagar; el modo empleador sigue funcionando.
        const denied = await request(t.app.getHttpServer())
          .patch('/me/mode')
          .set(...bearer(worker.accessToken))
          .send({ mode: 'worker' })
          .expect(409);
        expect(denied.body).toMatchObject({
          code: 'WORKER_BLOCKED_DEBT',
          nextAction: 'PAY_COMMISSION',
        });
        await request(t.app.getHttpServer())
          .patch('/me/mode')
          .set(...bearer(worker.accessToken))
          .send({ mode: 'employer' })
          .expect(200);
        // Fuera del matching: no puede volver a estar disponible.
        await request(t.app.getHttpServer())
          .put('/worker/availability')
          .set(...bearer(worker.accessToken))
          .send({ available: true, latitude: -17.7834, longitude: -63.1821 })
          .expect(409);

        const notices = await waitFor(
          async () => {
            const rows = await t.prisma.notification.findMany({
              where: { userId: worker.id, type: 'account_blocked' },
            });
            return rows.length > 0 ? rows : undefined;
          },
          { what: 'el aviso de bloqueo' },
        );
        expect(notices[0]?.title).toBe('Tu modo trabajador está bloqueado por deuda');

        // El cron corre de nuevo: no hay otro bloqueo ni otro aviso.
        await catchUp(minutes(period.dueAt, 65));
        await new Promise((r) => setTimeout(r, 300));
        expect(
          await t.prisma.notification.count({
            where: { userId: worker.id, type: 'account_blocked' },
          }),
        ).toBe(1);
        expect(
          await t.prisma.workerStatusEvent.count({
            where: { workerId: worker.id, event: 'BLOCK_FOR_DEBT' },
          }),
        ).toBe(1);
      } finally {
        live.close();
      }
    });
  });

  /**
   * Deuda previa en el periodo abierto con un ajuste (atajo de prueba: el endpoint de ajustes
   * llega con los pagos). No cambia la consistencia, que solo mira comisiones.
   */
  const addDebt = async (workerId: string, amountBs: string) => {
    const admin = await loginAsAdmin(t);
    const ledger = t.app.get(BillingLedgerService);
    await t.prisma.$transaction(async (tx) => {
      const period = await ledger.lockPeriodAt(tx, workerId, new Date());
      await tx.ledgerEntry.create({
        data: {
          workerId,
          cityId: period.cityId,
          periodId: period.id,
          type: 'ajuste',
          amountBs,
          reason: 'Deuda de prueba',
          createdById: admin.user.id,
        },
      });
    });
  };

  describe('tope de deuda (R7.5, ADR-0038)', () => {
    it('sobre 150 Bs: un solo aviso y queda fuera de las solicitudes nuevas', async () => {
      const job = await assignJob(t);
      const capped = job.worker;
      await addDebt(capped.id, '140.00');
      await completeJob(t, job);
      await waitCommission(capped.id);
      expect(await ledgerBalance(t, capped.id)).toBe('159.50');

      const notice = await waitFor(
        async () =>
          (await t.prisma.notification.findFirst({
            where: { userId: capped.id, type: 'billing_cap_reached' },
          })) ?? undefined,
        { what: 'el aviso del tope' },
      );
      expect(notice.title).toBe('Paga para seguir recibiendo solicitudes');
      // Otro cambio de saldo con el tope ya alcanzado no repite el aviso.
      await t.app.get(EventHandlersRegistry).dispatch('billing.balance_changed', {
        outboxId: '0',
        aggregateId: capped.id,
        payload: { workerId: capped.id, cause: 'ajuste' },
      });
      expect(
        await t.prisma.notification.count({
          where: { userId: capped.id, type: 'billing_cap_reached' },
        }),
      ).toBe(1);
      // Sigue aprobado: el tope no bloquea la cuenta.
      expect(
        (await t.prisma.workerProfile.findUniqueOrThrow({ where: { userId: capped.id } })).status,
      ).toBe('aprobado');

      // Otro trabajador igual de cerca recibe la solicitud; el del tope no.
      const category = await t.prisma.category.findUniqueOrThrow({
        where: { id: job.categoryId },
      });
      const other = await createApprovedWorker(t, { categorySlugs: [category.slug] });
      await makeAvailable(t, other, eastOf(CENTRO, 300));
      const employer = await login(t);
      const requestId = await publishRequest(t, employer.accessToken, {
        categoryId: job.categoryId,
      });
      await waitNotified(t, requestId, other.id);
      expect(
        await t.prisma.requestNotification.findUnique({
          where: { requestId_workerId: { requestId, workerId: capped.id } },
        }),
      ).toBeNull();
      expect(await t.app.get(DebtCapService).ineligible([capped.id, other.id])).toEqual(
        new Set([capped.id]),
      );
    });
  });

  const payment = (
    token: string,
    body: Record<string, unknown>,
    key: string | null = `pago-${uniqueSuffix()}`,
  ) => {
    const req = request(t.app.getHttpServer())
      .post('/admin/billing/payments')
      .set(...bearer(token));
    if (key) req.set('Idempotency-Key', key);
    return req.send(body);
  };

  const adjustment = (
    token: string,
    body: Record<string, unknown>,
    key = `ajuste-${uniqueSuffix()}`,
  ) =>
    request(t.app.getHttpServer())
      .post('/admin/billing/adjustments')
      .set(...bearer(token))
      .set('Idempotency-Key', key)
      .send(body);

  const statusOf = async (workerId: string) =>
    (await t.prisma.workerProfile.findUniqueOrThrow({ where: { userId: workerId } })).status;

  /** Trabajador con un periodo vencido de 19,50 (semana propia) y ya bloqueado. */
  const blockedWorker = async (week: number) => {
    const { job, period } = await periodWithCommission(week);
    await catchUp(minutes(period.endAt, 5));
    await catchUp(minutes(period.dueAt, 5));
    await waitFor(
      async () => ((await statusOf(job.worker.id)) === 'bloqueado_deuda' ? true : undefined),
      { what: 'el bloqueo por deuda' },
    );
    return { job, period, worker: job.worker };
  };

  describe('pagos (R7.4, ADR-0037)', () => {
    it('un pago completo deja el periodo pagado, desbloquea y avisa con account:unblocked', async () => {
      const admin = await loginAsAdmin(t);
      const { period, worker } = await blockedWorker(20);
      const live = await connectSocket(t, worker.accessToken);
      try {
        const res = await payment(admin.accessToken, {
          workerId: worker.id,
          amountBs: '19.50',
          method: 'qr_transferencia',
          paidAt: new Date().toISOString(),
          reference: period.paymentReference,
        }).expect(200);
        expect(res.body).toMatchObject({
          workerId: worker.id,
          amountBs: '19.50',
          balanceBs: '0.00',
          allocations: [
            {
              periodId: period.id,
              paymentReference: period.paymentReference,
              amountBs: '19.50',
              status: 'pagado',
            },
          ],
        });
        expect(await live.next('account:unblocked')).toEqual({ status: 'aprobado' });
        expect(await statusOf(worker.id)).toBe('aprobado');
        // No cambia de modo solo: usa el interruptor.
        expect(
          (await t.prisma.user.findUniqueOrThrow({ where: { id: worker.id } })).activeMode,
        ).toBe('employer');
        const after = await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: period.id } });
        expect(after.status).toBe('pagado');
        expect(after.paidAt).not.toBeNull();
        const paid = await waitFor(
          async () =>
            (await t.prisma.notification.findFirst({
              where: { userId: worker.id, type: 'billing_payment_registered' },
            })) ?? undefined,
          { what: 'el aviso del pago' },
        );
        expect(paid.body).toBe('Recibimos Bs 19,50. Estás al día.');
      } finally {
        live.close();
      }
    });

    it('un pago parcial reduce el saldo pero no desbloquea', async () => {
      const admin = await loginAsAdmin(t);
      const { period, worker } = await blockedWorker(21);
      await payment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '10.00',
        method: 'efectivo',
        paidAt: new Date().toISOString(),
      }).expect(200);
      expect(await ledgerBalance(t, worker.id)).toBe('9.50');
      expect(
        (await t.prisma.billingPeriod.findUniqueOrThrow({ where: { id: period.id } })).status,
      ).toBe('vencido');
      await new Promise((r) => setTimeout(r, 500));
      expect(await statusOf(worker.id)).toBe('bloqueado_deuda');
    });

    it('un pago de más cubre lo antiguo y deja saldo a favor en el periodo actual', async () => {
      const admin = await loginAsAdmin(t);
      const { period, worker } = await blockedWorker(22);
      const res = await payment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '50.00',
        method: 'qr_transferencia',
        paidAt: new Date().toISOString(),
      }).expect(200);
      const body = res.body as {
        allocations: { periodId: string; amountBs: string }[];
        balanceBs: string;
      };
      expect(body.allocations.map((a) => a.amountBs)).toEqual(['19.50', '30.50']);
      expect(body.allocations[0]?.periodId).toBe(period.id);
      expect(body.balanceBs).toBe('-30.50');
      const current = await t.prisma.billingPeriod.findUniqueOrThrow({
        where: { id: body.allocations[1]?.periodId ?? '' },
      });
      expect(current.status).toBe('abierto');
    });

    it('doble envío con la misma Idempotency-Key: un solo pago y la misma respuesta', async () => {
      const admin = await loginAsAdmin(t);
      const { worker } = await blockedWorker(23);
      const body = {
        workerId: worker.id,
        amountBs: '19.50',
        method: 'qr_transferencia',
        paidAt: '2026-10-17T12:00:00.000Z',
      };
      const key = `doble-${uniqueSuffix()}`;
      const [a, b] = await Promise.all([
        payment(admin.accessToken, body, key),
        payment(admin.accessToken, body, key),
      ]);
      expect([a.status, b.status]).toEqual([200, 200]);
      expect(a.body).toEqual(b.body);
      expect(await t.prisma.payment.count({ where: { workerId: worker.id } })).toBe(1);
      expect(await ledgerBalance(t, worker.id)).toBe('0.00');
      // Un reintento después también devuelve lo mismo.
      const retry = await payment(admin.accessToken, body, key).expect(200);
      expect(retry.body).toEqual(a.body);
      // La misma clave con otro cuerpo se rechaza; sin clave, también.
      const reused = await payment(admin.accessToken, { ...body, amountBs: '1.00' }, key).expect(
        409,
      );
      expect(reused.body).toMatchObject({ code: 'IDEMPOTENCY_KEY_REUSED' });
      const missing = await payment(admin.accessToken, body, null).expect(400);
      expect(missing.body).toMatchObject({ code: 'IDEMPOTENCY_KEY_REQUIRED' });
      expect(await t.prisma.payment.count({ where: { workerId: worker.id } })).toBe(1);
    });

    it('un admin no registra pagos ni ajustes sobre su propia cuenta; un no admin no registra nada', async () => {
      const admin = await loginAsAdmin(t);
      await t.prisma.workerProfile.upsert({
        where: { userId: admin.user.id },
        create: { userId: admin.user.id },
        update: {},
      });
      const self = await payment(admin.accessToken, {
        workerId: admin.user.id,
        amountBs: '10.00',
        method: 'efectivo',
        paidAt: new Date().toISOString(),
      }).expect(403);
      expect(self.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });
      const selfAdjust = await adjustment(admin.accessToken, {
        workerId: admin.user.id,
        amountBs: '-10.00',
        reason: 'Me perdono la deuda',
      }).expect(403);
      expect(selfAdjust.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });

      const { job } = await periodWithCommission(24);
      const worker = job.worker;
      const intruder = await login(t);
      await payment(intruder.accessToken, {
        workerId: worker.id,
        amountBs: '19.50',
        method: 'efectivo',
        paidAt: new Date().toISOString(),
      }).expect(403);
      await adjustment(intruder.accessToken, {
        workerId: worker.id,
        amountBs: '-19.50',
        reason: 'Intento sin permiso',
      }).expect(403);
      expect(await ledgerBalance(t, worker.id)).toBe('19.50');
    });

    it('ajustes: a favor desbloquea; en contra de un periodo pagado lo vuelve a vencido', async () => {
      const admin = await loginAsAdmin(t);
      const { period, worker } = await blockedWorker(25);
      const commission = await t.prisma.ledgerEntry.findFirstOrThrow({
        where: { periodId: period.id, type: 'comision' },
      });
      const credit = await adjustment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '-19.50',
        reason: 'Comisión cobrada por error',
        correctsEntryId: commission.id.toString(),
      }).expect(200);
      expect(credit.body).toMatchObject({
        periodId: period.id,
        amountBs: '-19.50',
        periodStatus: 'pagado',
        balanceBs: '0.00',
      });
      await waitFor(async () => ((await statusOf(worker.id)) === 'aprobado' ? true : undefined), {
        what: 'el desbloqueo por ajuste',
      });
      const debit = await adjustment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '19.50',
        reason: 'El ajuste anterior fue un error',
        periodId: period.id,
      }).expect(200);
      expect(debit.body).toMatchObject({ periodStatus: 'vencido', balanceBs: '19.50' });
      await waitFor(
        async () => ((await statusOf(worker.id)) === 'bloqueado_deuda' ? true : undefined),
        { what: 'el nuevo bloqueo' },
      );
      // Sin motivo no hay ajuste.
      await adjustment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '-1.00',
        reason: '',
      }).expect(400);
      const view = await request(t.app.getHttpServer())
        .get(`/admin/billing/workers/${worker.id}`)
        .set(...bearer(admin.accessToken))
        .expect(200);
      expect((view.body as { entries: { type: string }[] }).entries.map((e) => e.type)).toEqual([
        'ajuste',
        'ajuste',
        'comision',
      ]);
    });

    it('pagar libera el tope de inmediato', async () => {
      const admin = await loginAsAdmin(t);
      const job = await assignJob(t);
      await addDebt(job.worker.id, '140.00');
      await completeJob(t, job);
      await waitCommission(job.worker.id);
      const cap = t.app.get(DebtCapService);
      expect(await cap.ineligible([job.worker.id])).toEqual(new Set([job.worker.id]));
      await payment(admin.accessToken, {
        workerId: job.worker.id,
        amountBs: '9.50',
        method: 'qr_transferencia',
        paidAt: new Date().toISOString(),
      }).expect(200);
      expect(await ledgerBalance(t, job.worker.id)).toBe('150.00');
      expect(await cap.ineligible([job.worker.id])).toEqual(new Set());
      await waitFor(
        async () =>
          (await t.prisma.workerProfile.findUniqueOrThrow({ where: { userId: job.worker.id } }))
            .debtCapReachedAt === null
            ? true
            : undefined,
        { what: 'la marca del tope limpia' },
      );
    });
  });

  /** Sube una imagen con la URL prefirmada que devuelve `path` y devuelve la clave. */
  const upload = async (token: string, path: string, extra: Record<string, unknown> = {}) => {
    const file = fakeJpeg(4096);
    const presigned = (
      await request(t.app.getHttpServer())
        .post(path)
        .set(...bearer(token))
        .send({ contentType: 'image/jpeg', sizeBytes: file.length, ...extra })
        .expect((r) => {
          if (r.status !== 200 && r.status !== 201) throw new Error(`upload-url ${r.status}`);
        })
    ).body as PresignedUploadDto;
    expect(await putPresigned(presigned, file)).toBe(200);
    return presigned.key;
  };

  describe('QR y comprobantes (ADR-0037)', () => {
    it('el admin carga el QR de cobro de la empresa', async () => {
      const admin = await loginAsAdmin(t);
      const key = await upload(admin.accessToken, '/admin/billing/qr/upload-url');
      expect(key.startsWith('company/')).toBe(true);
      const res = await request(t.app.getHttpServer())
        .put('/admin/billing/qr')
        .set(...bearer(admin.accessToken))
        .send({ key })
        .expect(200);
      expect((res.body as { qrUrl: string }).qrUrl).toMatch(/X-Amz-Signature/);
    });

    it('el trabajador envía su comprobante: pendiente, sin tocar el ledger; el admin lo registra', async () => {
      const admin = await loginAsAdmin(t);
      const { job, period } = await periodWithCommission(30);
      const worker = job.worker;
      const key = await upload(worker.accessToken, '/me/billing/submissions/upload-url');
      expect(key.startsWith(`receipts/${worker.id}/`)).toBe(true);
      const sent = await request(t.app.getHttpServer())
        .post('/me/billing/submissions')
        .set(...bearer(worker.accessToken))
        .send({ receiptKey: key, declaredAmountBs: '19.50', note: 'Pagué por QR' })
        .expect(201);
      const submission = sent.body as { id: string; status: string; receiptUrl: string };
      expect(submission.status).toBe('pendiente');
      expect(submission.receiptUrl).toMatch(/X-Amz-Signature/);
      expect(await ledgerBalance(t, worker.id)).toBe('19.50');

      // Otro trabajador no puede usar mi archivo; alguien sin perfil de trabajador no envía.
      const other = await createApprovedWorker(t);
      const stolen = await request(t.app.getHttpServer())
        .post('/me/billing/submissions')
        .set(...bearer(other.accessToken))
        .send({ receiptKey: key })
        .expect(403);
      expect(stolen.body).toMatchObject({ code: 'UPLOAD_KEY_FORBIDDEN' });
      const stranger = await login(t);
      const notWorker = await request(t.app.getHttpServer())
        .post('/me/billing/submissions/upload-url')
        .set(...bearer(stranger.accessToken))
        .send({ contentType: 'image/jpeg', sizeBytes: 100 })
        .expect(403);
      expect(notWorker.body).toMatchObject({ code: 'NOT_A_WORKER' });
      // Y no ve los comprobantes de otro.
      const othersList = await request(t.app.getHttpServer())
        .get('/me/billing/submissions')
        .set(...bearer(other.accessToken))
        .expect(200);
      expect(othersList.body).toEqual([]);

      const pending = await request(t.app.getHttpServer())
        .get('/admin/billing/submissions')
        .set(...bearer(admin.accessToken))
        .expect(200);
      expect((pending.body as { id: string }[]).map((s) => s.id)).toContain(submission.id);

      await payment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '19.50',
        method: 'qr_transferencia',
        paidAt: new Date().toISOString(),
        reference: period.paymentReference,
        submissionId: submission.id,
      }).expect(200);
      const registered = await t.prisma.paymentSubmission.findUniqueOrThrow({
        where: { id: submission.id },
      });
      expect(registered.status).toBe('registrado');
      const paid = await t.prisma.payment.findFirstOrThrow({ where: { workerId: worker.id } });
      expect(paid.receiptKey).toBe(key);
      expect(paid.submissionId).toBe(submission.id);
      // Ya registrado, no se vuelve a usar ni se rechaza.
      await payment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '1.00',
        method: 'qr_transferencia',
        paidAt: new Date().toISOString(),
        submissionId: submission.id,
      }).expect(409);
      await request(t.app.getHttpServer())
        .post(`/admin/billing/submissions/${submission.id}/reject`)
        .set(...bearer(admin.accessToken))
        .send({ note: 'Ilegible' })
        .expect(409);
    });

    it('un comprobante ilegible se rechaza con motivo', async () => {
      const admin = await loginAsAdmin(t);
      const worker = await createApprovedWorker(t);
      const key = await upload(worker.accessToken, '/me/billing/submissions/upload-url');
      const sent = (
        await request(t.app.getHttpServer())
          .post('/me/billing/submissions')
          .set(...bearer(worker.accessToken))
          .send({ receiptKey: key })
          .expect(201)
      ).body as { id: string };
      const rejected = await request(t.app.getHttpServer())
        .post(`/admin/billing/submissions/${sent.id}/reject`)
        .set(...bearer(admin.accessToken))
        .send({ note: 'No se lee el monto.' })
        .expect(200);
      expect(rejected.body).toMatchObject({
        status: 'rechazado',
        reviewNote: 'No se lee el monto.',
      });
      const mine = await request(t.app.getHttpServer())
        .get('/me/billing/submissions')
        .set(...bearer(worker.accessToken))
        .expect(200);
      expect((mine.body as { status: string }[])[0]?.status).toBe('rechazado');
    });
  });

  const getAs = async <T>(token: string, path: string): Promise<T> =>
    (
      await request(t.app.getHttpServer())
        .get(path)
        .set(...bearer(token))
        .expect(200)
    ).body as T;

  describe('ganancias del trabajador (R8)', () => {
    it('un trabajo de 150 Bs: el resumen muestra bruto 150,00, comisión 19,50 y neto 130,50', async () => {
      const job = await assignJob(t);
      await completeJob(t, job);
      await waitCommission(job.worker.id);
      const summary = await getAs<{
        currentPeriod: Record<string, unknown>;
        balanceBs: unknown;
        debtCap: Record<string, unknown>;
        overdue: boolean;
        blocked: boolean;
      }>(job.worker.accessToken, '/me/earnings/summary');
      expect(summary.currentPeriod).toMatchObject({
        grossBs: '150.00',
        commissionBs: '19.50',
        netBs: '130.50',
      });
      expect(summary.balanceBs).toBe('19.50');
      // Montos como texto, nunca como número.
      expect(typeof summary.balanceBs).toBe('string');
      expect(summary.debtCap).toEqual({
        capBs: '150.00',
        reached: false,
        amountToUnlockBs: '0.00',
      });
      expect([summary.overdue, summary.blocked]).toEqual([false, false]);

      const periods = await getAs<{ items: { commissionBs: string; balanceBs: string }[] }>(
        job.worker.accessToken,
        '/me/earnings/periods',
      );
      expect(periods.items[0]).toMatchObject({ commissionBs: '19.50', balanceBs: '19.50' });
      // El historial de trabajos con comisión (Fase 4) sigue siendo el de /jobs.
      const jobs = await getAs<{ items: { commissionBs: string; netBs: string }[] }>(
        job.worker.accessToken,
        '/jobs?role=worker',
      );
      expect(jobs.items[0]).toMatchObject({ commissionBs: '19.50', netBs: '130.50' });
    });

    it('pay-info: "para ponerte al día" y "para volver a recibir solicitudes"', async () => {
      const { worker, period } = await blockedWorker(31);
      // Además, deuda en el periodo actual que lo deja sobre el tope.
      await addDebt(worker.id, '140.00');
      const info = await getAs<Record<string, unknown>>(worker.accessToken, '/me/billing/pay-info');
      expect(info).toMatchObject({
        catchUpAmountBs: '19.50',
        unlockAmountBs: '9.50',
        totalBalanceBs: '159.50',
        paymentReference: period.paymentReference,
        dueAt: period.dueAt.toISOString(),
        gatewayEnabled: false,
      });
      expect((info.instructions as string[]).join(' ')).toContain(
        `Escribe la referencia ${period.paymentReference} en la glosa`,
      );
      const summary = await getAs<{
        overdue: boolean;
        blocked: boolean;
        overdueOrPendingBs: string;
      }>(worker.accessToken, '/me/earnings/summary');
      expect(summary).toMatchObject({ overdue: true, blocked: true, overdueOrPendingBs: '19.50' });
    });

    it('historial de pagos con periodos y comprobante; cada trabajador ve solo los suyos', async () => {
      const admin = await loginAsAdmin(t);
      const { worker, period } = await blockedWorker(32);
      const receiptKey = await upload(admin.accessToken, '/admin/billing/receipts/upload-url', {
        workerId: worker.id,
      });
      await payment(admin.accessToken, {
        workerId: worker.id,
        amountBs: '19.50',
        method: 'qr_transferencia',
        paidAt: '2026-10-17T13:00:00.000Z',
        reference: period.paymentReference,
        receiptKey,
      }).expect(200);
      const mine = await getAs<{ items: Record<string, unknown>[] }>(
        worker.accessToken,
        '/me/payments',
      );
      expect(mine.items).toHaveLength(1);
      expect(mine.items[0]).toMatchObject({
        amountBs: '19.50',
        paidAt: '2026-10-17T13:00:00.000Z',
        status: 'registrado',
        reference: period.paymentReference,
        periods: [
          { periodId: period.id, paymentReference: period.paymentReference, amountBs: '19.50' },
        ],
      });
      expect(mine.items[0]?.receiptUrl).toMatch(/X-Amz-Signature/);

      const other = await createApprovedWorker(t);
      expect((await getAs<{ items: unknown[] }>(other.accessToken, '/me/payments')).items).toEqual(
        [],
      );
      // Un comprobante de otro trabajador no se puede usar en su pago.
      const wrong = await payment(admin.accessToken, {
        workerId: other.id,
        amountBs: '1.00',
        method: 'qr_transferencia',
        paidAt: new Date().toISOString(),
        receiptKey,
      }).expect(403);
      expect(wrong.body).toMatchObject({ code: 'UPLOAD_KEY_FORBIDDEN' });
    });
  });
});

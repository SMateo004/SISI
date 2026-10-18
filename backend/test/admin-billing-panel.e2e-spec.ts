import request from 'supertest';
import type {
  BalancePreviewDto,
  LedgerPageDto,
  OverdueListDto,
  PanelPeriodPageDto,
} from '../src/billing/dto/billing-panel.dto';
import { BillingCatchUpService } from '../src/billing/billing-catchup.service';
import { BillingLedgerService } from '../src/billing/billing-ledger.service';
import type { PresignedUploadDto } from '../src/storage/dto/upload.dto';
import { auditRows, expectAudited } from './utils/audit';
import { ledgerBalance, ledgerMismatches } from './utils/billing';
import { assignJob } from './utils/jobs';
import { fakeJpeg, putPresigned } from './utils/upload';
import { createApprovedWorker } from './utils/workers';
import {
  type AdminSession,
  bearer,
  createTestApp,
  loginAsAdmin,
  promoteToAdmin,
  type TestApp,
  uniqueSuffix,
  waitFor,
} from './utils/test-app';

/**
 * Cobros en el panel (R7, R8). Semanas de 2024 propias de esta suite: el reloj simulado del
 * cron no toca periodos de otras pruebas (billing.e2e usa 2025).
 */
describe('Cobros en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterEach(async () => {
    expect(await ledgerMismatches(t)).toEqual([]);
  });

  afterAll(async () => {
    await t.close();
  });

  const server = () => t.app.getHttpServer();
  const get = <T>(path: string, query: Record<string, string> = {}) =>
    request(server())
      .get(path)
      .query(query)
      .set(...bearer(admin.accessToken))
      .expect(200)
      .then((r) => r.body as T);
  const post = (
    path: string,
    body: Record<string, unknown>,
    key?: string,
    token = admin.accessToken,
  ) => {
    const req = request(server())
      .post(path)
      .set(...bearer(token));
    if (key) req.set('Idempotency-Key', key);
    return req.send(body);
  };

  /** Miércoles 12:00 en La Paz de la semana n desde el 4 de marzo de 2024 (semana ISO 10). */
  const week = (n: number): Date =>
    new Date(Date.parse('2024-03-06T16:00:00.000Z') + n * 7 * 86_400_000);
  const isoWeek = (n: number) => `2024-W${String(10 + n).padStart(2, '0')}`;

  /**
   * Trabajador con una comisión de 19,50 en cada semana pedida. Cada trabajo de prueba se
   * cancela después (libera al trabajador; la consistencia solo mira su precio final).
   */
  async function workerWithCommissions(weeks: number[]) {
    const first = await assignJob(t);
    const ledger = t.app.get(BillingLedgerService);
    for (const [i, n] of weeks.entries()) {
      const job =
        i === 0
          ? first
          : await assignJob(t, { worker: first.worker, categoryId: first.categoryId });
      await post(
        `/jobs/${job.jobId}/cancel`,
        { reason: 'otro' },
        undefined,
        job.employer.accessToken,
      ).expect(200);
      await ledger.recordCommission({
        jobId: job.jobId,
        workerId: first.worker.id,
        finalPriceBs: '150.00',
        commissionBs: '19.50',
        completedAt: week(n),
      });
    }
    return first.worker;
  }

  const catchUp = (at: Date) => t.app.get(BillingCatchUpService).run(at);
  /** Jueves 00:05 local después del vencimiento de la semana n. */
  const afterDue = (n: number) =>
    new Date(week(n).getTime() + 8 * 86_400_000 - 12 * 3600_000 + 5 * 60_000);

  it('periodos por semana y estado; vencidos con días de atraso; ledger con saldo acumulado', async () => {
    const worker = await workerWithCommissions([0, 1]);
    await catchUp(afterDue(0));
    await waitFor(
      () =>
        t.prisma.workerProfile
          .findUnique({ where: { userId: worker.id } })
          .then((p) => (p?.status === 'bloqueado_deuda' ? p : undefined)),
      { what: 'el bloqueo por deuda' },
    );

    const byWeek = await get<PanelPeriodPageDto>('/admin/billing/periods', { week: isoWeek(0) });
    const mine = byWeek.items.find((p) => p.workerId === worker.id);
    expect(mine).toMatchObject({
      status: 'vencido',
      commissionBs: '19.50',
      balanceBs: '19.50',
      workerPhone: worker.user.phone,
    });
    const closed = await get<PanelPeriodPageDto>('/admin/billing/periods', {
      week: isoWeek(1),
      // Al reloj simulado, la semana 1 todavía no terminó.
      status: 'abierto',
    });
    expect(closed.items.map((p) => p.workerId)).toContain(worker.id);
    await request(server())
      .get('/admin/billing/periods')
      .query({ week: '2024-53x' })
      .set(...bearer(admin.accessToken))
      .expect(400);

    const overdue = await get<OverdueListDto>('/admin/billing/overdue');
    const row = overdue.items.find((p) => p.workerId === worker.id);
    expect(row).toMatchObject({ balanceBs: '19.50', workerStatus: 'bloqueado_deuda' });
    expect(row?.daysLate).toBeGreaterThan(900);

    const ledger = await get<LedgerPageDto>(`/admin/billing/workers/${worker.id}/ledger`);
    expect(ledger.balanceBs).toBe('39.00');
    expect(ledger.items.map((i) => [i.type, i.amountBs, i.runningBs])).toEqual([
      ['comision', '19.50', '39.00'],
      ['comision', '19.50', '19.50'],
    ]);
  });

  it('la vista previa de un pago coincide con el registro; el pago queda auditado una sola vez', async () => {
    const worker = await workerWithCommissions([2, 3]);
    await catchUp(afterDue(3));
    await waitFor(
      () =>
        t.prisma.workerProfile
          .findUnique({ where: { userId: worker.id } })
          .then((p) => (p?.status === 'bloqueado_deuda' ? p : undefined)),
      { what: 'el bloqueo por deuda' },
    );

    const preview = (
      await post('/admin/billing/payments/preview', {
        workerId: worker.id,
        amountBs: '25.00',
      }).expect(200)
    ).body as BalancePreviewDto;
    expect(preview).toMatchObject({
      balanceBeforeBs: '39.00',
      balanceAfterBs: '14.00',
      blockedNow: true,
      // Queda la segunda semana vencida: sigue bloqueado.
      unblocks: false,
    });
    expect(
      preview.allocations.map((a) => [a.amountBs, a.periodBalanceAfterBs, a.statusAfter]),
    ).toEqual([
      ['19.50', '0.00', 'pagado'],
      ['5.50', '14.00', 'vencido'],
    ]);
    const full = (
      await post('/admin/billing/payments/preview', {
        workerId: worker.id,
        amountBs: '39.00',
      }).expect(200)
    ).body as BalancePreviewDto;
    expect(full).toMatchObject({ balanceAfterBs: '0.00', unblocks: true });
    // La vista previa no guarda nada.
    expect(await ledgerBalance(t, worker.id)).toBe('39.00');

    const key = `pago-panel-${uniqueSuffix()}`;
    const body = {
      workerId: worker.id,
      amountBs: '25.00',
      method: 'qr_transferencia',
      paidAt: new Date().toISOString(),
      reference: 'SISI-panel',
    };
    const paid = (await post('/admin/billing/payments', body, key).expect(200)).body as {
      balanceBs: string;
      allocations: { amountBs: string; status: string }[];
    };
    expect(paid.balanceBs).toBe(preview.balanceAfterBs);
    expect(paid.allocations.map((a) => [a.amountBs, a.status])).toEqual(
      preview.allocations.map((a) => [a.amountBs, a.statusAfter]),
    );
    await post('/admin/billing/payments', body, key).expect(200);
    const rows = (await auditRows(t, 'worker', worker.id)).filter(
      (r) => r.action === 'billing.payment',
    );
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({
      adminId: admin.user.id,
      before: { balanceBs: '39.00' },
      after: expect.objectContaining({ balanceBs: '14.00', amountBs: '25.00' }) as unknown,
    });
  });

  it('vista previa y registro de un ajuste, auditado; autorrevisión en la vista previa', async () => {
    const worker = await workerWithCommissions([4]);
    const [entry] = await t.prisma.ledgerEntry.findMany({ where: { workerId: worker.id } });
    const preview = (
      await post('/admin/billing/adjustments/preview', {
        workerId: worker.id,
        amountBs: '-19.50',
        correctsEntryId: entry?.id.toString(),
      }).expect(200)
    ).body as BalancePreviewDto;
    expect(preview).toMatchObject({ balanceBeforeBs: '19.50', balanceAfterBs: '0.00' });
    expect(preview.allocations).toEqual([
      expect.objectContaining({ periodId: entry?.periodId, periodBalanceAfterBs: '0.00' }),
    ]);

    await post(
      '/admin/billing/adjustments',
      {
        workerId: worker.id,
        amountBs: '-19.50',
        reason: 'Comisión cobrada por error',
        correctsEntryId: entry?.id.toString(),
      },
      `ajuste-panel-${uniqueSuffix()}`,
    ).expect(200);
    const row = await expectAudited(t, {
      action: 'billing.adjustment',
      targetType: 'worker',
      targetId: worker.id,
      adminId: admin.user.id,
    });
    expect(row).toMatchObject({
      reason: 'Comisión cobrada por error',
      after: expect.objectContaining({ balanceBs: '0.00' }) as unknown,
    });

    const self = await promoteToAdmin(t, worker.id);
    await post(
      '/admin/billing/payments/preview',
      { workerId: worker.id, amountBs: '1.00' },
      undefined,
      self,
    ).expect(403);
  });

  async function upload(token: string, path: string, extra: Record<string, unknown> = {}) {
    const file = fakeJpeg(2048);
    const presigned = (
      await post(
        path,
        { contentType: 'image/jpeg', sizeBytes: file.length, ...extra },
        undefined,
        token,
      )
    ).body as PresignedUploadDto;
    expect(await putPresigned(presigned, file)).toBe(200);
    return presigned.key;
  }

  it('QR: ver el actual y cambiarlo queda auditado', async () => {
    const key = await upload(admin.accessToken, '/admin/billing/qr/upload-url');
    await request(server())
      .put('/admin/billing/qr')
      .set(...bearer(admin.accessToken))
      .send({ key })
      .expect(200);
    const current = await get<{ qrUrl: string | null }>('/admin/billing/qr');
    expect(current.qrUrl).toMatch(/X-Amz-Signature/);
    const row = await expectAudited(t, {
      action: 'billing.qr_set',
      targetType: 'app_setting',
      targetId: 'billing.payment_qr',
      adminId: admin.user.id,
    });
    expect(row?.after).toEqual({ key });
  });

  it('rechazar un comprobante queda auditado', async () => {
    const worker = await createApprovedWorker(t);
    const key = await upload(worker.accessToken, '/me/billing/submissions/upload-url');
    const sent = (
      await post(
        '/me/billing/submissions',
        { receiptKey: key },
        undefined,
        worker.accessToken,
      ).expect(201)
    ).body as { id: string };
    await post(`/admin/billing/submissions/${sent.id}/reject`, {
      note: 'La foto no se lee.',
    }).expect(200);
    await expectAudited(t, {
      action: 'billing.submission_reject',
      targetType: 'payment_submission',
      targetId: sent.id,
      adminId: admin.user.id,
    });
  });
});

import request from 'supertest';
import { Prisma } from '../src/generated/prisma/client';
import { BillingLedgerService } from '../src/billing/billing-ledger.service';
import { expectAudited } from './utils/audit';
import { assignJob } from './utils/jobs';
import {
  type AdminSession,
  bearer,
  createTestApp,
  loginAsAdmin,
  type TestApp,
  uniqueSuffix,
} from './utils/test-app';

/** Exportación CSV del ledger y de los pagos (Fase 6): cuadra con el ledger. */
describe('Exportación CSV (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  /** Lee el CSV: sin BOM, por líneas y columnas (los datos de prueba no llevan comas). */
  function parse(text: string): Record<string, string>[] {
    expect(text.startsWith('﻿')).toBe(true);
    const [header, ...lines] = text.slice(1).trimEnd().split('\r\n');
    const columns = (header ?? '').split(',');
    return lines.map((l): Record<string, string> =>
      Object.fromEntries(l.split(',').map((v, i): [string, string] => [columns[i] ?? '', v])),
    );
  }

  const download = (path: string, query: Record<string, string>) =>
    request(t.app.getHttpServer())
      .get(path)
      .query(query)
      .set(...bearer(admin.accessToken))
      .buffer(true)
      .parse((res, cb) => {
        let data = '';
        res.setEncoding('utf8');
        res.on('data', (c: string) => (data += c));
        res.on('end', () => {
          cb(null, data);
        });
      });

  it('el CSV del ledger suma lo mismo que el ledger en ese rango, y queda auditado', async () => {
    const from = new Date(Date.now() - 1000);
    const job = await assignJob(t);
    await request(t.app.getHttpServer())
      .post(`/jobs/${job.jobId}/cancel`)
      .set(...bearer(job.employer.accessToken))
      .send({ reason: 'otro' })
      .expect(200);
    await t.app.get(BillingLedgerService).recordCommission({
      jobId: job.jobId,
      workerId: job.worker.id,
      finalPriceBs: '150.00',
      commissionBs: '19.50',
      completedAt: new Date(),
    });
    await request(t.app.getHttpServer())
      .post('/admin/billing/payments')
      .set(...bearer(admin.accessToken))
      .set('Idempotency-Key', `csv-${uniqueSuffix()}`)
      .send({
        workerId: job.worker.id,
        amountBs: '10.00',
        method: 'efectivo',
        paidAt: new Date().toISOString(),
        reference: 'Recibo 15',
      })
      .expect(200);
    const to = new Date(Date.now() + 60_000);
    const range = { from: from.toISOString(), to: to.toISOString() };

    const res = await download('/admin/billing/export/ledger.csv', range).expect(200);
    expect(res.headers['content-type']).toBe('text/csv; charset=utf-8');
    expect(res.headers['content-disposition']).toMatch(/attachment; filename="sisi-ledger-/);
    const rows = parse(res.body as string);
    const csvTotal = rows.reduce((acc, r) => acc.add(r.monto_bs ?? '0'), new Prisma.Decimal(0));
    const [db] = await t.prisma.$queryRaw<{ total: string | null; n: bigint }[]>`
      SELECT SUM(amount_bs)::text AS total, COUNT(*) AS n FROM ledger_entries
      WHERE created_at >= ${from} AND created_at < ${to}`;
    expect(rows).toHaveLength(Number(db?.n ?? 0));
    expect(csvTotal.toFixed(2)).toBe(new Prisma.Decimal(db?.total ?? '0').toFixed(2));
    const mine = rows.filter((r) => r.telefono === job.worker.user.phone.replace('+', "'+"));
    expect(mine.map((r) => [r.tipo, r.monto_bs])).toEqual([
      ['comision', '19.50'],
      ['pago', '-10.00'],
    ]);
    await expectAudited(t, {
      action: 'billing.export_ledger',
      targetType: 'export',
      targetId: `${range.from}/${range.to}`,
      adminId: admin.user.id,
    });

    const payments = parse(
      (await download('/admin/billing/export/payments.csv', range).expect(200)).body as string,
    );
    expect(payments.find((p) => p.referencia === 'Recibo 15')).toMatchObject({
      monto_bs: '10.00',
      metodo: 'efectivo',
    });
  });

  it('rango inválido o demasiado largo: 400', async () => {
    const now = Date.now();
    await download('/admin/billing/export/ledger.csv', {
      from: new Date(now).toISOString(),
      to: new Date(now - 1000).toISOString(),
    }).expect(400);
    await download('/admin/billing/export/ledger.csv', {
      from: new Date(now - 500 * 86_400_000).toISOString(),
      to: new Date(now).toISOString(),
    }).expect(400);
    await download('/admin/billing/export/ledger.csv', { from: 'ayer', to: 'hoy' }).expect(400);
  });
});

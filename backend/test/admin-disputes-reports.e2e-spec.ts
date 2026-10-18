import request from 'supertest';
import type { AdminJobDetailDto } from '../src/jobs/dto/admin-job.dto';
import type {
  AdminReportPageDto,
  ReportDto,
  ResolveReportResultDto,
} from '../src/reports/dto/report.dto';
import { auditRows, expectAudited } from './utils/audit';
import { assignJob, offerOn, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { createApprovedWorker, makeAvailable } from './utils/workers';
import {
  type AdminSession,
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  waitFor,
} from './utils/test-app';

describe('Disputas y reportes en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const server = () => t.app.getHttpServer();
  const post = (token: string, path: string, body: Record<string, unknown> = {}) =>
    request(server())
      .post(path)
      .set(...bearer(token))
      .send(body);

  /** Trabajo en disputa con una contraoferta reemplazada y un mensaje retenido. */
  async function disputedJob() {
    const category = await createCategory(t);
    const worker = await createApprovedWorker(t, { categorySlugs: [category.slug] });
    await makeAvailable(t, worker, eastOf(CENTRO, 300));
    const employer = await login(t);
    const requestId = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await waitNotified(t, requestId, worker.id);
    await offerOn(t, worker, requestId, { type: 'counter', amountBs: '200.00' });
    const offer = await offerOn(t, worker, requestId, { type: 'counter', amountBs: '170.00' });
    const { jobId } = (
      await post(employer.accessToken, `/requests/${requestId}/offers/${offer.id}/accept`).expect(
        200,
      )
    ).body as { jobId: string };
    await post(worker.accessToken, `/jobs/${jobId}/messages`, { body: 'Ya voy en camino.' }).expect(
      201,
    );
    await post(worker.accessToken, `/jobs/${jobId}/messages`, {
      body: 'Te consigo c.o.c.a.i.n.a barata',
    }).expect(201);
    for (const step of ['on-the-way', 'start', 'finish']) {
      await post(worker.accessToken, `/jobs/${jobId}/${step}`).expect(200);
    }
    await post(employer.accessToken, `/jobs/${jobId}/dispute`, {
      note: 'Dejó la cañería goteando.',
    }).expect(200);
    return { jobId, requestId, worker, employer };
  }

  describe('disputas', () => {
    it('el detalle trae la línea de tiempo, todo el chat y las ofertas con su historial', async () => {
      const { jobId, worker, employer } = await disputedJob();
      const detail = (
        await request(server())
          .get(`/admin/jobs/${jobId}`)
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as AdminJobDetailDto;
      expect(detail).toMatchObject({
        status: 'en_curso',
        finalPriceBs: '170.00',
        proposedPriceBs: '150.00',
        disputeNote: 'Dejó la cañería goteando.',
        worker: { id: worker.id },
        employer: { id: employer.user.id },
      });
      expect(detail.timeline.map((e) => e.action)).toEqual([
        'START_TRIP',
        'START_WORK',
        'FINISH',
        'DISPUTE',
      ]);
      expect(detail.chat.map((m) => [m.from, m.status])).toEqual([
        ['worker', 'entregado'],
        ['worker', 'retenido'],
      ]);
      expect(detail.offers).toHaveLength(1);
      expect(detail.offers[0]).toMatchObject({ chosen: true, status: 'aceptada' });
      expect(detail.offers[0]?.history.map((h) => [h.kind, h.amountBs])).toEqual([
        ['creada', '200.00'],
        ['reemplazada', '170.00'],
        ['aceptada', '170.00'],
      ]);
    });

    it('confirmar: terminado con comisión en el ledger; queda auditado', async () => {
      const { jobId, worker } = await disputedJob();
      const res = await post(admin.accessToken, `/admin/jobs/${jobId}/resolve`, {
        decision: 'confirm',
        note: 'Las fotos muestran el trabajo terminado.',
      }).expect(200);
      expect(res.body).toEqual({ status: 'terminado' });
      const commission = await waitFor(
        () =>
          t.prisma.ledgerEntry
            .findFirst({ where: { workerId: worker.id, type: 'comision' } })
            .then((e) => e ?? undefined),
        { what: 'la comisión' },
      );
      expect(commission.amountBs.toFixed(2)).toBe('22.10');
      const row = await expectAudited(t, {
        action: 'dispute.confirm',
        targetType: 'job',
        targetId: jobId,
        adminId: admin.user.id,
      });
      expect(row).toMatchObject({
        before: { status: 'en_curso' },
        after: { status: 'terminado' },
        reason: 'Las fotos muestran el trabajo terminado.',
      });
    });

    it('cancelar: cancelado sin comisión; queda auditado', async () => {
      const { jobId, worker } = await disputedJob();
      const res = await post(admin.accessToken, `/admin/jobs/${jobId}/resolve`, {
        decision: 'cancel',
        note: 'No se hizo el trabajo.',
      }).expect(200);
      expect(res.body).toEqual({ status: 'cancelado' });
      await new Promise((r) => setTimeout(r, 300));
      expect(await t.prisma.ledgerEntry.count({ where: { workerId: worker.id } })).toBe(0);
      await expectAudited(t, {
        action: 'dispute.cancel',
        targetType: 'job',
        targetId: jobId,
        adminId: admin.user.id,
      });
      // Ya resuelta: 409 y sin otra fila.
      await post(admin.accessToken, `/admin/jobs/${jobId}/resolve`, {
        decision: 'confirm',
        note: 'Otra vez.',
      }).expect(409);
      expect(await auditRows(t, 'job', jobId)).toHaveLength(1);
    });
  });

  describe('reportes', () => {
    const report = (token: string, body: Record<string, unknown>) =>
      post(token, '/reports', body)
        .expect(201)
        .then((r) => (r.body as ReportDto).id);
    const resolve = (id: string, valid: boolean) =>
      post(admin.accessToken, `/admin/reports/${id}/resolve`, {
        valid,
        resolution: valid ? 'Se verificó con el chat.' : 'No corresponde.',
      })
        .expect(200)
        .then((r) => r.body as ResolveReportResultDto);

    it('la lista trae el contexto: qué se reportó, quién reportó y a quién', async () => {
      const job = await assignJob(t);
      await post(job.employer.accessToken, `/jobs/${job.jobId}/cancel`, {
        reason: 'no_llega_o_no_responde',
      }).expect(200);
      const id = await report(job.employer.accessToken, {
        targetType: 'job',
        targetId: job.jobId,
        reason: 'no_se_presento',
      });
      const page = (
        await request(server())
          .get('/admin/reports')
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as AdminReportPageDto;
      const item = page.items.find((r) => r.id === id);
      expect(item).toMatchObject({
        reporterId: job.employer.user.id,
        reporterPhone: job.employer.user.phone,
        targetSummary: expect.stringMatching(/^Trabajo de .+ \(cancelado\)$/) as unknown,
        reportedUser: { id: job.worker.id, validReporters: 0, workerStatus: 'aprobado' },
      });
    });

    it('3 válidos de personas distintas suspenden; cada decisión y la suspensión quedan auditadas', async () => {
      const first = await assignJob(t);
      const { worker, categoryId } = first;
      const ids: string[] = [];
      for (let i = 0; i < 3; i++) {
        const job = i === 0 ? first : await assignJob(t, { worker, categoryId });
        await post(job.employer.accessToken, `/jobs/${job.jobId}/cancel`, {
          reason: 'no_llega_o_no_responde',
        }).expect(200);
        ids.push(
          await report(job.employer.accessToken, {
            targetType: 'user',
            targetId: worker.id,
            reason: 'acoso',
          }),
        );
      }
      expect((await resolve(ids[0] ?? '', true)).outcome).toBe('none');
      expect((await resolve(ids[1] ?? '', true)).outcome).toBe('none');
      expect((await resolve(ids[2] ?? '', true)).outcome).toBe('suspend');
      for (const id of ids) {
        await expectAudited(t, {
          action: 'report.valid',
          targetType: 'report',
          targetId: id,
          adminId: admin.user.id,
        });
      }
      const suspension = await expectAudited(t, {
        action: 'report.suspend',
        targetType: 'worker',
        targetId: worker.id,
        adminId: admin.user.id,
      });
      expect(suspension).toMatchObject({
        before: { status: 'aprobado' },
        after: { status: 'suspendido_moderacion' },
      });
    });

    it('descartar queda auditado y no cuenta', async () => {
      const job = await assignJob(t);
      await post(job.employer.accessToken, `/jobs/${job.jobId}/cancel`, {
        reason: 'no_llega_o_no_responde',
      }).expect(200);
      const id = await report(job.employer.accessToken, {
        targetType: 'job',
        targetId: job.jobId,
        reason: 'fraude',
      });
      const result = await resolve(id, false);
      expect(result).toMatchObject({ outcome: 'none', report: { status: 'descartado' } });
      await expectAudited(t, {
        action: 'report.dismiss',
        targetType: 'report',
        targetId: id,
        adminId: admin.user.id,
      });
    });
  });
});

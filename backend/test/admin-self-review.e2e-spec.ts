import request from 'supertest';
import { assignJob } from './utils/jobs';
import { bearer, createTestApp, promoteToAdmin, type TestApp } from './utils/test-app';

/**
 * Ningún admin actúa sobre su propia cuenta (Fase 6): cada acción del panel responde 403
 * SELF_REVIEW_FORBIDDEN cuando la cuenta afectada es la del admin. Pagos, ajustes y
 * comprobantes se prueban en billing.e2e-spec.ts; verificación, suspensión y marca, en sus
 * suites.
 */
describe('Autorrevisión bloqueada (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterAll(async () => {
    await t.close();
  });

  const post = (token: string, path: string, body: Record<string, unknown> = {}) =>
    request(t.app.getHttpServer())
      .post(path)
      .set(...bearer(token))
      .send(body);

  async function disputed() {
    const job = await assignJob(t);
    for (const step of ['on-the-way', 'start', 'finish']) {
      await post(job.worker.accessToken, `/jobs/${job.jobId}/${step}`).expect(200);
    }
    await post(job.employer.accessToken, `/jobs/${job.jobId}/dispute`, {}).expect(200);
    return job;
  }

  it('una disputa de un trabajo propio (como empleador o trabajador): 403', async () => {
    const asEmployer = await disputed();
    const employerAdmin = await promoteToAdmin(t, asEmployer.employer.user.id);
    const res = await post(employerAdmin, `/admin/jobs/${asEmployer.jobId}/resolve`, {
      decision: 'cancel',
      note: 'Me favorezco.',
    }).expect(403);
    expect(res.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });

    const asWorker = await disputed();
    const workerAdmin = await promoteToAdmin(t, asWorker.worker.id);
    await post(workerAdmin, `/admin/jobs/${asWorker.jobId}/resolve`, {
      decision: 'confirm',
      note: 'Me favorezco.',
    }).expect(403);
    // Nada cambió.
    const job = await t.prisma.job.findUniqueOrThrow({ where: { id: asWorker.jobId } });
    expect(job.status).toBe('en_curso');
  });

  it('un reporte en el que es parte (quien reporta o el reportado): 403', async () => {
    const job = await assignJob(t);
    await post(job.employer.accessToken, `/jobs/${job.jobId}/cancel`, {
      reason: 'no_llega_o_no_responde',
    }).expect(200);
    const report = (
      await post(job.employer.accessToken, '/reports', {
        targetType: 'job',
        targetId: job.jobId,
        reason: 'fraude',
      }).expect(201)
    ).body as { id: string };

    const reporterAdmin = await promoteToAdmin(t, job.employer.user.id);
    const asReporter = await post(reporterAdmin, `/admin/reports/${report.id}/resolve`, {
      valid: true,
      resolution: 'Tengo razón.',
    }).expect(403);
    expect(asReporter.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });

    const reportedAdmin = await promoteToAdmin(t, job.worker.id);
    await post(reportedAdmin, `/admin/reports/${report.id}/resolve`, {
      valid: false,
      resolution: 'No fue así.',
    }).expect(403);
    const row = await t.prisma.report.findUniqueOrThrow({ where: { id: report.id } });
    expect(row.status).toBe('pendiente');
  });
});

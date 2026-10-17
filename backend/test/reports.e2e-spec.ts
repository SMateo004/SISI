import request from 'supertest';
import type { ChatPageDto, SentMessageDto } from '../src/chat/dto/chat.dto';
import type { ReportDto, ResolveReportResultDto } from '../src/reports/dto/report.dto';
import { assignJob, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
} from './utils/test-app';
import { createApprovedWorker, makeAvailable } from './utils/workers';

describe('Reportes y suspensión (e2e, ADR-0033)', () => {
  let t: TestApp;
  let admin: Awaited<ReturnType<typeof loginAsAdmin>>;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const post = (token: string, path: string, body: Record<string, unknown> = {}) =>
    request(server())
      .post(path)
      .set(...bearer(token))
      .send(body);

  const report = (token: string, body: Record<string, unknown>) => post(token, '/reports', body);

  const resolve = async (reportId: string, valid: boolean) =>
    (
      await post(admin.accessToken, `/admin/reports/${reportId}/resolve`, {
        valid,
        resolution: valid ? 'Se verificó.' : 'No corresponde.',
      }).expect(200)
    ).body as ResolveReportResultDto;

  it('3 reportes válidos de personas distintas suspenden al trabajador y lo pasan a modo empleador', async () => {
    const first = await assignJob(t);
    const { worker, categoryId } = first;
    const reports: string[] = [];
    for (let i = 0; i < 4; i++) {
      const job = i === 0 ? first : await assignJob(t, { worker, categoryId });
      // El empleador cancela (así el trabajador queda libre) y lo reporta.
      await post(job.employer.accessToken, `/jobs/${job.jobId}/cancel`, {
        reason: 'no_llega_o_no_responde',
      }).expect(200);
      const created = (
        await report(job.employer.accessToken, {
          targetType: i % 2 === 0 ? 'job' : 'user',
          targetId: i % 2 === 0 ? job.jobId : worker.id,
          reason: 'acoso',
          note: 'Me escribió cosas fuera de lugar.',
        }).expect(201)
      ).body as ReportDto;
      expect(created.status).toBe('pendiente');
      reports.push(created.id);
    }
    // El mismo empleador no lo reporta dos veces.
    const dup = await report(first.employer.accessToken, {
      targetType: 'job',
      targetId: first.jobId,
      reason: 'fraude',
    }).expect(409);
    expect(dup.body).toMatchObject({ code: 'ALREADY_REPORTED' });

    // Uno descartado no cuenta; con 2 válidos todavía no se suspende.
    expect((await resolve(reports[0] ?? '', false)).outcome).toBe('none');
    expect((await resolve(reports[1] ?? '', true)).outcome).toBe('none');
    const second = await resolve(reports[2] ?? '', true);
    expect(second.outcome).toBe('none');
    expect(second.report.reportedUser.validReporters).toBe(2);
    await post(admin.accessToken, `/admin/reports/${reports[1] ?? ''}/resolve`, {
      valid: true,
      resolution: 'otra vez',
    }).expect(409);

    const third = await resolve(reports[3] ?? '', true);
    expect(third.outcome).toBe('suspend');
    const user = await t.prisma.user.findUniqueOrThrow({
      where: { id: worker.id },
      include: { workerProfile: true },
    });
    expect(user.workerProfile?.status).toBe('suspendido_moderacion');
    expect(user.activeMode).toBe('employer');
  });

  it('a alguien que solo es empleador se lo marca para revisión', async () => {
    const category = await createCategory(t);
    const workers = [];
    for (let i = 0; i < 3; i++) {
      const w = await createApprovedWorker(t, { categorySlugs: [category.slug] });
      await makeAvailable(t, w, eastOf(CENTRO, 200 + i * 100));
      workers.push(w);
    }
    const employer = await login(t);
    const requestId = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    const ids: string[] = [];
    for (const w of workers) {
      await waitNotified(t, requestId, w.id);
      const created = (
        await report(w.accessToken, {
          targetType: 'request',
          targetId: requestId,
          reason: 'venta_productos',
        }).expect(201)
      ).body as ReportDto;
      ids.push(created.id);
    }
    const outcomes = [];
    for (const id of ids) outcomes.push((await resolve(id, true)).outcome);
    expect(outcomes).toEqual(['none', 'none', 'flag']);
    const user = await t.prisma.user.findUniqueOrThrow({ where: { id: employer.user.id } });
    expect(user.moderationFlaggedAt).not.toBeNull();
    expect(user.activeMode).toBe('employer');
  });

  it('solo se reporta lo que uno conoce; un mensaje reportado se oculta para quien lo reportó', async () => {
    const { jobId, worker, employer } = await assignJob(t);
    const stranger = await login(t);
    const notFound = await report(stranger.accessToken, {
      targetType: 'user',
      targetId: worker.id,
      reason: 'otro',
    }).expect(404);
    expect(notFound.body).toMatchObject({ code: 'REPORT_TARGET_NOT_FOUND' });
    await report(stranger.accessToken, {
      targetType: 'job',
      targetId: jobId,
      reason: 'otro',
    }).expect(404);
    await report(worker.accessToken, {
      targetType: 'user',
      targetId: worker.id,
      reason: 'otro',
    }).expect(404);
    await report(worker.accessToken, {
      targetType: 'job',
      targetId: jobId,
      reason: 'inventado',
    }).expect(400);

    const message = (
      await post(worker.accessToken, `/jobs/${jobId}/messages`, {
        body: 'Págame por fuera.',
      }).expect(201)
    ).body as SentMessageDto;
    // No se reporta un mensaje propio.
    await report(worker.accessToken, {
      targetType: 'chat_message',
      targetId: message.id,
      reason: 'fraude',
    }).expect(404);
    await report(employer.accessToken, {
      targetType: 'chat_message',
      targetId: message.id,
      reason: 'fraude',
    }).expect(201);

    const history = async (token: string) =>
      (
        (
          await request(server())
            .get(`/jobs/${jobId}/messages`)
            .set(...bearer(token))
            .expect(200)
        ).body as ChatPageDto
      ).items.map((m) => m.id);
    expect(await history(employer.accessToken)).not.toContain(message.id);
    expect(await history(worker.accessToken)).toContain(message.id);

    const mine = (
      await request(server())
        .get('/reports/mine')
        .set(...bearer(employer.accessToken))
        .expect(200)
    ).body as ReportDto[];
    expect(mine.map((r) => r.targetType)).toEqual(['chat_message']);
    await request(server())
      .get('/admin/reports')
      .set(...bearer(employer.accessToken))
      .expect(403);
  });
});

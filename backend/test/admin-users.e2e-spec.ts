import request from 'supertest';
import type {
  UserPageDto,
  UserProfileDto,
  WorkerStatusResultDto,
} from '../src/admin-users/dto/admin-users.dto';
import { expectAudited } from './utils/audit';
import { assignJob, completeJob } from './utils/jobs';
import { createApprovedWorker } from './utils/workers';
import {
  type AdminSession,
  bearer,
  createTestApp,
  e164,
  login,
  loginAsAdmin,
  promoteToAdmin,
  type TestApp,
  uniqueSuffix,
} from './utils/test-app';
import { uniquePhone } from './utils/unique';

describe('Usuarios en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const get = (path: string, query: Record<string, string> = {}) =>
    request(t.app.getHttpServer())
      .get(path)
      .query(query)
      .set(...bearer(admin.accessToken));
  const post = (path: string, body: Record<string, unknown>, token = admin.accessToken) =>
    request(t.app.getHttpServer())
      .post(path)
      .set(...bearer(token))
      .send(body);

  it('busca por teléfono (con o sin +591) y por parte del nombre', async () => {
    const session = await login(t);
    const name = `Rosa Quispe ${uniqueSuffix()}`;
    await t.prisma.user.update({ where: { id: session.user.id }, data: { name } });
    const local = session.user.phone.replace('+591', '');

    for (const q of [local, session.user.phone, local.slice(0, 6)]) {
      const page = (await get('/admin/users', { q }).expect(200)).body as UserPageDto;
      expect(page.items.map((u) => u.id)).toContain(session.user.id);
    }
    const byName = (await get('/admin/users', { q: name.slice(5).toUpperCase() }).expect(200))
      .body as UserPageDto;
    expect(byName.items).toEqual([
      expect.objectContaining({ id: session.user.id, name, workerStatus: null, flagged: false }),
    ]);
  });

  it('pagina con cursor sin repetir', async () => {
    const city = await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } });
    await t.prisma.user.createMany({
      data: Array.from({ length: 30 }, () => ({ phone: e164(uniquePhone()), cityId: city.id })),
    });
    const first = (await get('/admin/users').expect(200)).body as UserPageDto;
    expect(first.items).toHaveLength(25);
    const second = (await get('/admin/users', { cursor: first.nextCursor ?? '' }).expect(200))
      .body as UserPageDto;
    const ids = new Set([...first.items, ...second.items].map((u) => u.id));
    expect(ids.size).toBe(first.items.length + second.items.length);
  });

  it('la ficha trae estado, calificaciones, cancelaciones, reportes, trabajos, saldo y periodos', async () => {
    const job = await assignJob(t);
    await completeJob(t, job);
    await post(
      '/reports',
      { targetType: 'job', targetId: job.jobId, reason: 'fraude' },
      job.employer.accessToken,
    ).expect(201);
    // La comisión llega por el outbox.
    await waitForCommission(job.worker.id);

    const profile = (await get(`/admin/users/${job.worker.id}`).expect(200)).body as UserProfileDto;
    expect(profile).toMatchObject({
      id: job.worker.id,
      workerStatus: 'aprobado',
      cancellationsCount: 0,
      jobsCount: 1,
      reportCounts: { pendiente: 1, valido: 0, descartado: 0 },
      worker: expect.objectContaining({ status: 'aprobado', balanceBs: '19.50' }) as unknown,
    });
    expect(profile.jobs[0]).toMatchObject({ id: job.jobId, as: 'worker', status: 'terminado' });
    expect(profile.worker?.periods[0]).toMatchObject({ status: 'abierto', commissionBs: '19.50' });
    expect(profile.reports[0]).toMatchObject({ targetType: 'job', reason: 'fraude' });

    const employer = (await get(`/admin/users/${job.employer.user.id}`).expect(200))
      .body as UserProfileDto;
    expect(employer).toMatchObject({ worker: null, jobsCount: 1 });
    expect(employer.jobs[0]).toMatchObject({ as: 'employer' });

    await get('/admin/users/00000000-0000-4000-8000-000000000000').expect(404);
  });

  async function waitForCommission(workerId: string) {
    for (let i = 0; i < 200; i++) {
      if ((await t.prisma.ledgerEntry.count({ where: { workerId } })) > 0) return;
      await new Promise((r) => setTimeout(r, 25));
    }
    throw new Error('No llegó la comisión');
  }

  it('suspende y reactiva al trabajador con motivo, por la máquina de estados, y lo audita', async () => {
    const worker = await createApprovedWorker(t);
    await t.prisma.user.update({ where: { id: worker.id }, data: { activeMode: 'worker' } });

    const suspended = (
      await post(`/admin/workers/${worker.id}/suspend`, {
        reason: 'Tres reportes de acoso verificados.',
      }).expect(200)
    ).body as WorkerStatusResultDto;
    expect(suspended).toMatchObject({
      status: 'suspendido_moderacion',
      modeForcedToEmployer: true,
    });
    const row = await expectAudited(t, {
      action: 'worker.suspend',
      targetType: 'worker',
      targetId: worker.id,
      adminId: admin.user.id,
    });
    expect(row).toMatchObject({
      before: { status: 'aprobado' },
      after: { status: 'suspendido_moderacion' },
      reason: 'Tres reportes de acoso verificados.',
    });
    // El historial de la máquina también lo registra, con el admin como actor.
    const event = await t.prisma.workerStatusEvent.findFirstOrThrow({
      where: { workerId: worker.id, event: 'SUSPEND' },
    });
    expect(event.actorId).toBe(admin.user.id);

    // Dos veces no: la máquina lo rechaza y no deja fila de auditoría.
    await post(`/admin/workers/${worker.id}/suspend`, { reason: 'Otra vez.' }).expect(409);
    expect(
      await t.prisma.adminAuditLog.count({
        where: { targetId: worker.id, action: 'worker.suspend' },
      }),
    ).toBe(1);

    const lifted = (
      await post(`/admin/workers/${worker.id}/reactivate`, {
        reason: 'Revisado: los reportes eran de la misma persona.',
      }).expect(200)
    ).body as WorkerStatusResultDto;
    expect(lifted.status).toBe('aprobado');
    await expectAudited(t, {
      action: 'worker.reactivate',
      targetType: 'worker',
      targetId: worker.id,
      adminId: admin.user.id,
    });
  });

  it('motivo obligatorio; una cuenta sin perfil de trabajador no se suspende', async () => {
    const worker = await createApprovedWorker(t);
    await post(`/admin/workers/${worker.id}/suspend`, { reason: '' }).expect(400);
    const employer = await login(t);
    const res = await post(`/admin/workers/${employer.user.id}/suspend`, {
      reason: 'No es trabajador.',
    }).expect(409);
    expect(res.body).toMatchObject({ code: 'WORKER_TRANSITION_NOT_ALLOWED' });
  });

  it('un admin no se suspende, ni se reactiva, ni se quita la marca a sí mismo', async () => {
    const worker = await createApprovedWorker(t);
    const self = await promoteToAdmin(t, worker.id);
    for (const action of ['suspend', 'reactivate']) {
      const res = await post(
        `/admin/workers/${worker.id}/${action}`,
        { reason: 'Sobre mí mismo.' },
        self,
      ).expect(403);
      expect(res.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });
    }
    await t.prisma.user.update({
      where: { id: worker.id },
      data: { moderationFlaggedAt: new Date() },
    });
    await post(`/admin/users/${worker.id}/clear-flag`, { reason: 'Sobre mí mismo.' }, self).expect(
      403,
    );
  });

  it('quita la marca "revisar" del empleador con motivo y lo audita', async () => {
    const employer = await login(t);
    await t.prisma.user.update({
      where: { id: employer.user.id },
      data: { moderationFlaggedAt: new Date() },
    });
    const listed = (await get('/admin/users', { q: employer.user.phone }).expect(200))
      .body as UserPageDto;
    expect(listed.items[0]?.flagged).toBe(true);

    await post(`/admin/users/${employer.user.id}/clear-flag`, {
      reason: 'Revisado: reportes sin fundamento.',
    }).expect(200);
    const user = await t.prisma.user.findUniqueOrThrow({ where: { id: employer.user.id } });
    expect(user.moderationFlaggedAt).toBeNull();
    await expectAudited(t, {
      action: 'user.clear_flag',
      targetType: 'user',
      targetId: employer.user.id,
      adminId: admin.user.id,
    });
    const again = await post(`/admin/users/${employer.user.id}/clear-flag`, {
      reason: 'Otra vez.',
    }).expect(409);
    expect(again.body).toMatchObject({ code: 'USER_NOT_FLAGGED' });
  });
});

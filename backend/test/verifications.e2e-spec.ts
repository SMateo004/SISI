import request from 'supertest';
import type {
  VerificationDetailDto,
  VerificationPageDto,
  VerificationResultDto,
} from '../src/verifications/dto/verifications.dto';
import { auditRows, expectAudited } from './utils/audit';
import { createPendingWorker } from './utils/workers';
import {
  type AdminSession,
  bearer,
  createTestApp,
  loginAsAdmin,
  promoteToAdmin,
  type TestApp,
  waitFor,
} from './utils/test-app';

describe('Verificaciones en el panel (e2e, R1.3, R1.4, R9.5)', () => {
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

  const notificationOf = (userId: string, type: string) =>
    waitFor(
      () =>
        t.prisma.notification.findFirst({ where: { userId, type } }).then((n) => n ?? undefined),
      {
        what: `el aviso ${type}`,
      },
    );

  it('la cola trae las pendientes de la más antigua a la más nueva', async () => {
    const first = await createPendingWorker(t);
    const second = await createPendingWorker(t);
    const page = (await get('/admin/verifications').expect(200)).body as VerificationPageDto;
    const ids = page.items.map((i) => i.userId);
    expect(ids.indexOf(first.id)).toBeGreaterThanOrEqual(0);
    expect(ids.indexOf(first.id)).toBeLessThan(ids.indexOf(second.id));
    expect(page.items.find((i) => i.userId === first.id)?.categories).toEqual(['Plomería']);
  });

  it('el detalle trae la edad, los requisitos extra y documentos por 5 minutos sin caché, y queda auditado', async () => {
    await t.prisma.category.update({
      where: { slug: 'electricidad' },
      data: { extraRequirements: ['certificado_electricista'] },
    });
    const worker = await createPendingWorker(t, {
      birthDate: '2000-01-15',
      categorySlugs: ['electricidad'],
    });
    const res = await get(`/admin/verifications/${worker.id}`).expect(200);
    expect(res.headers['cache-control']).toBe('no-store');
    const detail = res.body as VerificationDetailDto;
    expect(detail).toMatchObject({
      status: 'pendiente_revision',
      birthDate: '2000-01-15',
      transport: 'moto',
      maxRadiusKm: 5,
      categoryDetails: [
        expect.objectContaining({
          name: 'Electricidad',
          extraRequirements: ['certificado_electricista'],
        }),
      ],
    });
    expect(detail.age).toBeGreaterThanOrEqual(26);
    expect(detail.documents.map((d) => d.type).sort()).toEqual([
      'ci_back',
      'ci_front',
      'selfie',
    ]);
    for (const d of detail.documents) {
      expect(d.url).toContain('X-Amz-Expires=300');
      expect(d.url).toContain('response-cache-control=no-store');
    }
    await expectAudited(t, {
      action: 'verification.view_documents',
      targetType: 'worker',
      targetId: worker.id,
      adminId: admin.user.id,
    });
  });

  it('aprobar: pasa a aprobado, avisa con push y deja su fila de auditoría', async () => {
    const worker = await createPendingWorker(t);
    const result = (
      await post(`/admin/verifications/${worker.id}/approve`, {
        note: 'Documentos claros.',
      }).expect(200)
    ).body as VerificationResultDto;
    expect(result).toMatchObject({ status: 'aprobado', rejectionReason: null });
    const row = await expectAudited(t, {
      action: 'verification.approve',
      targetType: 'worker',
      targetId: worker.id,
      adminId: admin.user.id,
    });
    expect(row).toMatchObject({
      before: { status: 'pendiente_revision' },
      after: { status: 'aprobado' },
      reason: 'Documentos claros.',
    });
    const notification = await notificationOf(worker.id, 'verification_approved');
    expect(notification.title).toBe('¡Ya eres trabajador en SISI!');

    // Ya no está en la cola, y aprobar otra vez no se puede.
    const page = (await get('/admin/verifications').expect(200)).body as VerificationPageDto;
    expect(page.items.map((i) => i.userId)).not.toContain(worker.id);
    await post(`/admin/verifications/${worker.id}/approve`, {}).expect(409);
  });

  it('rechazar: motivo de la lista y nota obligatorios; el trabajador los ve', async () => {
    const worker = await createPendingWorker(t);
    await post(`/admin/verifications/${worker.id}/reject`, {
      reason: 'no_me_gusta',
      note: 'Nota larga.',
    }).expect(400);
    await post(`/admin/verifications/${worker.id}/reject`, {
      reason: 'documento_ilegible',
      note: '',
    }).expect(400);
    expect(await auditRows(t, 'worker', worker.id)).toHaveLength(0);

    const result = (
      await post(`/admin/verifications/${worker.id}/reject`, {
        reason: 'documento_ilegible',
        note: 'La foto del reverso está movida.',
      }).expect(200)
    ).body as VerificationResultDto;
    expect(result).toEqual({
      userId: worker.id,
      status: 'rechazado',
      rejectionReason: 'Una foto del carnet no se lee bien. La foto del reverso está movida.',
    });
    const mine = await request(t.app.getHttpServer())
      .get('/me/worker')
      .set(...bearer(worker.accessToken))
      .expect(200);
    expect(mine.body).toMatchObject({
      status: 'rechazado',
      rejectionReason: 'Una foto del carnet no se lee bien. La foto del reverso está movida.',
    });
    const notification = await notificationOf(worker.id, 'verification_rejected');
    expect(notification.body).toBe(
      'Una foto del carnet no se lee bien. La foto del reverso está movida.',
    );
    const row = await expectAudited(t, {
      action: 'verification.reject',
      targetType: 'worker',
      targetId: worker.id,
      adminId: admin.user.id,
    });
    expect(row?.after).toEqual({ status: 'rechazado', reason: 'documento_ilegible' });
  });

  it('un admin no revisa su propia solicitud', async () => {
    const worker = await createPendingWorker(t);
    const self = await promoteToAdmin(t, worker.id);
    const res = await post(`/admin/verifications/${worker.id}/approve`, {}, self).expect(403);
    expect(res.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });
    await post(
      `/admin/verifications/${worker.id}/reject`,
      { reason: 'otro', note: 'Sobre mí mismo.' },
      self,
    ).expect(403);
    const profile = await t.prisma.workerProfile.findUniqueOrThrow({
      where: { userId: worker.id },
    });
    expect(profile.status).toBe('pendiente_revision');
  });

  it('404 para quien no envió una solicitud', async () => {
    await get('/admin/verifications/00000000-0000-4000-8000-000000000000').expect(404);
  });
});

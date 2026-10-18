import request from 'supertest';
import { StorageService } from '../src/storage/storage.service';
import { assignJob, completeJob } from './utils/jobs';
import { publishRequest } from './utils/requests';
import {
  bearer,
  createTestApp,
  e164,
  login,
  resetPhoneCooldowns,
  type TestApp,
  uniqueIp,
  waitFor,
} from './utils/test-app';
import { uniquePhone } from './utils/unique';
import { fakeJpeg, putPresigned } from './utils/upload';
import { createPendingWorker } from './utils/workers';

/** Eliminación de cuenta por anonimización (e2e, ADR-0049). */
describe('Eliminación de cuenta (e2e)', () => {
  let t: TestApp;
  const http = () => request(t.app.getHttpServer());

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterAll(async () => {
    await t.close();
  });

  /** Pide el código y confirma, como la app. */
  const deleteFromApp = async (token: string, phone: string) => {
    await resetPhoneCooldowns(t);
    await http()
      .post('/me/deletion/code')
      .set(...bearer(token))
      .expect(202);
    const code = t.codes.get(phone);
    if (!code) throw new Error('No llegó el código');
    return http()
      .post('/me/deletion')
      .set(...bearer(token))
      .send({ code });
  };

  it('sin deuda: anonimiza, cancela lo abierto, conserva los trabajos y corta la sesión', async () => {
    // Un empleador con un trabajo terminado (comisión del trabajador, no suya) y una solicitud abierta.
    const job = await assignJob(t);
    await completeJob(t, job);
    const employer = job.employer;
    await http()
      .patch('/me')
      .set(...bearer(employer.accessToken))
      .send({ name: 'Carla Rojas' });
    const openId = await publishRequest(t, employer.accessToken);

    const check = await http()
      .get('/me/deletion')
      .set(...bearer(employer.accessToken))
      .expect(200);
    expect(check.body).toMatchObject({ canDelete: true, blockers: [] });

    const res = await deleteFromApp(employer.accessToken, employer.user.phone);
    expect(res.status).toBe(204);

    const user = await t.prisma.user.findUniqueOrThrow({ where: { id: employer.user.id } });
    expect(user.phone).toBe(`eliminado:${employer.user.id}`);
    expect(user.name).toBeNull();
    expect(user.deletedAt).not.toBeNull();
    expect(await t.prisma.refreshToken.count({ where: { userId: user.id } })).toBe(0);
    expect(
      await t.prisma.accountDeletion.count({ where: { userId: user.id, source: 'app' } }),
    ).toBe(1);

    const open = await t.prisma.serviceRequest.findUniqueOrThrow({ where: { id: openId } });
    expect(open.status).toBe('cancelada');
    expect(open.address).toBe('Dirección eliminada');
    // El trabajo terminado sigue, con su id (contabilidad del trabajador intacta).
    const kept = await t.prisma.job.findUniqueOrThrow({ where: { id: job.jobId } });
    expect(kept.employerId).toBe(employer.user.id);
    expect(
      await t.prisma.ledgerEntry.count({ where: { workerId: job.worker.id } }),
    ).toBeGreaterThan(0);

    // El token de acceso vigente deja de servir.
    const after = await http()
      .get('/me')
      .set(...bearer(employer.accessToken));
    expect(after.status).toBe(401);
    expect((after.body as { code: string }).code).toBe('ACCOUNT_DELETED');

    // El mismo número puede volver: es una cuenta nueva.
    await resetPhoneCooldowns(t);
    const again = await login(t, employer.user.phone.replace('+591', ''));
    expect(again.isNewUser).toBe(true);
    expect(again.user.id).not.toBe(employer.user.id);
  });

  it('con deuda: muestra el monto y la referencia, y no deja eliminar', async () => {
    const job = await assignJob(t);
    await completeJob(t, job); // comisión del trabajador (la registra el worker)
    await waitFor(
      async () =>
        (await t.prisma.ledgerEntry.count({ where: { workerId: job.worker.id } })) > 0
          ? true
          : undefined,
      { what: 'la comisión en el ledger' },
    );
    const check = await http()
      .get('/me/deletion')
      .set(...bearer(job.worker.accessToken))
      .expect(200);
    const body = check.body as {
      canDelete: boolean;
      blockers: { code: string; balanceBs?: string; paymentReference?: string | null }[];
    };
    expect(body.canDelete).toBe(false);
    const debt = body.blockers.find((b) => b.code === 'ACCOUNT_HAS_DEBT');
    expect(Number(debt?.balanceBs)).toBeGreaterThan(0);
    expect(debt?.paymentReference).toMatch(/^SISI-/);

    const code = await http()
      .post('/me/deletion/code')
      .set(...bearer(job.worker.accessToken));
    expect(code.status).toBe(409);
    expect((code.body as { code: string }).code).toBe('ACCOUNT_HAS_DEBT');
    const user = await t.prisma.user.findUniqueOrThrow({ where: { id: job.worker.id } });
    expect(user.deletedAt).toBeNull();
  });

  it('con un trabajo activo no se puede (ninguna de las dos partes)', async () => {
    const job = await assignJob(t);
    for (const token of [job.worker.accessToken, job.employer.accessToken]) {
      const check = await http()
        .get('/me/deletion')
        .set(...bearer(token))
        .expect(200);
      expect(
        (check.body as { blockers: { code: string }[] }).blockers.map((b) => b.code),
      ).toContain('ACCOUNT_HAS_ACTIVE_JOB');
    }
  });

  it('un código equivocado no elimina nada', async () => {
    const user = await login(t);
    await resetPhoneCooldowns(t);
    await http()
      .post('/me/deletion/code')
      .set(...bearer(user.accessToken))
      .expect(202);
    const res = await http()
      .post('/me/deletion')
      .set(...bearer(user.accessToken))
      .send({ code: '000000' });
    expect(res.status).toBe(400);
    expect(
      (await t.prisma.user.findUniqueOrThrow({ where: { id: user.user.id } })).deletedAt,
    ).toBeNull();
  });

  it('trabajador: borra documentos, fecha de nacimiento, ubicación y sus archivos del bucket', async () => {
    const worker = await createPendingWorker(t);
    const storage = t.app.get(StorageService);
    const doc = await t.prisma.workerDocument.findFirstOrThrow({ where: { workerId: worker.id } });
    const file = fakeJpeg(1000);
    const upload = await storage.presignUpload({
      key: doc.fileKey,
      contentType: 'image/jpeg',
      sizeBytes: file.length,
      expiresInSec: 60,
    });
    expect(
      await putPresigned(
        {
          key: doc.fileKey,
          uploadUrl: upload.url,
          method: 'PUT',
          headers: upload.headers,
        } as never,
        file,
      ),
    ).toBe(200);
    expect(await storage.head(doc.fileKey)).not.toBeNull();

    expect((await deleteFromApp(worker.accessToken, worker.user.phone)).status).toBe(204);
    expect(await t.prisma.workerDocument.count({ where: { workerId: worker.id } })).toBe(0);
    const profile = await t.prisma.workerProfile.findUniqueOrThrow({
      where: { userId: worker.id },
    });
    expect(profile.birthDate).toBeNull();
    await waitFor(async () => ((await storage.head(doc.fileKey)) === null ? true : undefined), {
      what: 'el borrado del archivo en el worker',
    });
  });

  it('página web: código por SMS solo si hay cuenta, y eliminación con el código', async () => {
    const local = uniquePhone();
    const user = await login(t, local);
    const send = (path: string, body: Record<string, unknown>) =>
      http().post(path).set('X-Forwarded-For', uniqueIp()).send(body);

    // Un número sin cuenta: misma respuesta, sin SMS.
    const nobody = uniquePhone();
    await send('/account-deletion/code', { phone: nobody }).expect(202);
    expect(t.codes.get(e164(nobody))).toBeUndefined();

    await resetPhoneCooldowns(t);
    await send('/account-deletion/code', { phone: local }).expect(202);
    const code = t.codes.get(e164(local));
    await send('/account-deletion', { phone: local, code }).expect(204);
    const deleted = await t.prisma.user.findUniqueOrThrow({ where: { id: user.user.id } });
    expect(deleted.deletedAt).not.toBeNull();
    expect(
      await t.prisma.accountDeletion.count({ where: { userId: user.user.id, source: 'web' } }),
    ).toBe(1);
  });
});

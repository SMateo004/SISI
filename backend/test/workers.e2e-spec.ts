import request from 'supertest';
import type { LoginResponseDto } from '../src/auth/dto/auth.dto';
import type { PresignedUploadDto } from '../src/storage/dto/upload.dto';
import type { UserDto } from '../src/users/dto/user.dto';
import type { DocumentUrlDto, WorkerProfileDto } from '../src/workers/dto/worker.dto';
import {
  DEBT_STATUS_PROVIDER,
  type DebtStatusProvider,
  WORKER_NOTIFIER,
  type WorkerNotifier,
} from '../src/workers/worker.ports';
import { WorkerStatusService } from '../src/workers/worker-status.service';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
} from './utils/test-app';
import { fakeJpeg, putPresigned } from './utils/upload';

type DocType = 'ci_front' | 'ci_back' | 'selfie';

describe('Trabajador: upgrade, documentos e interruptor (e2e)', () => {
  let t: TestApp;
  let categoryId: string;
  const server = () => t.app.getHttpServer();

  const uploadDocument = async (token: string, type: DocType): Promise<PresignedUploadDto> => {
    const file = fakeJpeg(3000 + type.length);
    const upload = (
      await request(server())
        .post('/me/worker/documents/upload-url')
        .set(...bearer(token))
        .send({ type, contentType: 'image/jpeg', sizeBytes: file.length })
        .expect(201)
    ).body as PresignedUploadDto;
    expect(await putPresigned(upload, file)).toBe(200);
    await request(server())
      .put(`/me/worker/documents/${type}`)
      .set(...bearer(token))
      .send({ key: upload.key })
      .expect(200);
    return upload;
  };

  const validUpgrade = () => ({
    birthDate: '1995-04-21',
    categoryIds: [categoryId],
    transport: 'moto',
    maxRadiusKm: 5,
  });

  /** Cuenta con documentos subidos y solicitud enviada (pendiente_revision). */
  const submittedWorker = async (): Promise<LoginResponseDto> => {
    const session = await login(t);
    for (const type of ['ci_front', 'ci_back', 'selfie'] as const) {
      await uploadDocument(session.accessToken, type);
    }
    await request(server())
      .post('/me/worker/upgrade')
      .set(...bearer(session.accessToken))
      .send(validUpgrade())
      .expect(201);
    return session;
  };

  const switchMode = (token: string, mode: 'employer' | 'worker') =>
    request(server())
      .patch('/me/mode')
      .set(...bearer(token))
      .send({ mode });

  beforeAll(async () => {
    t = await createTestApp();
    // Categoría del seed (Fase 2): el upgrade trabaja con las categorías reales.
    const category = await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } });
    categoryId = category.id;
  });

  afterAll(async () => {
    await t.close();
  });

  it('upgrade completo: documentos a S3, solicitud y estado pendiente_revision', async () => {
    const session = await login(t);
    const empty = (
      await request(server())
        .get('/me/worker')
        .set(...bearer(session.accessToken))
        .expect(200)
    ).body as WorkerProfileDto;
    expect(empty).toMatchObject({
      status: 'sin_solicitar',
      editable: true,
      missingDocuments: ['ci_front', 'ci_back', 'selfie'],
    });

    // Sin documentos no se puede enviar.
    const missing = await request(server())
      .post('/me/worker/upgrade')
      .set(...bearer(session.accessToken))
      .send(validUpgrade())
      .expect(400);
    expect(missing.body).toMatchObject({ code: 'WORKER_DOCUMENTS_MISSING' });

    const front = await uploadDocument(session.accessToken, 'ci_front');
    expect(front.key.startsWith(`identity/${session.user.id}/ci_front-`)).toBe(true);
    await uploadDocument(session.accessToken, 'ci_back');
    await uploadDocument(session.accessToken, 'selfie');

    const submitted = (
      await request(server())
        .post('/me/worker/upgrade')
        .set(...bearer(session.accessToken))
        .send(validUpgrade())
        .expect(201)
    ).body as WorkerProfileDto;
    expect(submitted).toMatchObject({
      status: 'pendiente_revision',
      editable: false,
      birthDate: '1995-04-21',
      transport: 'moto',
      maxRadiusKm: 5,
      categoryIds: [categoryId],
      missingDocuments: [],
    });
    // El trabajador ve el estado de cada documento, nunca la imagen ni la clave (R9.5).
    expect(submitted.documents).toHaveLength(3);
    expect(JSON.stringify(submitted)).not.toMatch(/identity\/|X-Amz|https?:/);

    // En revisión ya no puede cambiar documentos.
    const locked = await request(server())
      .post('/me/worker/documents/upload-url')
      .set(...bearer(session.accessToken))
      .send({ type: 'selfie', contentType: 'image/jpeg', sizeBytes: 100 })
      .expect(409);
    expect(locked.body).toMatchObject({ code: 'WORKER_PROFILE_LOCKED' });

    const events = await t.prisma.workerStatusEvent.findMany({
      where: { workerId: session.user.id },
    });
    expect(events).toEqual([
      expect.objectContaining({
        event: 'SUBMIT',
        fromStatus: 'sin_solicitar',
        toStatus: 'pendiente_revision',
      }),
    ]);
  });

  it('valida edad, categorías, transporte y radio', async () => {
    const session = await login(t);
    for (const type of ['ci_front', 'ci_back', 'selfie'] as const) {
      await uploadDocument(session.accessToken, type);
    }
    const send = (body: object) =>
      request(server())
        .post('/me/worker/upgrade')
        .set(...bearer(session.accessToken))
        .send(body);

    const minor = new Date();
    minor.setUTCFullYear(minor.getUTCFullYear() - 17);
    expect(
      (await send({ ...validUpgrade(), birthDate: minor.toISOString().slice(0, 10) })).body,
    ).toMatchObject({
      code: 'WORKER_UNDERAGE',
      message: 'Debes tener al menos 18 años para trabajar en SISI.',
    });
    expect((await send({ ...validUpgrade(), maxRadiusKm: 11 })).body).toMatchObject({
      message: 'El radio máximo es 10 km.',
    });
    expect((await send({ ...validUpgrade(), transport: 'avion' })).body).toMatchObject({
      message: 'Elige un medio de transporte de la lista.',
    });
    expect((await send({ ...validUpgrade(), categoryIds: [] })).body).toMatchObject({
      message: 'Elige al menos una categoría.',
    });

    const inactive = await createCategory(t, { active: false });
    expect((await send({ ...validUpgrade(), categoryIds: [inactive.id] })).body).toMatchObject({
      code: 'CATEGORY_NOT_AVAILABLE',
    });
    // Nada de lo anterior cambió el estado.
    const profile = (
      await request(server())
        .get('/me/worker')
        .set(...bearer(session.accessToken))
    ).body as WorkerProfileDto;
    expect(profile.status).toBe('sin_solicitar');
  });

  it('interruptor: rechazado → motivo; reenvío; aprobado → puede pasar a worker', async () => {
    const session = await submittedWorker();
    const status = t.app.get(WorkerStatusService);

    const underReview = await switchMode(session.accessToken, 'worker').expect(409);
    expect(underReview.body).toMatchObject({
      code: 'WORKER_UNDER_REVIEW',
      nextAction: 'VIEW_REVIEW_STATUS',
      actionLabel: 'Ver el estado de tu solicitud',
    });

    await status.apply(
      session.user.id,
      { type: 'REJECT', reason: 'La foto del carnet está borrosa' },
      null,
    );
    const rejected = await switchMode(session.accessToken, 'worker').expect(409);
    expect(rejected.body).toMatchObject({
      code: 'WORKER_REJECTED',
      nextAction: 'RESUBMIT_VERIFICATION',
    });
    const profile = (
      await request(server())
        .get('/me/worker')
        .set(...bearer(session.accessToken))
    ).body as WorkerProfileDto;
    expect(profile).toMatchObject({
      status: 'rechazado',
      rejectionReason: 'La foto del carnet está borrosa',
      editable: true,
    });

    // Rechazado puede corregir un documento y volver a enviar.
    await uploadDocument(session.accessToken, 'ci_front');
    await request(server())
      .post('/me/worker/upgrade')
      .set(...bearer(session.accessToken))
      .send(validUpgrade())
      .expect(201);
    await status.apply(session.user.id, { type: 'APPROVE' }, null);

    const approved = (await switchMode(session.accessToken, 'worker').expect(200)).body as UserDto;
    expect(approved.activeMode).toBe('worker');
    const back = (await switchMode(session.accessToken, 'employer').expect(200)).body as UserDto;
    expect(back.activeMode).toBe('employer');
  });

  it('interruptor sin solicitud: indica completar la verificación', async () => {
    const { accessToken } = await login(t);
    const res = await switchMode(accessToken, 'worker').expect(409);
    expect(res.body).toMatchObject({
      code: 'WORKER_NOT_REQUESTED',
      nextAction: 'COMPLETE_VERIFICATION',
      actionLabel: 'Completa tu verificación',
    });
  });

  it('bloqueo por deuda en modo worker: pasa a employer, avisa y solo vuelve con el interruptor', async () => {
    const session = await submittedWorker();
    const status = t.app.get(WorkerStatusService);
    const notifier = t.app.get<WorkerNotifier>(WORKER_NOTIFIER);
    const notify = jest.spyOn(notifier, 'modeForcedToEmployer');

    await status.apply(session.user.id, { type: 'APPROVE' }, null);
    await switchMode(session.accessToken, 'worker').expect(200);

    const change = await status.apply(session.user.id, { type: 'BLOCK_FOR_DEBT' }, null);
    expect(change.modeForcedToEmployer).toBe(true);
    expect(notify).toHaveBeenCalledWith(session.user.id, 'bloqueado_deuda');
    const me = (
      await request(server())
        .get('/me')
        .set(...bearer(session.accessToken))
    ).body as UserDto;
    expect(me.activeMode).toBe('employer');

    // R1.6: bloqueado sigue pudiendo usar la app como employer.
    await switchMode(session.accessToken, 'employer').expect(200);
    const blocked = await switchMode(session.accessToken, 'worker').expect(409);
    expect(blocked.body).toMatchObject({
      code: 'WORKER_BLOCKED_DEBT',
      actionLabel: 'Paga tu comisión pendiente',
    });

    // Al desbloquearse no vuelve solo a worker.
    await status.apply(session.user.id, { type: 'DEBT_PAID' }, null);
    const after = (
      await request(server())
        .get('/me')
        .set(...bearer(session.accessToken))
    ).body as UserDto;
    expect(after.activeMode).toBe('employer');
    await switchMode(session.accessToken, 'worker').expect(200);
  });

  it('suspensión: prioridad sobre la deuda y, al levantarla con deuda vencida, queda bloqueado_deuda', async () => {
    const session = await submittedWorker();
    const status = t.app.get(WorkerStatusService);
    await status.apply(session.user.id, { type: 'APPROVE' }, null);
    await status.apply(session.user.id, { type: 'BLOCK_FOR_DEBT' }, null);

    const suspended = await status.apply(
      session.user.id,
      { type: 'SUSPEND', reason: '3 reportes válidos' },
      null,
    );
    expect(suspended.profile.status).toBe('suspendido_moderacion');
    const res = await switchMode(session.accessToken, 'worker').expect(409);
    expect(res.body).toMatchObject({ code: 'WORKER_SUSPENDED' });

    const confirmed = await status.apply(
      session.user.id,
      { type: 'CONFIRM_SUSPENSION', resolution: 'Falta confirmada' },
      null,
    );
    expect(confirmed.profile).toMatchObject({
      status: 'suspendido_moderacion',
      moderationResolution: 'Falta confirmada',
    });

    const debts = t.app.get<DebtStatusProvider>(DEBT_STATUS_PROVIDER);
    jest.spyOn(debts, 'hasOverdueDebt').mockResolvedValueOnce(true);
    const lifted = await status.apply(
      session.user.id,
      { type: 'LIFT_SUSPENSION', resolution: 'Reapertura' },
      null,
    );
    expect(lifted.profile.status).toBe('bloqueado_deuda');

    const history = await t.prisma.workerStatusEvent.findMany({
      where: { workerId: session.user.id },
      orderBy: { createdAt: 'asc' },
    });
    expect(history.map((e) => e.toStatus)).toEqual([
      'pendiente_revision',
      'aprobado',
      'bloqueado_deuda',
      'suspendido_moderacion',
      'suspendido_moderacion',
      'bloqueado_deuda',
    ]);
  });

  describe('documentos de identidad (R9.5)', () => {
    it('solo un admin obtiene un enlace temporal; nadie más accede a documentos ajenos', async () => {
      const worker = await submittedWorker();
      const document = await t.prisma.workerDocument.findFirstOrThrow({
        where: { workerId: worker.user.id, type: 'ci_front' },
      });
      const url = `/admin/workers/${worker.user.id}/documents/${document.id}/url`;

      // El propio trabajador no puede pedir el enlace.
      const own = await request(server())
        .get(url)
        .set(...bearer(worker.accessToken))
        .expect(403);
      expect(own.body).toMatchObject({ code: 'FORBIDDEN' });
      // Otro usuario tampoco.
      const other = await login(t);
      await request(server())
        .get(url)
        .set(...bearer(other.accessToken))
        .expect(403);
      // Sin sesión, 401.
      await request(server()).get(url).expect(401);

      // Admin: enlace firmado que funciona y vence.
      const adminToken = (await loginAsAdmin(t)).accessToken;
      const signed = (
        await request(server())
          .get(url)
          .set(...bearer(adminToken))
          .expect(200)
      ).body as DocumentUrlDto;
      expect(signed.url).toContain('X-Amz-Expires=300');
      expect((await fetch(signed.url)).status).toBe(200);

      // El objeto no es accesible sin firma.
      const unsigned = signed.url.split('?')[0] ?? '';
      expect((await fetch(unsigned)).status).toBe(403);

      // Un documento de otro trabajador con ese userId: 404.
      await request(server())
        .get(`/admin/workers/${other.user.id}/documents/${document.id}/url`)
        .set(...bearer(adminToken))
        .expect(404);
    });

    it('no se puede registrar como propio un archivo de otro usuario', async () => {
      const owner = await login(t);
      const upload = await uploadDocument(owner.accessToken, 'ci_front');
      const intruder = await login(t);
      const res = await request(server())
        .put('/me/worker/documents/ci_front')
        .set(...bearer(intruder.accessToken))
        .send({ key: upload.key })
        .expect(403);
      expect(res.body).toMatchObject({ code: 'UPLOAD_KEY_FORBIDDEN' });
    });
  });
});

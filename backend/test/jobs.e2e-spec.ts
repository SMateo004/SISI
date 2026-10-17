import request from 'supertest';
import type { JobDto, JobPageDto } from '../src/jobs/dto/job.dto';
import type { RequestDto } from '../src/requests/dto/request.dto';
import { assignJob, offerOn, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { connectSocket, type TestSocket } from './utils/socket';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  waitFor,
} from './utils/test-app';
import { createApprovedWorker, makeAvailable } from './utils/workers';

describe('Ciclo del trabajo (e2e, ADR-0029)', () => {
  let t: TestApp;
  const sockets: TestSocket[] = [];
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterEach(() => {
    for (const s of sockets.splice(0)) s.close();
  });

  afterAll(async () => {
    await t.close();
  });

  const post = (token: string, path: string, body: Record<string, unknown> = {}) =>
    request(server())
      .post(path)
      .set(...bearer(token))
      .send(body);

  const getJob = async (token: string, jobId: string) =>
    (
      await request(server())
        .get(`/jobs/${jobId}`)
        .set(...bearer(token))
        .expect(200)
    ).body as JobDto;

  const outboxOf = (jobId: string, type: string) =>
    t.prisma.outboxEvent.findMany({ where: { aggregateId: jobId, type } });

  it('ciclo completo: en camino → en curso → terminado, con comisión y job.completed', async () => {
    const { jobId, requestId, worker, employer } = await assignJob(t);
    const [workerLive, employerLive] = [
      await connectSocket(t, worker.accessToken),
      await connectSocket(t, employer.accessToken),
    ];
    sockets.push(workerLive, employerLive);

    const assigned = await getJob(worker.accessToken, jobId);
    expect(assigned).toMatchObject({
      status: 'asignado',
      myRole: 'worker',
      finalPriceBs: '150.00',
      commissionBs: null,
      allowedActions: ['START_TRIP', 'CANCEL'],
    });

    // "Terminé" solo desde en curso: rechazado en asignado y en camino.
    const early = await post(worker.accessToken, `/jobs/${jobId}/finish`).expect(409);
    expect(early.body).toMatchObject({ code: 'JOB_TRANSITION_NOT_ALLOWED' });
    // El empleador no puede marcar los pasos del trabajador (403); un tercero no ve nada (404).
    await post(employer.accessToken, `/jobs/${jobId}/on-the-way`).expect(403);
    const stranger = await login(t);
    await post(stranger.accessToken, `/jobs/${jobId}/on-the-way`).expect(404);
    await request(server())
      .get(`/jobs/${jobId}`)
      .set(...bearer(stranger.accessToken))
      .expect(404);

    await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(200);
    expect(
      await employerLive.next('job:status', (p) => p.jobId === jobId && p.action === 'START_TRIP'),
    ).toEqual({ jobId, requestId, status: 'en_camino', action: 'START_TRIP' });
    await post(worker.accessToken, `/jobs/${jobId}/finish`).expect(409);
    await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(409);

    await post(worker.accessToken, `/jobs/${jobId}/start`).expect(200);
    // Ya en curso no se cancela.
    expect((await getJob(employer.accessToken, jobId)).allowedActions).toEqual(['CONFIRM']);

    const finished = (await post(worker.accessToken, `/jobs/${jobId}/finish`).expect(200))
      .body as JobDto;
    expect(finished.status).toBe('en_curso');
    expect(finished.timeline.workerFinishedAt).not.toBeNull();
    expect(finished.autoConfirmAt).not.toBeNull();
    await post(worker.accessToken, `/jobs/${jobId}/finish`).expect(409);
    await post(worker.accessToken, `/jobs/${jobId}/confirm`).expect(403);

    const done = (await post(employer.accessToken, `/jobs/${jobId}/confirm`).expect(200))
      .body as JobDto;
    expect(done).toMatchObject({
      status: 'terminado',
      myRole: 'employer',
      autoConfirmed: false,
      autoConfirmAt: null,
      // El empleador no ve la comisión del trabajador.
      commissionBs: null,
      netBs: null,
      allowedActions: [],
    });
    await workerLive.next('job:status', (p) => p.jobId === jobId && p.status === 'terminado');

    // Historial del trabajador (R8.3): monto, comisión y neto.
    const history = (
      await request(server())
        .get('/jobs?role=worker')
        .set(...bearer(worker.accessToken))
        .expect(200)
    ).body as JobPageDto;
    expect(history.items[0]).toMatchObject({
      id: jobId,
      status: 'terminado',
      finalPriceBs: '150.00',
      commissionBs: '19.50',
      netBs: '130.50',
    });
    const t0 = history.items[0]?.timeline;
    expect(t0?.onTheWayAt && t0.startedAt && t0.workerFinishedAt && t0.completedAt).toBeTruthy();

    const [completed] = await outboxOf(jobId, 'job.completed');
    expect(completed?.payload).toMatchObject({
      jobId,
      workerId: worker.id,
      finalPriceBs: '150.00',
      commissionPct: '13.00',
      commissionBs: '19.50',
    });

    const events = await t.prisma.jobEvent.findMany({ where: { jobId }, orderBy: { id: 'asc' } });
    expect(events.map((e) => [e.action, e.fromStatus, e.toStatus, e.actorRole])).toEqual([
      ['START_TRIP', 'asignado', 'en_camino', 'worker'],
      ['START_WORK', 'en_camino', 'en_curso', 'worker'],
      ['FINISH', 'en_curso', 'en_curso', 'worker'],
      ['CONFIRM', 'en_curso', 'terminado', 'employer'],
    ]);

    // La solicitud sigue asignada; el empleador recibió los avisos.
    const req = (
      await request(server())
        .get(`/requests/${requestId}`)
        .set(...bearer(employer.accessToken))
        .expect(200)
    ).body as RequestDto;
    expect(req.status).toBe('asignada');
    await waitFor(
      async () => {
        const n = await t.prisma.notification.findMany({
          where: { userId: employer.user.id, type: { startsWith: 'job_' } },
        });
        return n.length >= 3 ? n : undefined;
      },
      { what: 'los avisos del trabajo' },
    );
  });

  it('job_events es append-only: la base rechaza UPDATE y DELETE', async () => {
    const { jobId, worker } = await assignJob(t);
    await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(200);
    await expect(
      t.prisma.$executeRaw`UPDATE job_events SET note = 'x' WHERE job_id = ${jobId}::uuid`,
    ).rejects.toThrow(/append-only/);
    await expect(
      t.prisma.$executeRaw`DELETE FROM job_events WHERE job_id = ${jobId}::uuid`,
    ).rejects.toThrow(/append-only/);
  });

  it('autoconfirmación: sin respuesta del empleador, se confirma sola al vencer el plazo', async () => {
    const { jobId, worker, employer } = await assignJob(t, { amountBs: '99.99' });
    await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(200);
    await post(worker.accessToken, `/jobs/${jobId}/start`).expect(200);
    await post(worker.accessToken, `/jobs/${jobId}/finish`).expect(200);

    const done = await waitFor(
      async () => {
        const job = await getJob(worker.accessToken, jobId);
        return job.status === 'terminado' ? job : undefined;
      },
      { timeoutMs: 10_000, what: 'la autoconfirmación' },
    );
    expect(done).toMatchObject({ autoConfirmed: true, commissionBs: '13.00', netBs: '86.99' });
    const last = await t.prisma.jobEvent.findFirst({ where: { jobId }, orderBy: { id: 'desc' } });
    expect(last).toMatchObject({ action: 'AUTO_CONFIRM', actorRole: 'system', actorId: null });
    // Ya terminado, el empleador no puede confirmar de nuevo ni disputar.
    await post(employer.accessToken, `/jobs/${jobId}/confirm`).expect(409);
    await post(employer.accessToken, `/jobs/${jobId}/dispute`).expect(409);
  });

  it('disputa: frena la autoconfirmación; el admin confirma o cancela', async () => {
    const admin = await loginAsAdmin(t);
    const cycle = async () => {
      const assigned = await assignJob(t);
      const { jobId, worker, employer } = assigned;
      await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(200);
      await post(worker.accessToken, `/jobs/${jobId}/start`).expect(200);
      // Antes del "Terminé" no hay nada que disputar.
      await post(employer.accessToken, `/jobs/${jobId}/dispute`).expect(409);
      await post(worker.accessToken, `/jobs/${jobId}/finish`).expect(200);
      const disputed = (
        await post(employer.accessToken, `/jobs/${jobId}/dispute`, {
          note: 'Quedó goteando.',
        }).expect(200)
      ).body as JobDto;
      expect(disputed).toMatchObject({ status: 'en_curso', autoConfirmAt: null });
      expect(disputed.timeline.disputedAt).not.toBeNull();
      await post(employer.accessToken, `/jobs/${jobId}/confirm`).expect(409);
      return assigned;
    };

    const first = await cycle();
    const second = await cycle();
    // Pasado el plazo de autoconfirmación (3 s en e2e), sigue en curso.
    await new Promise((r) => setTimeout(r, 3500));
    expect((await getJob(first.worker.accessToken, first.jobId)).status).toBe('en_curso');
    expect(await outboxOf(first.jobId, 'job.completed')).toHaveLength(0);

    const list = (
      await request(server())
        .get('/admin/jobs/disputed')
        .set(...bearer(admin.accessToken))
        .expect(200)
    ).body as { id: string; disputeNote: string | null }[];
    expect(list.find((j) => j.id === first.jobId)?.disputeNote).toBe('Quedó goteando.');
    await request(server())
      .get('/admin/jobs/disputed')
      .set(...bearer(first.employer.accessToken))
      .expect(403);
    await post(admin.accessToken, `/admin/jobs/${first.jobId}/resolve`, {
      decision: 'confirm',
    }).expect(400);

    await post(admin.accessToken, `/admin/jobs/${first.jobId}/resolve`, {
      decision: 'confirm',
      note: 'Se verificó con las dos partes: quedó bien.',
    }).expect(200);
    expect((await getJob(first.worker.accessToken, first.jobId)).commissionBs).toBe('19.50');
    expect(await outboxOf(first.jobId, 'job.completed')).toHaveLength(1);
    const resolution = await t.prisma.jobEvent.findFirst({
      where: { jobId: first.jobId },
      orderBy: { id: 'desc' },
    });
    expect(resolution).toMatchObject({
      action: 'RESOLVE_CONFIRM',
      actorRole: 'admin',
      actorId: admin.user.id,
      note: 'Se verificó con las dos partes: quedó bien.',
    });

    await post(admin.accessToken, `/admin/jobs/${second.jobId}/resolve`, {
      decision: 'cancel',
      note: 'No se hizo el trabajo.',
    }).expect(200);
    const cancelled = await getJob(second.worker.accessToken, second.jobId);
    expect(cancelled).toMatchObject({ status: 'cancelado', commissionBs: null });
    expect(await outboxOf(second.jobId, 'job.completed')).toHaveLength(0);
    const req = await t.prisma.serviceRequest.findUniqueOrThrow({
      where: { id: second.requestId },
    });
    expect(req.status).toBe('cancelada');
    // Resuelta, ya no se puede resolver otra vez.
    await post(admin.accessToken, `/admin/jobs/${second.jobId}/resolve`, {
      decision: 'confirm',
      note: 'otra vez',
    }).expect(409);
  });

  it('ubicación en camino: solo al empleador, con throttling, y se corta al empezar', async () => {
    const { jobId, worker, employer } = await assignJob(t);
    const employerLive = await connectSocket(t, employer.accessToken);
    const strangerSession = await login(t);
    const strangerLive = await connectSocket(t, strangerSession.accessToken);
    sockets.push(employerLive, strangerLive);
    const send = (meters: number) =>
      request(server())
        .post('/worker/location')
        .set(...bearer(worker.accessToken))
        .send(eastOf(CENTRO, meters))
        .expect(200);
    const locationOf = (token: string) =>
      request(server())
        .get(`/jobs/${jobId}/location`)
        .set(...bearer(token));

    // Asignado todavía no comparte la ubicación.
    expect((await locationOf(employer.accessToken).expect(409)).body).toMatchObject({
      code: 'JOB_LOCATION_UNAVAILABLE',
    });
    await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(200);
    expect((await locationOf(employer.accessToken).expect(200)).body).toEqual({
      jobId,
      location: null,
    });

    await send(250);
    const live = await employerLive.next('job:location', (p) => p.jobId === jobId);
    expect(live.longitude).toBeCloseTo(eastOf(CENTRO, 250).longitude, 6);
    // Throttling: el segundo envío inmediato no se emite, pero sí actualiza el último punto.
    await send(200);
    const latest = (await locationOf(employer.accessToken).expect(200)).body as {
      location: { longitude: number };
    };
    expect(latest.location.longitude).toBeCloseTo(eastOf(CENTRO, 200).longitude, 6);
    await new Promise((r) => setTimeout(r, 300));
    // `next` ya consumió el primero: el segundo no llegó.
    expect(employerLive.received.filter((e) => e.event === 'job:location')).toHaveLength(0);
    // El trabajador y los terceros no lo ven.
    await locationOf(worker.accessToken).expect(409);
    await locationOf(strangerSession.accessToken).expect(404);

    await post(worker.accessToken, `/jobs/${jobId}/start`).expect(200);
    await locationOf(employer.accessToken).expect(409);
    await new Promise((r) => setTimeout(r, 1100));
    const before = employerLive.received.filter((e) => e.event === 'job:location').length;
    await send(100);
    await new Promise((r) => setTimeout(r, 300));
    expect(employerLive.received.filter((e) => e.event === 'job:location')).toHaveLength(before);
    expect(strangerLive.received.filter((e) => e.event === 'job:location')).toHaveLength(0);
  });

  it('el contacto se oculta pasado el plazo desde que terminó (410)', async () => {
    const { jobId, worker, employer } = await assignJob(t);
    await post(employer.accessToken, `/jobs/${jobId}/cancel`, {
      reason: 'cambio_de_planes',
    }).expect(200);
    const contact = await request(server())
      .get(`/jobs/${jobId}/contact`)
      .set(...bearer(worker.accessToken))
      .expect(200);
    expect((contact.body as { visibleUntil: string | null }).visibleUntil).not.toBeNull();
    // En e2e el plazo es de 2 s (JOB_CONTACT_VISIBLE_AFTER_MS).
    await new Promise((r) => setTimeout(r, 2100));
    const gone = await request(server())
      .get(`/jobs/${jobId}/contact`)
      .set(...bearer(worker.accessToken))
      .expect(410);
    expect(gone.body).toMatchObject({ code: 'CONTACT_EXPIRED' });
  });

  describe('cancelación', () => {
    it('en camino la cancela el trabajador: motivo, nota retenida, solicitud cancelada y conteo', async () => {
      const { jobId, requestId, worker, employer } = await assignJob(t);
      await post(worker.accessToken, `/jobs/${jobId}/on-the-way`).expect(200);
      await post(worker.accessToken, `/jobs/${jobId}/cancel`, { reason: 'inventado' }).expect(400);

      const mine = (
        await post(worker.accessToken, `/jobs/${jobId}/cancel`, {
          reason: 'emergencia',
          note: 'Mejor te vendo c.o.c.a.i.n.a',
        }).expect(200)
      ).body as JobDto;
      expect(mine).toMatchObject({
        status: 'cancelado',
        allowedActions: [],
        cancellation: { by: 'worker', reason: 'emergencia', noteHeld: true },
      });
      // La contraparte ve el motivo, pero no la nota retenida.
      const theirs = await getJob(employer.accessToken, jobId);
      expect(theirs.cancellation).toEqual({
        by: 'worker',
        reason: 'emergencia',
        note: null,
        noteHeld: false,
      });

      const req = await t.prisma.serviceRequest.findUniqueOrThrow({ where: { id: requestId } });
      expect(req.status).toBe('cancelada');
      const user = await t.prisma.user.findUniqueOrThrow({ where: { id: worker.id } });
      expect(user.cancellationsCount).toBe(1);
      const notice = await waitFor(
        async () =>
          (await t.prisma.notification.findFirst({
            where: { userId: employer.user.id, type: 'job_cancelled' },
          })) ?? undefined,
        { what: 'el aviso de cancelación' },
      );
      expect(notice.body).toBe('Motivo: Emergencia. Puedes volver a publicar tu solicitud.');
      // Ya no está ocupado: vuelve a poder trabajar.
      const active = await t.prisma.job.count({
        where: { workerId: worker.id, status: { in: ['asignado', 'en_camino', 'en_curso'] } },
      });
      expect(active).toBe(0);
      await post(worker.accessToken, `/jobs/${jobId}/cancel`, { reason: 'otro' }).expect(409);
    });

    it('asignado la cancela el empleador con una nota visible; en curso ya no se puede', async () => {
      const first = await assignJob(t);
      const done = (
        await post(first.employer.accessToken, `/jobs/${first.jobId}/cancel`, {
          reason: 'cambio_de_planes',
          note: 'Ya lo arreglé yo.',
        }).expect(200)
      ).body as JobDto;
      expect(done.cancellation).toMatchObject({ by: 'employer', note: 'Ya lo arreglé yo.' });
      expect((await getJob(first.worker.accessToken, first.jobId)).cancellation?.note).toBe(
        'Ya lo arreglé yo.',
      );

      const second = await assignJob(t);
      await post(second.worker.accessToken, `/jobs/${second.jobId}/on-the-way`).expect(200);
      await post(second.worker.accessToken, `/jobs/${second.jobId}/start`).expect(200);
      for (const who of [second.worker, second.employer]) {
        const res = await post(who.accessToken, `/jobs/${second.jobId}/cancel`, {
          reason: 'otro',
        }).expect(409);
        expect(res.body).toMatchObject({
          code: 'JOB_TRANSITION_NOT_ALLOWED',
          message: 'Un trabajo en curso o terminado ya no se puede cancelar.',
        });
      }
    });
  });

  describe('doble asignación', () => {
    /** Un trabajador que ofertó en dos solicitudes de dos empleadores distintos. */
    const twoOffers = async () => {
      const category = await createCategory(t);
      const worker = await createApprovedWorker(t, { categorySlugs: [category.slug] });
      await makeAvailable(t, worker, eastOf(CENTRO, 300));
      const [a, b] = [await login(t), await login(t)];
      const reqA = await publishRequest(t, a.accessToken, { categoryId: category.id });
      const reqB = await publishRequest(t, b.accessToken, { categoryId: category.id });
      await waitNotified(t, reqA, worker.id);
      await waitNotified(t, reqB, worker.id);
      const offerA = await offerOn(t, worker, reqA);
      const offerB = await offerOn(t, worker, reqB);
      return { worker, a, b, reqA, reqB, offerA, offerB };
    };

    it('dos empleadores eligen al mismo trabajador a la vez: uno gana, al otro se le retira la oferta', async () => {
      const { worker, a, b, reqA, reqB, offerA, offerB } = await twoOffers();
      const [resA, resB] = await Promise.all([
        post(a.accessToken, `/requests/${reqA}/offers/${offerA.id}/accept`),
        post(b.accessToken, `/requests/${reqB}/offers/${offerB.id}/accept`),
      ]);
      const statuses = [resA.status, resB.status].sort();
      expect(statuses).toEqual([200, 409]);
      const loser = resA.status === 409 ? { res: resA, req: reqA, offer: offerA } : null;
      const lost = loser ?? { res: resB, req: reqB, offer: offerB };
      expect(lost.res.body).toMatchObject({
        code: 'WORKER_BUSY',
        message: 'Este trabajador acaba de tomar otro trabajo. Elige otra oferta.',
      });

      const active = await t.prisma.job.findMany({
        where: { workerId: worker.id, status: { in: ['asignado', 'en_camino', 'en_curso'] } },
      });
      expect(active).toHaveLength(1);
      const offer = await t.prisma.offer.findUniqueOrThrow({ where: { id: lost.offer.id } });
      expect(offer.status).toBe('retirada');
      // Era la única oferta: la solicitud vuelve a buscar.
      const req = await t.prisma.serviceRequest.findUniqueOrThrow({ where: { id: lost.req } });
      expect(req.status).toBe('buscando');
    });

    it('al ser elegido, sus otras ofertas activas se retiran y el otro empleador se entera', async () => {
      const { worker, a, b, reqA, reqB, offerA, offerB } = await twoOffers();
      const bLive = await connectSocket(t, b.accessToken);
      sockets.push(bLive);
      await post(a.accessToken, `/requests/${reqA}/offers/${offerA.id}/accept`).expect(200);

      expect(
        await bLive.next('offer:closed', (p) => p.requestId === reqB && p.reason === 'retirada'),
      ).toEqual({ requestId: reqB, reason: 'retirada', offerId: offerB.id });
      const offer = await t.prisma.offer.findUniqueOrThrow({ where: { id: offerB.id } });
      expect(offer.status).toBe('retirada');
      const req = await t.prisma.serviceRequest.findUniqueOrThrow({ where: { id: reqB } });
      expect(req.status).toBe('buscando');

      // Ocupado: no puede ofertar en otra mientras tenga un trabajo activo.
      const again = await post(worker.accessToken, `/requests/${reqB}/offers`, {
        type: 'accept',
      }).expect(409);
      expect(again.body).toMatchObject({ code: 'NOT_ELIGIBLE', reason: 'ocupado' });
    });
  });
});

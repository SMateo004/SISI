import request from 'supertest';
import type {
  AcceptOfferResultDto,
  EmployerOfferDto,
  IncomingRequestDto,
  JobContactDto,
  MyOfferDto,
} from '../src/offers/dto/offer.dto';
import type { RequestDto } from '../src/requests/dto/request.dto';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { connectSocket, type TestSocket } from './utils/socket';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  type TestApp,
  waitFor,
} from './utils/test-app';
import { createApprovedWorker, makeAvailable, type TestWorker } from './utils/workers';

describe('Ofertas, asignación y contacto (e2e, ADR-0026)', () => {
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

  const workerAt = async (slug: string, meters: number, name?: string) => {
    const w = await createApprovedWorker(t, { categorySlugs: [slug], transport: 'moto' });
    if (name) {
      await request(server())
        .patch('/me')
        .set(...bearer(w.accessToken))
        .send({ name })
        .expect(200);
    }
    await makeAvailable(t, w, eastOf(CENTRO, meters));
    return w;
  };

  const socketOf = async (u: { accessToken: string }) => {
    const s = await connectSocket(t, u.accessToken);
    sockets.push(s);
    return s;
  };

  const offer = (w: TestWorker, requestId: string, body: Record<string, unknown>) =>
    request(server())
      .post(`/requests/${requestId}/offers`)
      .set(...bearer(w.accessToken))
      .send(body);

  const offersOf = async (token: string, requestId: string) =>
    (
      await request(server())
        .get(`/requests/${requestId}/offers`)
        .set(...bearer(token))
        .expect(200)
    ).body as EmployerOfferDto[];

  const accept = (token: string, requestId: string, offerId: string) =>
    request(server())
      .post(`/requests/${requestId}/offers/${offerId}/accept`)
      .set(...bearer(token));

  const incoming = async (w: TestWorker, requestId: string) =>
    (
      await request(server())
        .get(`/worker/requests/${requestId}`)
        .set(...bearer(w.accessToken))
        .expect(200)
    ).body as IncomingRequestDto;

  const notified = async (requestId: string) =>
    (
      await t.prisma.requestNotification.findMany({
        where: { requestId },
        select: { workerId: true },
      })
    ).map((n) => n.workerId);

  it('flujo completo: aviso en vivo, oferta, contraoferta, elección y contacto revelado', async () => {
    const category = await createCategory(t);
    const ana = await workerAt(category.slug, 400, 'Ana Rojas Vaca');
    const beto = await workerAt(category.slug, 900, 'Beto Suárez');
    const [anaLive, betoLive] = [await socketOf(ana), await socketOf(beto)];

    const employer = await login(t);
    await request(server())
      .patch('/me')
      .set(...bearer(employer.accessToken))
      .send({ name: 'Carla Méndez' })
      .expect(200);
    const employerLive = await socketOf(employer);
    const id = await publishRequest(
      t,
      employer.accessToken,
      { categoryId: category.id },
      { photos: 1 },
    );

    await anaLive.next('request:new', (p) => p.requestId === id);
    await betoLive.next('request:new', (p) => p.requestId === id);

    // R5.1: distancia, descripción, fotos (URL temporal) y precio; nunca el contacto del empleador.
    const detail = await incoming(ana, id);
    expect(detail).toMatchObject({
      outcome: 'abierta',
      proposedPriceBs: '150.00',
      referenceRange: { minBs: '80.00', maxBs: '300.00' },
      maxCounterBs: '900.00',
      myOffer: null,
      jobId: null,
    });
    expect(detail.distanceM).toBeGreaterThan(350);
    expect(detail.photos).toHaveLength(1);
    expect(detail.photos[0]?.url).toMatch(/X-Amz-Signature/);
    expect(JSON.stringify(detail)).not.toMatch(/Carla|Méndez|\+591|Junín/);

    // Ana acepta el precio: la solicitud pasa a con_ofertas y el empleador la ve en vivo.
    const first = (await offer(ana, id, { type: 'accept' }).expect(200)).body as MyOfferDto;
    expect(first).toMatchObject({
      type: 'accept',
      amountBs: '150.00',
      status: 'activa',
      revision: 1,
    });
    expect(await employerLive.next('offer:new', (p) => p.requestId === id)).toMatchObject({
      offerId: first.id,
      type: 'accept',
      amountBs: '150.00',
      worker: { shortName: 'Ana R.' },
    });
    const afterFirst = (
      await request(server())
        .get(`/requests/${id}`)
        .set(...bearer(employer.accessToken))
        .expect(200)
    ).body as RequestDto;
    expect(afterFirst.status).toBe('con_ofertas');

    // Ana reemplaza su oferta con una contraoferta (una sola oferta activa por trabajador).
    const replaced = (await offer(ana, id, { type: 'counter', amountBs: '180' }).expect(200))
      .body as MyOfferDto;
    expect(replaced).toMatchObject({
      id: first.id,
      type: 'counter',
      amountBs: '180.00',
      revision: 2,
    });
    await employerLive.next('offer:new', (p) => p.amountBs === '180.00');

    // Tope de la contraoferta: 3 × el máximo de referencia.
    const tooHigh = await offer(beto, id, { type: 'counter', amountBs: '900.01' }).expect(400);
    expect(tooHigh.body).toMatchObject({ code: 'OFFER_AMOUNT_TOO_HIGH', maxBs: '900.00' });
    await offer(beto, id, { type: 'counter', amountBs: '0' }).expect(400);
    await offer(beto, id, { type: 'counter', amountBs: '200' }).expect(200);

    const list = await offersOf(employer.accessToken, id);
    expect(list.map((o) => [o.worker.shortName, o.amountBs])).toEqual([
      ['Ana R.', '180.00'],
      ['Beto S.', '200.00'],
    ]);
    expect(list[0]?.etaMin).toBeGreaterThanOrEqual(1);
    expect(JSON.stringify(list)).not.toMatch(/\+591|Rojas/);

    // Antes de elegir no hay contacto: el trabajo no existe.
    const chosen = list[0];
    if (!chosen) throw new Error('sin ofertas');
    const result = (await accept(employer.accessToken, id, chosen.id).expect(200))
      .body as AcceptOfferResultDto;

    expect(await anaLive.next('request:assigned', (p) => p.requestId === id)).toEqual({
      requestId: id,
      jobId: result.jobId,
    });
    expect(await betoLive.next('request:assigned', (p) => p.requestId === id)).toEqual({
      requestId: id,
      jobId: null,
    });
    expect(await betoLive.next('offer:closed', (p) => p.requestId === id)).toEqual({
      requestId: id,
      reason: 'elegida_otra',
    });

    const job = await t.prisma.job.findUniqueOrThrow({ where: { id: result.jobId } });
    expect(job).toMatchObject({
      workerId: ana.id,
      employerId: employer.user.id,
      status: 'asignado',
    });
    expect(job.finalPriceBs.toFixed(2)).toBe('180.00');
    expect(job.commissionPct.toFixed(2)).toBe('13.00');

    // R5.4 y R9.4: solo las dos partes ven el contacto.
    const forEmployer = (
      await request(server())
        .get(`/jobs/${result.jobId}/contact`)
        .set(...bearer(employer.accessToken))
        .expect(200)
    ).body as JobContactDto;
    expect(forEmployer).toMatchObject({
      role: 'worker',
      name: 'Ana Rojas Vaca',
      phone: ana.user.phone,
      address: null,
      finalPriceBs: '180.00',
    });
    const forWorker = (
      await request(server())
        .get(`/jobs/${result.jobId}/contact`)
        .set(...bearer(ana.accessToken))
        .expect(200)
    ).body as JobContactDto;
    expect(forWorker).toMatchObject({
      role: 'employer',
      name: 'Carla Méndez',
      phone: employer.user.phone,
      address: 'Calle Junín 150, entre Ayacucho y Sucre',
    });
    await request(server())
      .get(`/jobs/${result.jobId}/contact`)
      .set(...bearer(beto.accessToken))
      .expect(404);

    expect((await incoming(ana, id)).outcome).toBe('elegido');
    expect((await incoming(ana, id)).jobId).toBe(result.jobId);
    expect((await incoming(beto, id)).outcome).toBe('elegida_otra');
    const assigned = (
      await request(server())
        .get(`/requests/${id}`)
        .set(...bearer(employer.accessToken))
        .expect(200)
    ).body as RequestDto;
    expect(assigned).toMatchObject({ status: 'asignada', jobId: result.jobId });

    // Ya no se puede ofertar.
    const late = await offer(beto, id, { type: 'accept' }).expect(409);
    expect(late.body).toMatchObject({ code: 'OFFERS_CLOSED' });
  });

  it('dos aceptaciones simultáneas: solo una gana', async () => {
    const category = await createCategory(t);
    const a = await workerAt(category.slug, 300);
    const b = await workerAt(category.slug, 600);
    const employer = await login(t);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await waitFor(async () => ((await notified(id)).length === 2 ? true : undefined), {
      what: 'el anillo 1',
    });
    await offer(a, id, { type: 'accept' }).expect(200);
    await offer(b, id, { type: 'counter', amountBs: '170' }).expect(200);
    const [oa, ob] = await offersOf(employer.accessToken, id);
    if (!oa || !ob) throw new Error('faltan ofertas');

    const results = await Promise.all([
      accept(employer.accessToken, id, oa.id),
      accept(employer.accessToken, id, ob.id),
    ]);
    expect(results.map((r) => r.status).sort()).toEqual([200, 409]);
    const loser = results.find((r) => r.status === 409);
    expect(loser?.body).toMatchObject({ code: 'REQUEST_ALREADY_ASSIGNED' });
    expect(await t.prisma.job.count({ where: { requestId: id } })).toBe(1);
    expect(await t.prisma.offer.count({ where: { requestId: id, status: 'aceptada' } })).toBe(1);
  });

  it('un trabajador no notificado no puede ofertar ni ver la solicitud ni sus fotos', async () => {
    const category = await createCategory(t);
    await workerAt(category.slug, 300);
    const outsider = await createApprovedWorker(t, { categorySlugs: [category.slug] });
    const employer = await login(t);
    const id = await publishRequest(
      t,
      employer.accessToken,
      { categoryId: category.id },
      { photos: 1 },
    );
    await waitFor(async () => ((await notified(id)).length === 1 ? true : undefined), {
      what: 'el anillo 1',
    });

    await request(server())
      .get(`/worker/requests/${id}`)
      .set(...bearer(outsider.accessToken))
      .expect(404);
    const res = await offer(outsider, id, { type: 'accept' }).expect(404);
    expect(res.body).toMatchObject({ code: 'REQUEST_NOT_FOUND' });
    // Tampoco lo ve otro empleador.
    const other = await login(t);
    await request(server())
      .get(`/requests/${id}/offers`)
      .set(...bearer(other.accessToken))
      .expect(404);
  });

  it('un notificado que dejó de ser elegible no puede ofertar', async () => {
    const category = await createCategory(t);
    const w = await workerAt(category.slug, 300);
    const employer = await login(t);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await waitFor(async () => ((await notified(id)).length === 1 ? true : undefined), {
      what: 'el anillo 1',
    });
    await request(server())
      .patch('/me/mode')
      .set(...bearer(w.accessToken))
      .send({ mode: 'employer' })
      .expect(200);
    const res = await offer(w, id, { type: 'accept' }).expect(409);
    expect(res.body).toMatchObject({ code: 'NOT_ELIGIBLE', reason: 'no_modo_trabajador' });
  });

  it('con ofertas suficientes no amplía el anillo; sin elegir, expira y cierra las ofertas', async () => {
    const category = await createCategory(t);
    const near = await Promise.all([200, 400, 600].map((m) => workerAt(category.slug, m)));
    const far = await workerAt(category.slug, 3500);
    const live = await socketOf(near[0] ?? far);
    const employer = await login(t);
    const employerLive = await socketOf(employer);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await waitFor(async () => ((await notified(id)).length === 3 ? true : undefined), {
      what: 'el anillo 1',
    });
    for (const w of near) await offer(w, id, { type: 'accept' }).expect(200);

    // Pasado el plazo del anillo no se amplía: el de 3,5 km nunca recibe el aviso.
    const withDeadline = await waitFor(
      async () => {
        const r = (
          await request(server())
            .get(`/requests/${id}`)
            .set(...bearer(employer.accessToken))
        ).body as RequestDto;
        return r.expiresAt ? r : undefined;
      },
      { what: 'el plazo para elegir', timeoutMs: 6000 },
    );
    expect(withDeadline).toMatchObject({ status: 'con_ofertas', ring: 1 });
    expect(await notified(id)).not.toContain(far.id);

    // El empleador no elige: expira y se cierran las ofertas.
    await employerLive.next('request:expired', (p) => p.requestId === id, 8000);
    expect(await live.next('offer:closed', (p) => p.requestId === id)).toEqual({
      requestId: id,
      reason: 'expirada',
    });
    expect(await t.prisma.offer.count({ where: { requestId: id, status: 'activa' } })).toBe(0);
    expect((await incoming(near[0] ?? far, id)).outcome).toBe('expirada');
  });
});

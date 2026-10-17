import request from 'supertest';
import type { NotificationPageDto } from '../src/notifications/dto/notification.dto';
import { OutboxRelay } from '../src/outbox/outbox.relay';
import { BullJobPublisher } from '../src/queues/bull-job.publisher';
import { jobIds, QUEUES } from '../src/queues/queues';
import type { RequestDto } from '../src/requests/dto/request.dto';
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
import { createApprovedWorker, makeAvailable, type TestWorker } from './utils/workers';

describe('Matching por anillos (e2e, ADR-0025)', () => {
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

  /** Categoría propia del test: aísla de los trabajadores de otros tests. */
  const freshCategory = async () => createCategory(t);

  const workerAt = async (slug: string, meters: number, maxRadiusKm = 10) => {
    const w = await createApprovedWorker(t, { categorySlugs: [slug], maxRadiusKm });
    await makeAvailable(t, w, eastOf(CENTRO, meters));
    return w;
  };

  const socketOf = async (w: TestWorker | { accessToken: string }) => {
    const s = await connectSocket(t, w.accessToken);
    sockets.push(s);
    return s;
  };

  const notifiedIds = async (requestId: string, ring?: number) =>
    (
      await t.prisma.requestNotification.findMany({
        where: { requestId, ...(ring ? { ring } : {}) },
        select: { workerId: true },
      })
    ).map((n) => n.workerId);

  const getRequest = async (token: string, id: string) =>
    (
      await request(server())
        .get(`/requests/${id}`)
        .set(...bearer(token))
        .expect(200)
    ).body as RequestDto;

  it('anillo 1: avisa a los 5 más cercanos a 2 km o menos, en vivo y por push', async () => {
    const category = await freshCategory();
    const near = await Promise.all(
      [200, 400, 600, 800, 1000].map((m) => workerAt(category.slug, m)),
    );
    const sixth = await workerAt(category.slug, 1900);
    const far = await workerAt(category.slug, 3000);
    // A 1,5 km pero con radio máximo de 1 km: queda fuera por su propio radio.
    const shortRadius = await workerAt(category.slug, 1500, 1);
    const closest = near[0];
    if (!closest) throw new Error('sin trabajadores');
    const live = await socketOf(closest);

    const employer = await login(t);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });

    const event = await live.next('request:new', (p) => p.requestId === id);
    expect(event).toMatchObject({
      requestId: id,
      ring: 1,
      category: { slug: category.slug },
      proposedPriceBs: '150.00',
    });
    expect(event.distanceM).toBeGreaterThan(150);
    expect(event.distanceM).toBeLessThan(250);
    expect(new Date(event.respondBy).getTime()).toBeGreaterThan(Date.now());

    const ring1 = await notifiedIds(id, 1);
    expect(ring1.sort()).toEqual(near.map((w) => w.id).sort());
    expect(ring1).not.toContain(sixth.id);
    expect(ring1).not.toContain(far.id);
    expect(ring1).not.toContain(shortRadius.id);
    expect((await getRequest(employer.accessToken, id)).ring).toBe(1);

    const inbox = await waitFor(
      async () => {
        const page = (
          await request(server())
            .get('/me/notifications')
            .set(...bearer(closest.accessToken))
        ).body as NotificationPageDto;
        return page.items.find((n) => n.data.requestId === id);
      },
      { what: 'el aviso de solicitud nueva' },
    );
    expect(inbox).toMatchObject({ type: 'request_new', title: 'Nueva solicitud cerca' });
  });

  it('sin ofertas amplía al anillo 2 después de la espera y no repite avisos', async () => {
    const category = await freshCategory();
    const near = await workerAt(category.slug, 500);
    const mid = await workerAt(category.slug, 3500);
    const employer = await login(t);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });

    await waitFor(async () => ((await notifiedIds(id, 1)).length === 1 ? true : undefined), {
      what: 'el anillo 1',
    });
    expect(await notifiedIds(id, 2)).toEqual([]);

    await waitFor(async () => ((await notifiedIds(id, 2)).length === 1 ? true : undefined), {
      what: 'el anillo 2',
      timeoutMs: 10000,
    });
    expect(await notifiedIds(id, 2)).toEqual([mid.id]);
    expect(await notifiedIds(id)).toHaveLength(2);
    expect((await notifiedIds(id)).filter((w) => w === near.id)).toHaveLength(1);
  });

  it('sin trabajadores cerca busca el tiempo mínimo y después expira con aviso (R4.5)', async () => {
    const category = await freshCategory();
    const employer = await login(t);
    const live = await socketOf(employer);
    const startedAt = Date.now();
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });

    expect(await live.next('request:expired', (p) => p.requestId === id, 15000)).toEqual({
      requestId: id,
    });
    // No expira antes del mínimo de búsqueda (4 s en e2e).
    expect(Date.now() - startedAt).toBeGreaterThanOrEqual(3500);
    const detail = await getRequest(employer.accessToken, id);
    expect(detail).toMatchObject({
      status: 'expirada',
      statusMessage: 'Nadie ofertó a tiempo. Puedes publicarla de nuevo.',
    });

    const inbox = await waitFor(
      async () => {
        const page = (
          await request(server())
            .get('/me/notifications')
            .set(...bearer(employer.accessToken))
        ).body as NotificationPageDto;
        return page.items.find((n) => n.type === 'request_expired');
      },
      { what: 'el aviso de expiración' },
    );
    expect(inbox.title).toBe('Tu solicitud expiró');
  });

  it('durante el tiempo mínimo avisa a un trabajador que se conecta tarde', async () => {
    const category = await freshCategory();
    const employer = await login(t);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });

    // Todos los anillos están vacíos; el trabajador aparece 1,5 s después.
    await new Promise((r) => setTimeout(r, 1500));
    expect((await getRequest(employer.accessToken, id)).status).toBe('buscando');
    const late = await workerAt(category.slug, 7000);
    const live = await socketOf(late);

    const event = await live.next('request:new', (p) => p.requestId === id, 10000);
    expect(event.ring).toBe(3);
    expect(await notifiedIds(id)).toEqual([late.id]);
  });

  it('cancelar borra los anillos pendientes y avisa a los notificados con offer:closed', async () => {
    const category = await freshCategory();
    const worker = await workerAt(category.slug, 300);
    await workerAt(category.slug, 4000);
    const live = await socketOf(worker);
    const employer = await login(t);
    const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await live.next('request:new', (p) => p.requestId === id);

    const matching = t.app.get(BullJobPublisher).queue(QUEUES.matching);
    const ring2 = await waitFor(() => matching.getJob(jobIds.ring(id, 2)), {
      what: 'el anillo 2 programado',
    });
    expect(await ring2.getState()).toBe('delayed');

    await request(server())
      .post(`/requests/${id}/cancel`)
      .set(...bearer(employer.accessToken))
      .expect(200);

    expect(await live.next('offer:closed', (p) => p.requestId === id)).toEqual({
      requestId: id,
      reason: 'cancelada',
    });
    await waitFor(async () => ((await matching.getJob(jobIds.ring(id, 2))) ? undefined : true), {
      what: 'que se borre el anillo 2',
    });
    expect(await notifiedIds(id, 2)).toEqual([]);
  });

  it('un reinicio del relay no pierde el matching', async () => {
    const category = await freshCategory();
    const worker = await workerAt(category.slug, 250);
    const relay = t.app.get(OutboxRelay);
    await relay.stop();
    try {
      const employer = await login(t);
      const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });
      await new Promise((r) => setTimeout(r, 300));
      expect(await notifiedIds(id)).toEqual([]);

      relay.start();
      await waitFor(async () => ((await notifiedIds(id)).length > 0 ? true : undefined), {
        what: 'el anillo 1 tras reiniciar el relay',
      });
      expect(await notifiedIds(id)).toEqual([worker.id]);
    } finally {
      relay.start();
    }
  });

  it('con el flag matching.enabled apagado en la ciudad no avisa a nadie', async () => {
    const category = await freshCategory();
    await workerAt(category.slug, 250);
    const city = await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } });
    const flag = await t.prisma.featureFlag.findFirstOrThrow({
      where: { key: 'matching.enabled', cityId: city.id },
    });
    const admin = await loginAsAdmin(t);
    const setFlag = (enabled: boolean) =>
      request(server())
        .put('/admin/feature-flags/matching.enabled')
        .set(...bearer(admin.accessToken))
        .send({ enabled, cityId: city.id })
        .expect(200);

    await setFlag(false);
    try {
      const employer = await login(t);
      const id = await publishRequest(t, employer.accessToken, { categoryId: category.id });
      await new Promise((r) => setTimeout(r, 500));
      expect(await notifiedIds(id)).toEqual([]);
      expect((await getRequest(employer.accessToken, id)).status).toBe('buscando');
    } finally {
      await setFlag(flag.enabled);
    }
  });
});

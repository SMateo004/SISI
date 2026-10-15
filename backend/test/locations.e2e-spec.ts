import type { Redis } from 'ioredis';
import request from 'supertest';
import type { AvailabilityDto } from '../src/locations/dto/location.dto';
import { liveKeys, WorkerAvailabilityService } from '../src/locations/worker-availability.service';
import { REDIS_CLIENT } from '../src/redis/redis.constants';
import { WorkerStatusService } from '../src/workers/worker-status.service';
import { CENTRO, eastOf } from './utils/requests';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';
import { createApprovedWorker, makeAvailable } from './utils/workers';

describe('Ubicación y disponibilidad del trabajador (e2e, ADR-0024)', () => {
  let t: TestApp;
  let redis: Redis;
  let cityId: string;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp();
    redis = t.app.get<Redis>(REDIS_CLIENT);
    cityId = (await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } })).id;
  });

  afterAll(async () => {
    await t.close();
  });

  const availability = async (token: string) =>
    (
      await request(server())
        .get('/worker/availability')
        .set(...bearer(token))
        .expect(200)
    ).body as AvailabilityDto;

  const sendLocation = (token: string, at: { latitude: number; longitude: number }) =>
    request(server())
      .post('/worker/location')
      .set(...bearer(token))
      .send(at);

  const inLiveGeo = async (workerId: string) =>
    (await redis.geopos(liveKeys.geo(cityId), workerId))[0] !== null;

  it('activar exige modo trabajador y perfil aprobado, y la ubicación', async () => {
    const employer = await login(t);
    const denied = await request(server())
      .put('/worker/availability')
      .set(...bearer(employer.accessToken))
      .send({ available: true, ...CENTRO })
      .expect(409);
    expect(denied.body).toMatchObject({ code: 'WORKER_NOT_REQUESTED' });

    const worker = await createApprovedWorker(t);
    const noLocation = await request(server())
      .put('/worker/availability')
      .set(...bearer(worker.accessToken))
      .send({ available: true })
      .expect(400);
    expect(noLocation.body).toMatchObject({ code: 'LOCATION_REQUIRED' });

    await makeAvailable(t, worker);
    const state = await availability(worker.accessToken);
    expect(state).toMatchObject({ available: true, sendEverySec: 30, staleAfterSec: 600 });
    expect(state.locatedAt).not.toBeNull();
    expect(await inLiveGeo(worker.id)).toBe(true);
  });

  it('aprobado pero en modo empleador no puede activar', async () => {
    const worker = await createApprovedWorker(t);
    await request(server())
      .patch('/me/mode')
      .set(...bearer(worker.accessToken))
      .send({ mode: 'employer' })
      .expect(200);
    const res = await request(server())
      .put('/worker/availability')
      .set(...bearer(worker.accessToken))
      .send({ available: true, ...CENTRO })
      .expect(409);
    expect(res.body).toMatchObject({ code: 'WORKER_MODE_REQUIRED' });
  });

  it('persiste con throttling: Redis siempre, Postgres cada 30 s o al moverse 100 m', async () => {
    const worker = await createApprovedWorker(t);
    await makeAvailable(t, worker);

    // 20 m: solo copia en vivo.
    const small = await sendLocation(worker.accessToken, eastOf(CENTRO, 20)).expect(200);
    expect(small.body).toEqual({ persisted: false });
    // 150 m del último punto persistido: se guarda en Postgres.
    const moved = await sendLocation(worker.accessToken, eastOf(CENTRO, 150)).expect(200);
    expect(moved.body).toEqual({ persisted: true });

    const [row] = await t.prisma.$queryRaw<{ lng: number }[]>`
      SELECT ST_X(geog::geometry) AS lng FROM worker_locations WHERE worker_id = ${worker.id}::uuid`;
    expect(row?.lng).toBeCloseTo(eastOf(CENTRO, 150).longitude, 5);
  });

  it('sin "Disponible" no acepta ubicaciones; desactivar lo saca de Redis', async () => {
    const worker = await createApprovedWorker(t);
    const res = await sendLocation(worker.accessToken, CENTRO).expect(409);
    expect(res.body).toMatchObject({ code: 'NOT_AVAILABLE' });

    await makeAvailable(t, worker);
    await request(server())
      .put('/worker/availability')
      .set(...bearer(worker.accessToken))
      .send({ available: false })
      .expect(200);
    expect((await availability(worker.accessToken)).available).toBe(false);
    await new Promise((r) => setTimeout(r, 50));
    expect(await inLiveGeo(worker.id)).toBe(false);
  });

  it('pasar a modo empleador lo deja no disponible', async () => {
    const worker = await createApprovedWorker(t);
    await makeAvailable(t, worker);
    await request(server())
      .patch('/me/mode')
      .set(...bearer(worker.accessToken))
      .send({ mode: 'employer' })
      .expect(200);
    expect((await availability(worker.accessToken)).available).toBe(false);
  });

  it('un bloqueo por deuda o una suspensión lo dejan no disponible', async () => {
    const statuses = t.app.get(WorkerStatusService);
    const blocked = await createApprovedWorker(t);
    await makeAvailable(t, blocked);
    await statuses.apply(blocked.id, { type: 'BLOCK_FOR_DEBT' }, null);
    expect((await availability(blocked.accessToken)).available).toBe(false);

    const suspended = await createApprovedWorker(t);
    await makeAvailable(t, suspended);
    await statuses.apply(suspended.id, { type: 'SUSPEND', reason: 'Prueba' }, null);
    expect((await availability(suspended.accessToken)).available).toBe(false);
  });

  it('el barrido apaga a quien no envía ubicación hace más de 10 minutos', async () => {
    const fresh = await createApprovedWorker(t);
    const stale = await createApprovedWorker(t);
    await makeAvailable(t, fresh);
    await makeAvailable(t, stale);
    await t.prisma.workerLocation.update({
      where: { workerId: stale.id },
      data: { locatedAt: new Date(Date.now() - 11 * 60_000) },
    });

    expect(await t.app.get(WorkerAvailabilityService).sweepStale()).toBeGreaterThanOrEqual(1);
    expect((await availability(stale.accessToken)).available).toBe(false);
    expect((await availability(fresh.accessToken)).available).toBe(true);
  });
});

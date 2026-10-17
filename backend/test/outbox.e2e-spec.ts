import { OutboxCleanupService } from '../src/outbox/outbox-cleanup.service';
import type { Queue } from 'bullmq';
import { MatchingReconciler } from '../src/matching/matching.reconciler';
import { OutboxRelay } from '../src/outbox/outbox.relay';
import { BullJobPublisher } from '../src/queues/bull-job.publisher';
import { jobIds, QUEUES } from '../src/queues/queues';
import { publishRequest } from './utils/requests';
import { createTestApp, login, type TestApp, waitFor } from './utils/test-app';

describe('Outbox transaccional, relay y reconciliador (e2e, ADR-0022)', () => {
  let t: TestApp;
  let relay: OutboxRelay;
  let matching: Queue;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    relay = t.app.get(OutboxRelay);
    matching = t.app.get(BullJobPublisher).queue(QUEUES.matching);
  });

  afterAll(async () => {
    await t.close();
  });

  afterEach(() => {
    relay.start();
  });

  const ringJob = (requestId: string) => matching.getJob(jobIds.ring(requestId, 1));

  const published = async (requestId: string) =>
    (
      await t.prisma.outboxEvent.findFirstOrThrow({
        where: { aggregateId: requestId, type: 'request.searching' },
      })
    ).publishedAt;

  it('publicar deja el evento en el outbox y el relay encola el anillo 1', async () => {
    const { accessToken } = await login(t);
    const id = await publishRequest(t, accessToken);

    const job = await waitFor(ringJob.bind(null, id), { what: 'el job del anillo 1' });
    expect(job.data).toEqual({ requestId: id, ring: 1 });
    await waitFor(async () => (await published(id)) ?? undefined, {
      what: 'que el evento quede publicado',
    });
  });

  it('con el relay detenido el evento espera en la base; al reiniciarlo se publica', async () => {
    await relay.stop();
    const { accessToken } = await login(t);
    const id = await publishRequest(t, accessToken);

    await new Promise((r) => setTimeout(r, 300));
    expect(await published(id)).toBeNull();
    expect(await ringJob(id)).toBeUndefined();

    relay.start();
    await waitFor(ringJob.bind(null, id), { what: 'el job tras reiniciar el relay' });
  });

  it('volver a publicar un evento ya publicado no duplica el job (jobId determinístico)', async () => {
    const { accessToken } = await login(t);
    const id = await publishRequest(t, accessToken);
    const first = await waitFor(ringJob.bind(null, id), { what: 'el job del anillo 1' });
    await waitFor(async () => (await published(id)) ?? undefined, { what: 'la publicación' });

    // Simula una caída entre encolar y marcar: el relay lo vuelve a tomar.
    await relay.stop();
    await t.prisma.outboxEvent.updateMany({
      where: { aggregateId: id },
      data: { publishedAt: null },
    });
    expect(await relay.runOnce()).toBeGreaterThan(0);

    const jobs = await matching.getJobs(['waiting', 'delayed', 'active', 'completed']);
    const ring1 = jobs.filter((j) => j.id === jobIds.ring(id, 1));
    expect(ring1).toHaveLength(1);
    expect(ring1[0]?.timestamp).toBe(first.timestamp);
  });

  it('el reconciliador vuelve a encolar una solicitud abierta sin su job', async () => {
    // Se pierde el job (Redis restaurado, borrado a mano...): el outbox figura publicado,
    // la solicitud sigue en buscando y no hay ningún job de matching para ella.
    await relay.stop();
    const { accessToken } = await login(t);
    const id = await publishRequest(t, accessToken);
    await t.prisma.outboxEvent.updateMany({
      where: { aggregateId: id },
      data: { publishedAt: new Date() },
    });
    expect(await ringJob(id)).toBeUndefined();

    const reconciler = t.app.get(MatchingReconciler);
    await reconciler.runOnce();
    const job = await waitFor(ringJob.bind(null, id), { what: 'el anillo 1 reencolado' });

    // Con el job presente (esperando, activo o ya completado) no lo vuelve a encolar.
    await reconciler.runOnce();
    expect((await ringJob(id))?.timestamp).toBe(job.timestamp);
  });

  it('la limpieza borra solo los eventos publicados hace más de 7 días', async () => {
    const day = 24 * 3600_000;
    const aggregateId = '00000000-0000-4000-8000-0000000000c1';
    const mk = (publishedAgoDays: number | null) =>
      t.prisma.outboxEvent.create({
        data: {
          type: 'request.held',
          aggregateId,
          payload: { requestId: aggregateId, matchCount: 0 },
          createdAt: new Date(Date.now() - 10 * day),
          publishedAt:
            publishedAgoDays === null ? null : new Date(Date.now() - publishedAgoDays * day),
        },
      });
    const old = await mk(8);
    const recent = await mk(2);
    // Pendiente y viejo: nunca se borra (todavía no se publicó). Con el relay detenido.
    await relay.stop();
    const pending = await mk(null);

    expect(await t.app.get(OutboxCleanupService).runOnce()).toBeGreaterThanOrEqual(1);
    const left = (
      await t.prisma.outboxEvent.findMany({ where: { aggregateId }, select: { id: true } })
    ).map((e) => e.id);
    expect(left).not.toContain(old.id);
    expect(left).toEqual(expect.arrayContaining([recent.id, pending.id]));
    await t.prisma.outboxEvent.deleteMany({ where: { aggregateId } });
  });
});

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
    const forRequest = jobs.filter((j) => (j.data as { requestId?: string }).requestId === id);
    expect(forRequest).toHaveLength(1);
    expect(forRequest[0]?.timestamp).toBe(first.timestamp);
  });

  it('el reconciliador vuelve a encolar una solicitud abierta sin su job', async () => {
    const { accessToken } = await login(t);
    const id = await publishRequest(t, accessToken);
    const job = await waitFor(ringJob.bind(null, id), { what: 'el job del anillo 1' });
    await waitFor(async () => ((await job.isCompleted()) ? true : undefined), {
      what: 'que el job termine',
    });

    const reconciler = t.app.get(MatchingReconciler);
    // Con el job presente (aunque ya haya corrido) no hace nada.
    expect(await reconciler.runOnce()).toBe(0);

    // Se pierde el job (Redis restaurado, borrado a mano...): lo reprograma.
    await job.remove();
    expect(await ringJob(id)).toBeUndefined();
    expect(await reconciler.runOnce()).toBe(1);
    expect(await ringJob(id)).toBeDefined();
  });
});

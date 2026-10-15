import type { JobRoute } from '../queues/queues';
import {
  type BatchResult,
  type JobPublisher,
  OutboxRelayCore,
  type OutboxStore,
  retryDelayMs,
} from './outbox-relay.core';
import type { OutboxRecord } from './outbox.events';
import { routeEvent } from './outbox.routes';

/** Outbox en memoria con la misma semántica que la tabla: publicado o pendiente. */
class MemoryStore implements OutboxStore {
  rows: (OutboxRecord & { published: boolean; lastError?: string })[] = [];

  add(type: string, aggregateId: string, payload: unknown = {}): OutboxRecord {
    const row = { id: BigInt(this.rows.length + 1), type, aggregateId, payload, attempts: 0 };
    this.rows.push({ ...row, published: false });
    return row;
  }

  async withBatch(limit: number, handle: (e: OutboxRecord[]) => Promise<BatchResult>) {
    const batch = this.rows.filter((r) => !r.published).slice(0, limit);
    if (batch.length === 0) return 0;
    const { published, failed } = await handle(batch);
    for (const r of this.rows) {
      if (published.includes(r.id)) r.published = true;
      const f = failed.find((x) => x.id === r.id);
      if (f) {
        r.attempts++;
        r.lastError = f.error;
      }
    }
    return batch.length;
  }
}

/** Publicador que, como BullMQ, ignora un jobId que ya existe. */
class DedupPublisher implements JobPublisher {
  jobs = new Map<string, JobRoute>();
  adds = 0;
  failNext = 0;

  publish(route: JobRoute): Promise<void> {
    if (this.failNext > 0) {
      this.failNext--;
      return Promise.reject(new Error('Redis no responde'));
    }
    this.adds++;
    if (!this.jobs.has(route.jobId)) this.jobs.set(route.jobId, route);
    return Promise.resolve();
  }
}

describe('Outbox (ADR-0022)', () => {
  it('request.searching va a la cola de matching con el jobId del anillo 1', () => {
    const route = routeEvent({
      id: 7n,
      type: 'request.searching',
      aggregateId: 'r1',
      payload: { requestId: 'r1' },
      attempts: 0,
    });
    expect(route).toEqual({
      queue: 'matching',
      name: 'ring',
      jobId: 'ring_r1_1',
      data: { requestId: 'r1', ring: 1 },
    });
  });

  it('los demás eventos van a la cola de eventos con jobId derivado del outbox', () => {
    const route = routeEvent({
      id: 42n,
      type: 'request.held',
      aggregateId: 'r1',
      payload: { requestId: 'r1', matchCount: 2 },
      attempts: 0,
    });
    expect(route).toMatchObject({ queue: 'events', name: 'request.held', jobId: 'evt_42' });
    expect(route.jobId).not.toContain(':');
  });

  it('publica lo pendiente y lo marca; una segunda pasada no hace nada', async () => {
    const store = new MemoryStore();
    const publisher = new DedupPublisher();
    store.add('request.searching', 'r1');
    store.add('request.held', 'r2');
    const relay = new OutboxRelayCore(store, publisher, 10);

    expect(await relay.runOnce()).toBe(2);
    expect([...publisher.jobs.keys()]).toEqual(['ring_r1_1', 'evt_2']);
    expect(await relay.runOnce()).toBe(0);
  });

  it('si cae entre encolar y marcar, republicar no duplica el job', async () => {
    const store = new MemoryStore();
    const publisher = new DedupPublisher();
    store.add('request.searching', 'r1');
    const relay = new OutboxRelayCore(store, publisher, 10);
    await relay.runOnce();

    // La marca de publicado se perdió (el proceso murió antes de confirmar).
    const [row] = store.rows;
    if (row) row.published = false;
    await relay.runOnce();

    expect(publisher.adds).toBe(2);
    expect(publisher.jobs.size).toBe(1);
  });

  it('un fallo de Redis deja el evento pendiente con el error y reintenta', async () => {
    const store = new MemoryStore();
    const publisher = new DedupPublisher();
    store.add('request.searching', 'r1');
    store.add('request.held', 'r2');
    publisher.failNext = 1;
    const relay = new OutboxRelayCore(store, publisher, 10);

    await relay.runOnce();
    expect(store.rows[0]).toMatchObject({
      published: false,
      attempts: 1,
      lastError: 'Redis no responde',
    });
    expect(store.rows[1]?.published).toBe(true);

    await relay.runOnce();
    expect(store.rows[0]?.published).toBe(true);
  });

  it('respeta el tamaño de lote', async () => {
    const store = new MemoryStore();
    for (let i = 0; i < 5; i++) store.add('request.held', `r${i}`);
    const relay = new OutboxRelayCore(store, new DedupPublisher(), 2);
    expect(await relay.runOnce()).toBe(2);
    expect(store.rows.filter((r) => r.published)).toHaveLength(2);
  });

  it('la espera entre reintentos crece y tiene tope de 5 minutos', () => {
    expect(retryDelayMs(1)).toBe(2000);
    expect(retryDelayMs(3)).toBe(8000);
    expect(retryDelayMs(50)).toBe(300_000);
  });
});

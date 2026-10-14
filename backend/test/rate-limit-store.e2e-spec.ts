import { RateLimitStore } from '../src/common/rate-limit/rate-limit.store';
import { RedisThrottlerStorage } from '../src/common/rate-limit/redis-throttler.storage';
import { createTestApp, type TestApp } from './utils/test-app';

/** Scripts Lua del RateLimitStore contra Redis real. */
describe('RateLimitStore (e2e, Redis real)', () => {
  let t: TestApp;
  let store: RateLimitStore;
  const prefix = `test:${Date.now()}`;

  beforeAll(async () => {
    t = await createTestApp();
    store = t.app.get(RateLimitStore);
  });

  afterAll(async () => {
    await t.close();
  });

  it('consume: permite hasta el límite y luego informa la espera', async () => {
    const rule = { key: `${prefix}:a`, limit: 3, windowSec: 60 };
    for (let i = 0; i < 3; i++) expect(await store.consume([rule])).toEqual({ allowed: true });
    const denied = await store.consume([rule]);
    expect(denied).toMatchObject({ allowed: false, rule });
    expect(denied.allowed ? 0 : denied.retryAfterSec).toBeGreaterThan(55);
  });

  it('consume: si una regla está agotada no se consume cupo de las demás', async () => {
    const tight = { key: `${prefix}:tight`, limit: 1, windowSec: 60 };
    const loose = { key: `${prefix}:loose`, limit: 2, windowSec: 60 };
    expect((await store.consume([tight, loose])).allowed).toBe(true);
    expect((await store.consume([tight, loose])).allowed).toBe(false);
    expect((await store.consume([tight, loose])).allowed).toBe(false);
    // loose solo se usó una vez: todavía admite una más.
    expect((await store.consume([loose])).allowed).toBe(true);
    expect((await store.consume([loose])).allowed).toBe(false);
  });

  it('las ventanas vencen', async () => {
    const rule = { key: `${prefix}:short`, limit: 1, windowSec: 1 };
    expect((await store.consume([rule])).allowed).toBe(true);
    expect((await store.consume([rule])).allowed).toBe(false);
    await new Promise((r) => setTimeout(r, 1100));
    expect((await store.consume([rule])).allowed).toBe(true);
  });

  it('storage del throttler: bloquea al pasar el límite durante blockDuration', async () => {
    const storage = t.app.get(RedisThrottlerStorage);
    const key = `${prefix}:throttler`;
    expect((await storage.increment(key, 60_000, 2, 30_000, 'global')).isBlocked).toBe(false);
    expect((await storage.increment(key, 60_000, 2, 30_000, 'global')).isBlocked).toBe(false);
    const third = await storage.increment(key, 60_000, 2, 30_000, 'global');
    expect(third).toMatchObject({ isBlocked: true, totalHits: 3 });
    expect(third.timeToBlockExpire).toBeGreaterThan(25);
    expect(third.timeToBlockExpire).toBeLessThanOrEqual(30);
    // Mientras dura el bloqueo sigue bloqueado.
    expect((await storage.increment(key, 60_000, 2, 30_000, 'global')).isBlocked).toBe(true);
  });
});

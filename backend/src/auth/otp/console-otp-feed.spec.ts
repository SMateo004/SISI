import type { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../../config/app-config';
import { ConsoleOtpFeed } from './console-otp-feed';

/** Redis de mentira: solo el hash que usa el feed. */
function fakeRedis() {
  const hash = new Map<string, string>();
  const redis = {
    hset: jest.fn((_k: string, f: string, v: string) => {
      hash.set(f, v);
      return Promise.resolve(1);
    }),
    hget: jest.fn((_k: string, f: string) => Promise.resolve(hash.get(f) ?? null)),
    hgetall: jest.fn(() => Promise.resolve(Object.fromEntries(hash))),
    hdel: jest.fn((_k: string, ...f: string[]) => {
      f.forEach((x) => hash.delete(x));
      return Promise.resolve(f.length);
    }),
    multi: () => {
      const ops: (() => Promise<unknown>)[] = [];
      const chain = {
        hset: (k: string, f: string, v: string) => {
          ops.push(() => redis.hset(k, f, v));
          return chain;
        },
        expire: () => chain,
        exec: async () => {
          for (const op of ops) await op();
          return [];
        },
      };
      return chain;
    },
  };
  return { redis, hash };
}

const config = (env: Record<string, string>) =>
  ({ get: (k: string) => env[k] }) as unknown as AppConfigService & ConfigService;

describe('ConsoleOtpFeed (ADR-0056)', () => {
  const now = new Date('2026-10-19T12:00:00Z');

  it('con OTP por consola fuera de producción guarda, marca el uso y vence', async () => {
    const { redis } = fakeRedis();
    const feed = new ConsoleOtpFeed(
      redis as unknown as Redis,
      config({ OTP_PROVIDER: 'console', APP_ENV: 'staging' }),
    );
    expect(feed.enabled).toBe(true);
    await feed.record('+59170000001', '123456', 300, now);
    await feed.record('+59170000002', '654321', 300, new Date(now.getTime() + 1000));
    await feed.markUsed('+59170000001', now);

    const list = await feed.list(now);
    expect(list.map((e) => e.phone)).toEqual(['+59170000002', '+59170000001']);
    expect(list[1]).toMatchObject({ code: '123456', usedAt: now.toISOString() });

    // A los 5 minutos ya no se muestran (y se borran).
    expect(await feed.list(new Date(now.getTime() + 302_000))).toEqual([]);
    expect(redis.hdel).toHaveBeenCalled();
  });

  it('en producción o con SMS real no guarda ni muestra nada', async () => {
    for (const env of [
      { OTP_PROVIDER: 'console', APP_ENV: 'production' },
      { OTP_PROVIDER: 'bird', APP_ENV: 'staging' },
    ]) {
      const { redis, hash } = fakeRedis();
      const feed = new ConsoleOtpFeed(redis as unknown as Redis, config(env));
      expect(feed.enabled).toBe(false);
      await feed.record('+59170000001', '123456', 300, now);
      expect(hash.size).toBe(0);
      expect(await feed.list(now)).toEqual([]);
      expect(redis.hgetall).not.toHaveBeenCalled();
    }
  });
});

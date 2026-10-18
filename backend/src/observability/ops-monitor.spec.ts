import type { Queue } from 'bullmq';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import type { PrismaService } from '../prisma/prisma.service';
import type { OpsMetrics } from './ops-metrics';
import { OpsMonitor } from './ops-monitor';

const NOW = Date.UTC(2026, 9, 20, 12, 0, 0);
const MIN = 60_000;

const ENV: Record<string, number> = {
  OPS_MONITOR_MS: MIN,
  OPS_WINDOW_MS: 10 * MIN,
  OPS_OUTBOX_MAX_AGE_MS: 5 * MIN,
  OPS_QUEUE_MAX_WAIT_MS: 5 * MIN,
  OPS_QUEUE_FAILED_DELTA: 10,
  OPS_OTP_FAIL_THRESHOLD: 5,
  OPS_PUSH_FAIL_THRESHOLD: 20,
  OPS_PUSH_FAIL_RATIO: 0.2,
};

function setup(state: {
  outboxOldest?: Date | null;
  waitingTimestamp?: number;
  failed?: number[];
  metrics?: Partial<Record<'otp_fail' | 'push_sent' | 'push_fail', number>>;
}) {
  const failedSeen = new Map<string, string>();
  const redis = {
    set: jest.fn((key: string, value: string, ...args: string[]) => {
      if (args.includes('GET')) {
        const prev = failedSeen.get(key) ?? null;
        failedSeen.set(key, value);
        return Promise.resolve(prev);
      }
      return Promise.resolve('OK');
    }),
  };
  const queue = (name: string, failedSeq: number[]) => ({
    name,
    getJobs: jest.fn(() =>
      Promise.resolve(
        state.waitingTimestamp === undefined ? [] : [{ timestamp: state.waitingTimestamp }],
      ),
    ),
    getWaitingCount: jest.fn(() => Promise.resolve(3)),
    getFailedCount: jest.fn(() => Promise.resolve(failedSeq.shift() ?? 0)),
  });
  const prisma = {
    $queryRaw: jest.fn(() =>
      Promise.resolve([{ createdAt: state.outboxOldest ?? null, pending: 2n }]),
    ),
  };
  const metrics = {
    recent: jest.fn((m: 'otp_fail' | 'push_sent' | 'push_fail') =>
      Promise.resolve(state.metrics?.[m] ?? 0),
    ),
  };
  const config = { get: (key: string) => ENV[key] } as unknown as AppConfigService;
  return new OpsMonitor(
    prisma as unknown as PrismaService,
    metrics as unknown as OpsMetrics,
    redis as unknown as Redis,
    queue('matching', [...(state.failed ?? [])]) as unknown as Queue,
    queue('events', []) as unknown as Queue,
    config,
  );
}

describe('OpsMonitor (ADR-0048)', () => {
  it('todo en orden: sin alertas', async () => {
    const monitor = setup({ outboxOldest: new Date(NOW - MIN), waitingTimestamp: NOW - MIN });
    expect(await monitor.check(NOW)).toEqual([]);
  });

  it('outbox con un evento sin publicar hace más de 5 min', async () => {
    const alerts = await setup({ outboxOldest: new Date(NOW - 6 * MIN) }).check(NOW);
    expect(alerts.map((a) => a.kind)).toEqual(['outbox_stuck']);
    expect(alerts[0]?.extra).toMatchObject({ pending: 2, oldestAgeSec: 360 });
  });

  it('cola con un job esperando más de 5 min', async () => {
    const alerts = await setup({ waitingTimestamp: NOW - 6 * MIN }).check(NOW);
    expect(alerts.map((a) => a.kind)).toEqual(['queue_stuck', 'queue_stuck']);
  });

  it('fallidos que crecen 10 o más entre dos vueltas', async () => {
    const monitor = setup({ failed: [100, 105, 120] });
    expect(await monitor.check(NOW)).toEqual([]); // primera vuelta: solo registra
    expect(await monitor.check(NOW)).toEqual([]); // +5
    const third = await monitor.check(NOW); // +15
    expect(third.map((a) => a.kind)).toEqual(['queue_failing']);
    expect(third[0]?.extra).toMatchObject({ queue: 'matching', delta: 15 });
  });

  it('OTP: 5 fallos en la ventana', async () => {
    const kinds = async (otp: number) =>
      (await setup({ metrics: { otp_fail: otp } }).check(NOW)).map((a) => a.kind);
    expect(await kinds(4)).toEqual([]);
    expect(await kinds(5)).toEqual(['otp_failing']);
  });

  it('push: 20 fallos o el 20 % con al menos 10 envíos', async () => {
    const kinds = async (sent: number, failed: number) =>
      (await setup({ metrics: { push_sent: sent, push_fail: failed } }).check(NOW)).map(
        (a) => a.kind,
      );
    expect(await kinds(100, 19)).toEqual([]);
    expect(await kinds(1000, 20)).toEqual(['push_failing']);
    expect(await kinds(10, 2)).toEqual(['push_failing']);
    expect(await kinds(5, 2)).toEqual([]); // muy pocos envíos para una proporción
  });
});

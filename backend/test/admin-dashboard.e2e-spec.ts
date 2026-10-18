import request from 'supertest';
import { counterQueries, dashboardQueries, pilotQueries } from '../src/dashboard/dashboard.service';
import type {
  CountersDto,
  DashboardDto,
  PilotMetricsDto,
} from '../src/dashboard/dto/dashboard.dto';
import { Prisma } from '../src/generated/prisma/client';
import { assignJob, completeJob } from './utils/jobs';
import {
  type AdminSession,
  bearer,
  createTestApp,
  loginAsAdmin,
  type TestApp,
  waitFor,
} from './utils/test-app';
import { createPendingWorker } from './utils/workers';

/** Tablas grandes: ninguna consulta del dashboard puede recorrerlas enteras. */
const BIG = new Set([
  'service_requests',
  'jobs',
  'ledger_entries',
  'offer_events',
  'billing_periods',
  'worker_locations',
  'chat_messages',
  'reports',
  'payment_submissions',
  'worker_profiles',
]);

interface PlanNode {
  'Node Type': string;
  'Relation Name'?: string;
  Plans?: PlanNode[];
}

function seqScans(node: PlanNode, out: string[] = []): string[] {
  if (node['Node Type'] === 'Seq Scan' && BIG.has(node['Relation Name'] ?? '')) {
    out.push(node['Relation Name'] ?? '');
  }
  for (const child of node.Plans ?? []) seqScans(child, out);
  return out;
}

describe('Dashboard del panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const get = <T>(path: string, query: Record<string, string> = {}) =>
    request(t.app.getHttpServer())
      .get(path)
      .query(query)
      .set(...bearer(admin.accessToken))
      .expect(200)
      .then((r) => r.body as T);

  it('refleja la actividad del día: solicitud, asignación, trabajo terminado, comisión y colas', async () => {
    const before = await get<DashboardDto>('/admin/dashboard');
    const job = await assignJob(t);
    await completeJob(t, job);
    await waitFor(
      () =>
        t.prisma.ledgerEntry.findFirst({ where: { jobId: job.jobId } }).then((e) => e ?? undefined),
      { what: 'la comisión' },
    );
    await createPendingWorker(t);

    const after = await get<DashboardDto>('/admin/dashboard');
    expect(after.range).toBe('day');
    expect(after.requestsCreated - before.requestsCreated).toBe(1);
    expect(after.jobsCompleted - before.jobsCompleted).toBe(1);
    expect(
      new Prisma.Decimal(after.commissionGeneratedBs).sub(before.commissionGeneratedBs).toFixed(2),
    ).toBe('19.50');
    expect(after.assignmentRatePct).not.toBeNull();
    expect(after.avgFirstOfferSec).not.toBeNull();
    expect(after.workersAvailableNow).toBeGreaterThanOrEqual(1);
    expect(after.queues.verifications - before.queues.verifications).toBe(1);

    const week = await get<DashboardDto>('/admin/dashboard', { range: 'week' });
    expect(week.requestsCreated).toBeGreaterThanOrEqual(after.requestsCreated);
    const counters = await get<CountersDto>('/admin/counters');
    expect(counters).toEqual(after.queues);
  });

  it('ninguna consulta del dashboard ni de las colas recorre una tabla grande entera (EXPLAIN)', async () => {
    const city = await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } });
    const now = Date.now();
    const queries = {
      ...dashboardQueries({
        cityId: city.id,
        from: new Date(now - 86_400_000),
        to: new Date(now),
        freshSince: new Date(now - 600_000),
      }),
      ...counterQueries,
      ...Object.fromEntries(
        Object.entries(
          pilotQueries({ cityId: city.id, from: new Date(now - 86_400_000), to: new Date(now) }),
        ).map(([k, v]) => [`pilot.${k}`, v]),
      ),
    };
    const problems: string[] = [];
    for (const [name, sql] of Object.entries(queries)) {
      // Con tablas casi vacías el planner prefiere Seq Scan; sin él, solo queda si no hay índice.
      const plan = await t.prisma.$transaction(async (tx) => {
        await tx.$executeRaw`SET LOCAL enable_seqscan = off`;
        const [row] = await tx.$queryRaw<{ 'QUERY PLAN': { Plan: PlanNode }[] }[]>(
          Prisma.sql`EXPLAIN (FORMAT JSON) ${sql}`,
        );
        return row?.['QUERY PLAN'][0]?.Plan;
      });
      if (!plan) throw new Error(`Sin plan para ${name}`);
      for (const table of seqScans(plan)) problems.push(`${name}: Seq Scan en ${table}`);
    }
    expect(problems).toEqual([]);
  });

  it('métricas del piloto: embudo, tasas y retención semanal (ADR-0052)', async () => {
    const before = await get<PilotMetricsDto>('/admin/dashboard/pilot');
    const job = await assignJob(t);
    await completeJob(t, job);
    const after = await waitFor(
      async () => {
        const m = await get<PilotMetricsDto>('/admin/dashboard/pilot');
        return m.funnel.completed > before.funnel.completed ? m : undefined;
      },
      { what: 'el trabajo terminado en el embudo' },
    );
    expect(after.funnel.created).toBe(before.funnel.created + 1);
    expect(after.funnel.withOffer).toBe(before.funnel.withOffer + 1);
    expect(after.funnel.assigned).toBe(before.funnel.assigned + 1);
    // Sin inicio configurado, las últimas 8 semanas; la última es la actual.
    expect(after.startedAt).toBeNull();
    expect(after.weekly.length).toBeGreaterThan(0);
    expect(after.weekly.length).toBeLessThanOrEqual(8);
    const current = after.weekly.at(-1);
    expect(current?.activeWorkers).toBeGreaterThanOrEqual(1);
    expect(current?.activeEmployers).toBeGreaterThanOrEqual(1);
    expect(after.weekly[0]?.workerRetentionPct).toBeNull();
    expect(after.collectionRatePct === null || after.collectionRatePct >= 0).toBe(true);
  });
});

import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { addDays, fromLocal, toLocal } from '../billing/zoned-time';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type { CountersDto, DashboardDto } from './dto/dashboard.dto';

export type DashboardRange = 'day' | 'week';

/** Hoy o esta semana (lunes a domingo) en la hora local de la ciudad. */
export function rangeBounds(
  range: DashboardRange,
  now: Date,
  timeZone: string,
): { from: Date; to: Date } {
  const local = toLocal(now, timeZone);
  // Solo la fecha: las 00:00 locales (sin la hora actual).
  const today = { year: local.year, month: local.month, day: local.day };
  const start = range === 'day' ? today : addDays(today, 1 - local.weekday);
  const end = addDays(start, range === 'day' ? 1 : 7);
  return { from: fromLocal(start, timeZone), to: fromLocal(end, timeZone) };
}

interface QueryInput {
  cityId: string;
  from: Date;
  to: Date;
  freshSince: Date;
}

/**
 * Consultas del dashboard (Fase 6). Cada una se acota por ciudad y rango sobre una columna
 * indexada (ver la migración 20261019060000_dashboard_indexes); el e2e corre EXPLAIN de cada
 * una y falla si aparece un escaneo completo de las tablas grandes.
 */
export function dashboardQueries(q: QueryInput): Record<string, Prisma.Sql> {
  return {
    requests: Prisma.sql`
      SELECT COUNT(*)::int AS total,
             COUNT(*) FILTER (WHERE r.status = 'expirada')::int AS expired,
             COUNT(j.id)::int AS assigned
      FROM service_requests r
      LEFT JOIN jobs j ON j.request_id = r.id
      WHERE r.city_id = ${q.cityId}::uuid AND r.created_at >= ${q.from} AND r.created_at < ${q.to}
        AND r.status <> 'borrador'`,
    firstOffer: Prisma.sql`
      SELECT AVG(EXTRACT(EPOCH FROM (f.first_at - r.published_at)))::float AS seconds
      FROM service_requests r
      JOIN LATERAL (
        SELECT MIN(e.created_at) AS first_at FROM offer_events e
        WHERE e.request_id = r.id AND e.kind = 'creada'
      ) f ON f.first_at IS NOT NULL
      WHERE r.city_id = ${q.cityId}::uuid AND r.created_at >= ${q.from} AND r.created_at < ${q.to}
        AND r.published_at IS NOT NULL`,
    completed: Prisma.sql`
      SELECT COUNT(*)::int AS n FROM jobs
      WHERE city_id = ${q.cityId}::uuid AND completed_at >= ${q.from} AND completed_at < ${q.to}
        AND status = 'terminado'`,
    cancellations: Prisma.sql`
      SELECT COALESCE(cancel_reason::text, 'disputa_admin') AS reason, COUNT(*)::int AS n
      FROM jobs
      WHERE city_id = ${q.cityId}::uuid AND cancelled_at >= ${q.from} AND cancelled_at < ${q.to}
      GROUP BY 1 ORDER BY 2 DESC`,
    commission: Prisma.sql`
      SELECT COALESCE(SUM(amount_bs) FILTER (WHERE type = 'comision'), 0)::text AS generated,
             COALESCE(-SUM(amount_bs) FILTER (WHERE type = 'pago'), 0)::text AS collected
      FROM ledger_entries
      WHERE type IN ('comision', 'pago') AND created_at >= ${q.from} AND created_at < ${q.to}
        AND city_id = ${q.cityId}::uuid`,
    overdue: Prisma.sql`
      SELECT COALESCE(SUM(e.amount_bs), 0)::text AS total, COUNT(DISTINCT p.worker_id)::int AS workers
      FROM billing_periods p JOIN ledger_entries e ON e.period_id = p.id
      WHERE p.status = 'vencido' AND p.city_id = ${q.cityId}::uuid`,
    available: Prisma.sql`
      SELECT COUNT(*)::int AS n FROM worker_locations
      WHERE available AND located_at >= ${q.freshSince} AND city_id = ${q.cityId}::uuid`,
  };
}

/** Colas pendientes del panel (todas las ciudades): conteos sobre índices por estado. */
export const counterQueries: Record<keyof CountersDto, Prisma.Sql> = {
  verifications: Prisma.sql`SELECT COUNT(*)::int AS n FROM worker_profiles WHERE status = 'pendiente_revision'`,
  heldRequests: Prisma.sql`SELECT COUNT(*)::int AS n FROM service_requests WHERE status = 'retenida'`,
  heldMessages: Prisma.sql`SELECT COUNT(*)::int AS n FROM chat_messages WHERE status = 'retenido'`,
  reports: Prisma.sql`SELECT COUNT(*)::int AS n FROM reports WHERE status = 'pendiente'`,
  disputes: Prisma.sql`SELECT COUNT(*)::int AS n FROM jobs WHERE status = 'en_curso' AND disputed_at IS NOT NULL`,
  submissions: Prisma.sql`SELECT COUNT(*)::int AS n FROM payment_submissions WHERE status = 'pendiente'`,
};

@Injectable()
export class DashboardService {
  constructor(
    private readonly prisma: PrismaService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async dashboard(
    range: DashboardRange,
    cityId: string | undefined,
    now: Date = new Date(),
  ): Promise<DashboardDto> {
    const city = cityId
      ? await this.prisma.city.findUnique({ where: { id: cityId } })
      : await this.prisma.city.findUnique({
          where: { slug: this.config.get('DEFAULT_CITY_SLUG', { infer: true }) },
        });
    if (!city) throw new ApiError(HttpStatus.NOT_FOUND, 'CITY_NOT_FOUND', 'La ciudad no existe.');
    const { from, to } = rangeBounds(range, now, city.timezone);
    const freshSince = new Date(
      now.getTime() - this.config.get('WORKER_LOCATION_STALE_MS', { infer: true }),
    );
    const q = dashboardQueries({ cityId: city.id, from, to, freshSince });
    const one = async <T>(sql: Prisma.Sql): Promise<T> => {
      const [row] = await this.prisma.$queryRaw<T[]>(sql);
      return row as T;
    };
    const [requests, firstOffer, completed, cancellations, commission, overdue, available, queues] =
      await Promise.all([
        one<{ total: number; expired: number; assigned: number }>(q.requests ?? Prisma.empty),
        one<{ seconds: number | null }>(q.firstOffer ?? Prisma.empty),
        one<{ n: number }>(q.completed ?? Prisma.empty),
        this.prisma.$queryRaw<{ reason: string; n: number }[]>(q.cancellations ?? Prisma.empty),
        one<{ generated: string; collected: string }>(q.commission ?? Prisma.empty),
        one<{ total: string; workers: number }>(q.overdue ?? Prisma.empty),
        one<{ n: number }>(q.available ?? Prisma.empty),
        this.counters(),
      ]);
    const rate = (n: number) =>
      requests.total === 0 ? null : Math.round((n / requests.total) * 1000) / 10;
    const bs = (v: string) => new Prisma.Decimal(v).toFixed(2);
    return {
      range,
      cityId: city.id,
      cityName: city.name,
      from: from.toISOString(),
      to: to.toISOString(),
      requestsCreated: requests.total,
      assignmentRatePct: rate(requests.assigned),
      expirationRatePct: rate(requests.expired),
      avgFirstOfferSec: firstOffer.seconds === null ? null : Math.round(firstOffer.seconds),
      jobsCompleted: completed.n,
      cancellationsByReason: cancellations.map((c) => ({ reason: c.reason, count: c.n })),
      commissionGeneratedBs: bs(commission.generated),
      commissionCollectedBs: bs(commission.collected),
      overdueDebtBs: bs(overdue.total),
      overdueWorkers: overdue.workers,
      workersAvailableNow: available.n,
      queues,
    };
  }

  async counters(): Promise<CountersDto> {
    const entries = await Promise.all(
      Object.entries(counterQueries).map(async ([key, sql]) => {
        const [row] = await this.prisma.$queryRaw<{ n: number }[]>(sql);
        return [key, row?.n ?? 0] as const;
      }),
    );
    return Object.fromEntries(entries) as unknown as CountersDto;
  }
}

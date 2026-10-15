import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import type { CandidateRow } from './candidates';

interface RawCandidate {
  workerId: string;
  status: string;
  activeMode: 'employer' | 'worker';
  available: boolean;
  locatedAt: Date | null;
  maxRadiusKm: number | null;
  distanceM: number;
  ratingAvg: string;
  alreadyNotified: boolean;
}

/**
 * Consultas PostGIS del matching (ADR-0025). Postgres es la fuente de verdad: estado,
 * modo, categorías y ubicación salen de la misma consulta, consistente en la transacción.
 */
@Injectable()
export class MatchingRepository {
  /**
   * Trabajadores disponibles de la ciudad y la categoría a `ringKm` o menos. `ST_DWithin`
   * sobre geography usa el índice GiST de worker_locations.
   */
  async nearbyWorkers(
    tx: Prisma.TransactionClient,
    requestId: string,
    ringKm: number,
  ): Promise<CandidateRow[]> {
    const rows = await tx.$queryRaw<RawCandidate[]>`
      SELECT wp.user_id AS "workerId",
             wp.status::text AS status,
             u.active_mode::text AS "activeMode",
             wl.available,
             wl.located_at AS "locatedAt",
             wp.max_radius_km AS "maxRadiusKm",
             ST_Distance(wl.geog, r.geog)::float8 AS "distanceM",
             wp.rating_avg::text AS "ratingAvg",
             EXISTS (
               SELECT 1 FROM request_notifications rn
               WHERE rn.request_id = r.id AND rn.worker_id = wp.user_id
             ) AS "alreadyNotified"
      FROM service_requests r
      JOIN worker_locations wl
        ON wl.city_id = r.city_id
       AND wl.available
       AND ST_DWithin(wl.geog, r.geog, ${ringKm * 1000})
      JOIN worker_profiles wp ON wp.user_id = wl.worker_id
      JOIN users u ON u.id = wp.user_id
      JOIN worker_categories wc ON wc.worker_id = wp.user_id AND wc.category_id = r.category_id
      WHERE r.id = ${requestId}::uuid`;
    return rows.map((r) => ({
      ...r,
      hasCategory: true,
      distanceM: Math.round(r.distanceM),
      ratingAvg: Number(r.ratingAvg),
    }));
  }

  /** Bloquea la solicitud hasta el fin de la transacción (anillos, cierre y ofertas en serie). */
  async lockRequest(tx: Prisma.TransactionClient, requestId: string) {
    const [row] = await tx.$queryRaw<
      {
        id: string;
        status: string;
        ring: number | null;
        cityId: string;
        employerId: string;
        expiresAt: Date | null;
      }[]
    >`
      SELECT id, status::text AS status, ring, city_id AS "cityId",
             employer_id AS "employerId", expires_at AS "expiresAt"
      FROM service_requests WHERE id = ${requestId}::uuid FOR UPDATE`;
    return row ?? null;
  }
}

import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import type { CandidateRow } from '../matching/candidates';
import type { TransportMode } from './offer.rules';

export interface OfferingWorker extends CandidateRow {
  transport: TransportMode | null;
}

interface Raw {
  workerId: string;
  status: string;
  activeMode: 'employer' | 'worker';
  available: boolean | null;
  locatedAt: Date | null;
  maxRadiusKm: number | null;
  distanceM: number | null;
  ratingAvg: string;
  hasCategory: boolean;
  busy: boolean;
  transport: TransportMode | null;
}

/** Consultas de ofertas (ADR-0026). */
@Injectable()
export class OffersRepository {
  /**
   * El trabajador tal como lo vería el matching ahora (para "que siga elegible"): estado,
   * modo, disponibilidad, categoría y distancia actual a la solicitud.
   */
  async offeringWorker(
    tx: Prisma.TransactionClient,
    requestId: string,
    workerId: string,
  ): Promise<OfferingWorker | null> {
    const [row] = await tx.$queryRaw<Raw[]>`
      SELECT wp.user_id AS "workerId",
             wp.status::text AS status,
             u.active_mode::text AS "activeMode",
             wl.available,
             wl.located_at AS "locatedAt",
             wp.max_radius_km AS "maxRadiusKm",
             ST_Distance(wl.geog, r.geog)::float8 AS "distanceM",
             wp.rating_avg::text AS "ratingAvg",
             EXISTS (
               SELECT 1 FROM jobs j
               WHERE j.worker_id = wp.user_id
                 AND j.status IN ('asignado', 'en_camino', 'en_curso')
             ) AS busy,
             EXISTS (
               SELECT 1 FROM worker_categories wc
               WHERE wc.worker_id = wp.user_id AND wc.category_id = r.category_id
             ) AS "hasCategory",
             wp.transport::text AS transport
      FROM service_requests r
      JOIN worker_profiles wp ON wp.user_id = ${workerId}::uuid
      JOIN users u ON u.id = wp.user_id
      LEFT JOIN worker_locations wl ON wl.worker_id = wp.user_id
      WHERE r.id = ${requestId}::uuid`;
    if (!row) return null;
    return {
      ...row,
      available: row.available ?? false,
      // Sin ubicación no hay distancia: queda fuera de cualquier radio.
      distanceM: row.distanceM === null ? Number.POSITIVE_INFINITY : Math.round(row.distanceM),
      ratingAvg: Number(row.ratingAvg),
      alreadyNotified: false,
    };
  }
}

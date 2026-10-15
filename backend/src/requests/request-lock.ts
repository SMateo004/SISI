import type { Prisma } from '../generated/prisma/client';

export interface LockedRequest {
  id: string;
  status: string;
  ring: number | null;
  cityId: string;
  categoryId: string;
  employerId: string;
  proposedPriceBs: string;
  ringStartedAt: Date | null;
  expiresAt: Date | null;
}

/**
 * Bloquea la solicitud hasta el fin de la transacción (`SELECT … FOR UPDATE`). Anillos,
 * cierre, ofertas y aceptación pasan por aquí, así que se ejecutan en serie para una misma
 * solicitud (ADR-0025, ADR-0026).
 */
export async function lockRequest(
  tx: Prisma.TransactionClient,
  requestId: string,
): Promise<LockedRequest | null> {
  const [row] = await tx.$queryRaw<LockedRequest[]>`
    SELECT id, status::text AS status, ring, city_id AS "cityId", category_id AS "categoryId",
           employer_id AS "employerId", proposed_price_bs::text AS "proposedPriceBs",
           ring_started_at AS "ringStartedAt", expires_at AS "expiresAt"
    FROM service_requests WHERE id = ${requestId}::uuid FOR UPDATE`;
  return row ?? null;
}

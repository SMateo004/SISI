import type { Prisma } from '../generated/prisma/client';
import type { OutboxService } from '../outbox/outbox.service';
import type { LockedRequest } from '../requests/request-lock';
import type { RequestStatusService } from '../requests/request-status.service';

export interface WithdrawnOffer {
  id: string;
  reopened: boolean;
}

/**
 * Retira una oferta activa con la solicitud ya bloqueada (ADR-0026): la oferta queda
 * `retirada`; si era la única activa, la solicitud vuelve a buscando con un cierre nuevo
 * (ADR-0025) y el worker retoma el matching al procesar offer.withdrawn. Lo usan el
 * trabajador (retirar), la aceptación de un trabajador ocupado y la autorretirada al
 * ser elegido en otra solicitud.
 */
export async function withdrawLockedOffer(
  tx: Prisma.TransactionClient,
  deps: { status: RequestStatusService; outbox: OutboxService },
  request: LockedRequest,
  offerId: string,
  actorId: string | null,
): Promise<WithdrawnOffer> {
  await tx.offer.update({ where: { id: offerId }, data: { status: 'retirada' } });
  const remaining = await tx.offer.count({
    where: { requestId: request.id, status: 'activa' },
  });
  const reopened = remaining === 0 && request.status === 'con_ofertas';
  if (reopened) {
    await deps.status.apply(
      request.id,
      'LAST_OFFER_WITHDRAWN',
      actorId,
      { data: { expiresAt: null, closeSeq: request.closeSeq + 1 } },
      tx,
    );
  }
  await deps.outbox.add(tx, 'offer.withdrawn', request.id, {
    requestId: request.id,
    offerId,
    reopened,
  });
  return { id: offerId, reopened };
}

import type { Offer, OfferEventKind, Prisma } from '../generated/prisma/client';

/**
 * Historial de ofertas (ADR-0042): cada cambio de una oferta deja su fila en offer_events,
 * con el monto de ese momento, en la misma transacción del cambio.
 */
export async function recordOfferEvent(
  tx: Prisma.TransactionClient,
  offer: Pick<
    Offer,
    'id' | 'requestId' | 'workerId' | 'cityId' | 'revision' | 'type' | 'amountBs' | 'etaMin'
  >,
  kind: OfferEventKind,
): Promise<void> {
  await tx.offerEvent.create({
    data: {
      offerId: offer.id,
      requestId: offer.requestId,
      workerId: offer.workerId,
      cityId: offer.cityId,
      kind,
      revision: offer.revision,
      type: offer.type,
      amountBs: offer.amountBs,
      etaMin: offer.etaMin,
    },
  });
}

/** Cierra las ofertas activas de una solicitud (asignada, cancelada o expirada) y lo registra. */
export async function closeActiveOffers(
  tx: Prisma.TransactionClient,
  requestId: string,
): Promise<number> {
  const closed = await tx.offer.updateManyAndReturn({
    where: { requestId, status: 'activa' },
    data: { status: 'cerrada' },
  });
  if (closed.length > 0) {
    await tx.offerEvent.createMany({
      data: closed.map((o) => ({
        offerId: o.id,
        requestId: o.requestId,
        workerId: o.workerId,
        cityId: o.cityId,
        kind: 'cerrada' as const,
        revision: o.revision,
        type: o.type,
        amountBs: o.amountBs,
        etaMin: o.etaMin,
      })),
    });
  }
  return closed.length;
}

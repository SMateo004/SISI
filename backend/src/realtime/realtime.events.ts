/**
 * Eventos de tiempo real (doc 02 §6, ADR-0023). Solo nombres de esa lista. Los payloads
 * están documentados en docs/realtime-events.md (no salen en Swagger).
 *
 * Los eventos son avisos: el estado verdadero siempre se pide por REST (al recibir un
 * aviso y al reconectar), así que perder uno no deja a la app en un estado incorrecto.
 */
export const RealtimeEvents = {
  requestNew: 'request:new',
  requestAssigned: 'request:assigned',
  requestExpired: 'request:expired',
  offerNew: 'offer:new',
  offerClosed: 'offer:closed',
} as const;

export type RealtimeEventName = (typeof RealtimeEvents)[keyof typeof RealtimeEvents];

/** Motivo por el que se cierra una oferta (o la posibilidad de ofertar). */
export type OfferClosedReason = 'elegida_otra' | 'cancelada' | 'expirada';

export interface RealtimePayloads {
  /** Al trabajador notificado: hay una solicitud cerca. Detalle por GET /worker/requests/:id. */
  'request:new': {
    requestId: string;
    ring: number;
    distanceM: number;
    category: { slug: string; name: string };
    proposedPriceBs: string;
    /** Hasta cuándo dura el anillo (ISO 8601). */
    respondBy: string;
  };
  /** A los notificados y al empleador: la solicitud ya tiene trabajador. */
  'request:assigned': {
    requestId: string;
    /** Solo para las dos partes (empleador y trabajador elegido); null para los demás. */
    jobId: string | null;
  };
  /** Al empleador y a los notificados: la solicitud expiró (R4.5). */
  'request:expired': { requestId: string };
  /** Al empleador: llegó o se reemplazó una oferta. Lista completa por GET /requests/:id/offers. */
  'offer:new': {
    requestId: string;
    offerId: string;
    type: 'accept' | 'counter';
    amountBs: string;
    etaMin: number;
    worker: { shortName: string; ratingAvg: string; ratingCount: number };
  };
  /** Al trabajador: ya no puede ofertar o su oferta se cerró. */
  'offer:closed': { requestId: string; reason: OfferClosedReason };
}

export const rooms = {
  user: (userId: string): string => `user:${userId}`,
  request: (requestId: string): string => `request:${requestId}`,
};

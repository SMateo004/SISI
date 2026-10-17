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
  jobStatus: 'job:status',
  jobLocation: 'job:location',
  chatMessage: 'chat:message',
  billingDue: 'billing:due',
  accountBlocked: 'account:blocked',
  accountUnblocked: 'account:unblocked',
} as const;

export type RealtimeEventName = (typeof RealtimeEvents)[keyof typeof RealtimeEvents];

/** Motivo por el que se cierra una oferta (o la posibilidad de ofertar). */
export type OfferClosedReason = 'elegida_otra' | 'cancelada' | 'expirada' | 'retirada';

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
  /**
   * Al trabajador: ya no puede ofertar o su oferta se cerró. Al empleador, con `retirada`:
   * un trabajador retiró su oferta (`offerId`).
   */
  'offer:closed': { requestId: string; reason: OfferClosedReason; offerId?: string };
  /**
   * A las dos partes: el trabajo cambió (ADR-0029). `action` dice qué pasó (FINISH y
   * DISPUTE no cambian el estado). Detalle por GET /jobs/:id.
   */
  'job:status': { jobId: string; requestId: string; status: string; action: string };
  /** Al empleador, mientras el trabajador va en camino (con throttling). */
  'job:location': { jobId: string; latitude: number; longitude: number; at: string };
  /** A las dos partes: mensaje de chat entregado (los retenidos no se emiten). */
  /**
   * Al trabajador: hay un cobro para pagar (cierre del corte o recordatorio, R7.6). Detalle por
   * GET /me/billing/pay-info. Montos como texto con 2 decimales.
   */
  'billing:due': {
    periodId: string;
    kind: 'cierre' | 'vispera' | 'dia';
    amountBs: string;
    paymentReference: string;
    dueAt: string;
  };
  /**
   * Al trabajador: su modo trabajador quedó bloqueado (R7.7 deuda vencida, R9.3 moderación).
   * Sigue pudiendo usar la app como empleador (R1.6).
   */
  'account:blocked': {
    reason: 'deuda' | 'moderacion';
    status: 'bloqueado_deuda' | 'suspendido_moderacion';
  };
  /** Al trabajador: se levantó el bloqueo. No cambia de modo solo: usa el interruptor. */
  'account:unblocked': { status: string };
  'chat:message': {
    jobId: string;
    messageId: string;
    senderId: string;
    body: string;
    createdAt: string;
  };
}

export const rooms = {
  user: (userId: string): string => `user:${userId}`,
  request: (requestId: string): string => `request:${requestId}`,
};

/**
 * Eventos de dominio que pasan por el outbox (ADR-0022). Cada uno se escribe en la misma
 * transacción que el cambio de estado que lo origina, así que no se pierde si el
 * proceso cae: el relay del worker lo publica a BullMQ con un jobId determinístico.
 */
export interface OutboxPayloads {
  /** La solicitud pasó a buscando (publicada sin coincidencias o liberada): arranca el matching. */
  'request.searching': { requestId: string };
  /** Quedó retenida por moderación (R3.3). */
  'request.held': { requestId: string; matchCount: number };
  /** El admin la liberó: aviso al empleador. El matching lo dispara request.searching. */
  'request.released': { requestId: string };
  /** El admin la rechazó por moderación: aviso al empleador. */
  'request.rejected': { requestId: string };
  /** El empleador la canceló (R3.4): se cancelan los jobs pendientes y se avisa a los notificados. */
  'request.cancelled': { requestId: string };
  /** Se le avisó a un trabajador en un anillo (ADR-0025): socket request:new y push. */
  'request.notified': {
    requestId: string;
    workerId: string;
    ring: number;
    distanceM: number;
    respondBy: string;
  };
  /** Expiró sin asignarse (R4.5): aviso al empleador, request:expired y offer:closed. */
  'request.expired': { requestId: string };
  /** Llegó o se reemplazó una oferta (R5.2): offer:new y push al empleador. */
  'offer.created': { requestId: string; offerId: string; revision: number };
  /** El trabajador retiró su oferta; si era la única, la solicitud volvió a buscando. */
  'offer.withdrawn': { requestId: string; offerId: string; reopened: boolean };
  /** El empleador eligió una oferta (R5.4): request:assigned, offer:closed y aviso al elegido. */
  'request.assigned': { requestId: string; jobId: string };
  /** Cambió el trabajo (ADR-0029): job:status y push a las dos partes; FINISH programa la autoconfirmación. */
  'job.status_changed': {
    jobId: string;
    action: string;
    from: string;
    to: string;
    actorRole: string;
  };
  /**
   * Cambió el saldo de un trabajador (comisión, pago o ajuste; ADR-0034): el worker revisa
   * el tope (R7.5) y el bloqueo por deuda (R7.7). Idempotente: solo mira el estado actual.
   */
  'billing.balance_changed': { workerId: string; cause: 'comision' | 'pago' | 'ajuste' };
  /** Mensaje de chat entregado (no retenido): chat:message y push si no está conectado. */
  'chat.message_sent': { jobId: string; messageId: string };
  /**
   * El trabajo terminó (R6.3, ADR-0030). Lo consume la Fase 5 para el ledger; montos como
   * texto con 2 decimales.
   */
  'job.completed': {
    jobId: string;
    workerId: string;
    cityId: string;
    finalPriceBs: string;
    commissionPct: string;
    commissionBs: string;
    completedAt: string;
  };
}

export type OutboxEventType = keyof OutboxPayloads;

/** Una fila de outbox_events tal como la lee el relay. */
export interface OutboxRecord {
  id: bigint;
  type: string;
  aggregateId: string;
  payload: unknown;
  attempts: number;
}

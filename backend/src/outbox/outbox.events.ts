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

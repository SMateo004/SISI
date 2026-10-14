import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';

/** Estados de R3.4. Lista cerrada. */
export const REQUEST_STATUSES = [
  'borrador',
  'retenida',
  'buscando',
  'con_ofertas',
  'asignada',
  'cancelada',
  'expirada',
] as const;
export type RequestStatus = (typeof REQUEST_STATUSES)[number];

/**
 * Eventos (ADR-0019). Quién los dispara:
 * PUBLISH_CLEAN / PUBLISH_HELD: el empleador al publicar, según la moderación (R3.3).
 * RELEASE / REJECT: el admin con una retenida. REJECT termina en cancelada (sin estados nuevos).
 * CANCEL: el empleador mientras no esté asignada.
 * RECEIVE_OFFER / ASSIGN / EXPIRE: matching y ofertas (Fase 3).
 */
export const REQUEST_EVENTS = [
  'PUBLISH_CLEAN',
  'PUBLISH_HELD',
  'RELEASE',
  'REJECT',
  'CANCEL',
  'RECEIVE_OFFER',
  'ASSIGN',
  'EXPIRE',
] as const;
export type RequestEvent = (typeof REQUEST_EVENTS)[number];

const TRANSITIONS: Record<RequestEvent, Partial<Record<RequestStatus, RequestStatus>>> = {
  PUBLISH_CLEAN: { borrador: 'buscando' },
  PUBLISH_HELD: { borrador: 'retenida' },
  RELEASE: { retenida: 'buscando' },
  REJECT: { retenida: 'cancelada' },
  CANCEL: {
    borrador: 'cancelada',
    retenida: 'cancelada',
    buscando: 'cancelada',
    con_ofertas: 'cancelada',
  },
  RECEIVE_OFFER: { buscando: 'con_ofertas' },
  ASSIGN: { con_ofertas: 'asignada' },
  EXPIRE: { buscando: 'expirada', con_ofertas: 'expirada' },
};

const MESSAGES: Partial<Record<RequestEvent, string>> = {
  CANCEL: 'Esta solicitud ya no se puede cancelar.',
  PUBLISH_CLEAN: 'Esta solicitud ya fue publicada.',
  PUBLISH_HELD: 'Esta solicitud ya fue publicada.',
};

export class RequestTransitionError extends ApiError {
  constructor(
    readonly from: RequestStatus,
    readonly event: RequestEvent,
  ) {
    super(
      HttpStatus.CONFLICT,
      'REQUEST_TRANSITION_NOT_ALLOWED',
      MESSAGES[event] ?? `No se puede aplicar ${event} a una solicitud en estado ${from}.`,
      { from, event },
    );
  }
}

/** Siguiente estado o RequestTransitionError (409). Función pura. */
export function nextRequestStatus(from: RequestStatus, event: RequestEvent): RequestStatus {
  const to = TRANSITIONS[event][from];
  if (!to) throw new RequestTransitionError(from, event);
  return to;
}

export function canApplyRequest(from: RequestStatus, event: RequestEvent): boolean {
  return TRANSITIONS[event][from] !== undefined;
}

export function allowedRequestTransitions(): {
  from: RequestStatus;
  event: RequestEvent;
  to: RequestStatus;
}[] {
  return REQUEST_EVENTS.flatMap((event) =>
    (Object.entries(TRANSITIONS[event]) as [RequestStatus, RequestStatus][]).map(([from, to]) => ({
      from,
      event,
      to,
    })),
  );
}

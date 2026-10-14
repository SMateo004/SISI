/**
 * Eventos de dominio de solicitudes (ADR-0020). Se emiten después de confirmar la
 * transacción, por @nestjs/event-emitter (en proceso). La Fase 3 escuchará
 * `request.searching` para empezar el matching por anillos.
 */
export const RequestEvents = {
  /** La solicitud pasó a "buscando": publicada sin coincidencias o liberada por el admin. */
  searching: 'request.searching',
  /** Quedó retenida por moderación (R3.3). */
  held: 'request.held',
  /** Cancelada por el empleador o rechazada por moderación. */
  cancelled: 'request.cancelled',
} as const;

export class RequestSearchingEvent {
  constructor(
    readonly requestId: string,
    readonly cityId: string,
    readonly categoryId: string,
    readonly employerId: string,
    readonly location: { lat: number; lng: number },
    readonly at: Date,
  ) {}
}

export class RequestHeldEvent {
  constructor(
    readonly requestId: string,
    readonly cityId: string,
    readonly matchCount: number,
  ) {}
}

export class RequestCancelledEvent {
  constructor(
    readonly requestId: string,
    readonly reason: 'empleador' | 'moderacion',
  ) {}
}

import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { RequestEvents, type RequestHeldEvent, RequestSearchingEvent } from './request.events';

/**
 * Deja constancia de los eventos de solicitudes. En la Fase 3 el matching se suscribe a
 * `request.searching` (ADR-0020); este listener queda como registro operativo.
 */
@Injectable()
export class RequestEventsLogger {
  private readonly logger = new Logger('RequestEvents');

  @OnEvent(RequestEvents.searching)
  onSearching(event: RequestSearchingEvent): void {
    this.logger.log(`Solicitud ${event.requestId} buscando trabajadores (matching: Fase 3)`);
  }

  @OnEvent(RequestEvents.held)
  onHeld(event: RequestHeldEvent): void {
    this.logger.log(
      `Solicitud ${event.requestId} retenida por moderación (${event.matchCount} coincidencias)`,
    );
  }
}

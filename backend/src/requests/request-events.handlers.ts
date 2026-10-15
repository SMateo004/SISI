import { Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';

/**
 * Registro operativo de los eventos de solicitudes en el worker. Los avisos al empleador
 * (push) se agregan con el módulo de notificaciones.
 */
@Injectable()
export class RequestEventsHandlers implements OnModuleInit {
  private readonly logger = new Logger('RequestEvents');

  constructor(private readonly registry: EventHandlersRegistry) {}

  onModuleInit(): void {
    this.registry.on('request.held', ({ payload }) => {
      this.logger.log(
        `Solicitud ${payload.requestId} retenida por moderación (${payload.matchCount} coincidencias)`,
      );
      return Promise.resolve();
    });
    this.registry.on('request.released', ({ payload }) => {
      this.logger.log(`Solicitud ${payload.requestId} liberada por el admin`);
      return Promise.resolve();
    });
    this.registry.on('request.rejected', ({ payload }) => {
      this.logger.log(`Solicitud ${payload.requestId} rechazada por moderación`);
      return Promise.resolve();
    });
    this.registry.on('request.cancelled', ({ payload }) => {
      this.logger.log(`Solicitud ${payload.requestId} cancelada por el empleador`);
      return Promise.resolve();
    });
  }
}

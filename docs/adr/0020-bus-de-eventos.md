# ADR-0020: Bus de eventos de dominio en proceso (@nestjs/event-emitter)

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 2

## Contexto
Al publicar una solicitud, otras partes del sistema deben reaccionar (matching en la Fase 3, notificaciones en la Fase 4) sin que `RequestsService` las conozca.

## Decisión
- `@nestjs/event-emitter` 12.0.1 (ESM, peer NestJS ^12, sin scripts de instalación; verificado antes de agregar). `EventEmitterModule.forRoot()` en `AppModule`.
- Eventos tipados en `request.events.ts`: `request.searching` (id, ciudad, categoría, empleador y ubicación), `request.held` y `request.cancelled`. Se emiten **después** de confirmar la transacción.
- Por ahora un solo oyente (`RequestEventsLogger`) que deja constancia en el log.
- Es un bus en memoria: no es durable. El trabajo pesado o que deba reintentarse lo encola el oyente en BullMQ (doc 02).

## Consecuencias
Desacopla módulos sin agregar infraestructura. Si la instancia cae entre el commit y el oyente, el evento se pierde: la Fase 3 debe poder recuperar solicitudes en `buscando` sin procesar (barrido al arrancar o job periódico).

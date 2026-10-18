# ADR-0042: Historial de ofertas (`offer_events`)

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
Una oferta es una fila por trabajador y solicitud (ADR-0026). Cuando el trabajador la reemplaza, la fila se actualiza y sube `revision`: el monto anterior se pierde. En una disputa el admin necesita ver qué se ofreció y cuándo, incluido lo que se ofreció antes del monto elegido.

## Decisión
- **Tabla `offer_events`, append-only** (trigger `offer_events_no_update_delete`, como el ledger y `job_events`).
  - Columnas: `offer_id`, `request_id`, `worker_id`, `city_id`, `kind`, `revision`, `type`, `amount_bs`, `eta_min` y `created_at`.
  - Valores de `kind`: `creada`, `reemplazada` (otro monto, o una retirada que se vuelve a enviar), `retirada`, `aceptada` y `cerrada`.
- **Misma transacción:** cada cambio de una oferta escribe su fila en la transacción del cambio.
  - `recordOfferEvent` en crear, reemplazar, retirar y aceptar.
  - `closeActiveOffers` (`updateManyAndReturn` + `createMany`) reemplaza los tres `updateMany` que cerraban ofertas: al asignar, al cancelar la solicitud y al expirar.
- **Índices:** `(offer_id, id)` para el historial de una oferta, y `(request_id, created_at)` para la disputa y para el "tiempo a la primera oferta" del dashboard.
- **Backfill:** la migración crea una fila `creada` por oferta existente, con su monto actual. El historial anterior a la Fase 6 no existe y no se puede reconstruir.

## Consecuencias
- La vista de disputas del panel muestra todas las ofertas con su historial completo.
- `offers` sigue siendo el estado actual y la fuente para el matching y la aceptación. `offer_events` es solo historial: nadie decide nada leyéndolo.
- Una oferta no se puede borrar (FK `Restrict`). Hoy nada borra ofertas ni solicitudes.

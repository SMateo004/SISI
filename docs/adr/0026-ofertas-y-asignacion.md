# ADR-0026: Ofertas, asignación y revelado del contacto

- Estado: aceptada
- Fecha: 2026-10-15
- Fase: 3

## Contexto
R5: el trabajador ve la solicitud antes de ofertar, acepta el precio o contraoferta, el empleador elige en vivo y, al elegir, se revela el contacto entre las partes (R9.4). Dos aceptaciones simultáneas no pueden asignar dos veces.

## Decisión
- **Quién puede ofertar:** solo un trabajador **notificado** (`request_notifications`), que **siga elegible** y con la solicitud en `buscando` o `con_ofertas`.
  - Elegible significa los mismos criterios del matching con `exclusionOf`, sin el límite de anillo: aprobado, modo worker, disponible con ubicación fresca, categoría, dentro de su radio, tope de deuda.
  - A un no notificado se le responde 404 (no se revela que existe). Si dejó de ser elegible, 409 `NOT_ELIGIBLE` con el motivo.
- **Una oferta por trabajador y solicitud** (`UNIQUE(request_id, worker_id)`): reemplazarla actualiza la fila y sube `revision`, mientras no se haya elegido ninguna. Se descartó el índice único parcial (`WHERE status = 'activa'`) porque en Prisma 7 requiere una función en preview.
- **Monto:**
  - `accept` usa el precio propuesto;
  - `counter` exige > 0, hasta 2 decimales y ≤ `OFFER_COUNTER_MAX_FACTOR` (3) × el máximo efectivo de la categoría en la ciudad (`CategoryResolver`, ADR-0016).
- **ETA:** `ceil(distancia × ETA_ROUTE_FACTOR (1,3) / velocidad del medio × 60)`, mínimo 1 min. Velocidades en `ETA_SPEEDS_KMH`.
- **La primera oferta** aplica `RECEIVE_OFFER` (`buscando` → `con_ofertas`).
- **El trabajador ve** (`GET /worker/requests[/:id]`):
  - distancia, descripción, fotos con URL firmada (solo notificados), precio propuesto, rango de referencia, tope de contraoferta, plazo del anillo y su oferta;
  - el resultado: `abierta`, `elegido`, `elegida_otra`, `cancelada` o `expirada`.
  - **Nunca** el nombre ni el teléfono del empleador, ni la dirección exacta.
- **El empleador ve** (`GET /requests/:id/offers` y `offer:new`): precio, tipo, ETA, calificación y nombre corto ("María P.").
- **Aceptación**, en una transacción con la solicitud bloqueada (`SELECT … FOR UPDATE`):
  - valida `con_ofertas` y la oferta activa;
  - crea `jobs` (`final_price_bs` y copia de `commission_pct` del resolvedor; `request_id` y `offer_id` únicos como segunda barrera);
  - `ASSIGN`; oferta elegida `aceptada` y las demás `cerradas`;
  - outbox `request.assigned`.
  - El handler cancela los jobs de matching pendientes, emite `request:assigned` (con `jobId` solo a las dos partes), `offer:closed` (`elegida_otra`) a los demás notificados, y avisa al elegido.
  - Una segunda aceptación concurrente espera el bloqueo y recibe 409 `REQUEST_ALREADY_ASSIGNED`.
- **Contacto** (`GET /jobs/:id/contact`): solo el empleador y el trabajador del trabajo; nombre y teléfono de la contraparte, y la dirección para el trabajador.
- **Límites:** por IP (`@RateLimit('offerCreateIp')`) y por usuario (`RATE_OFFER_PER_MIN`) con `RateLimitStore` (ADR-0010).
- **La tabla `jobs`** nace con el estado `asignado`; el resto del ciclo de vida (R6) es de la Fase 4.

## Consecuencias
- Retirar una oferta no existe todavía (solo reemplazarla) (docs/pendientes.md).
- El historial de cambios de una oferta se reduce a `revision`. Si hiciera falta auditar montos anteriores, se agrega una tabla de eventos de oferta.
- El ETA es una estimación en línea recta: con un proveedor de rutas se puede reemplazar sin cambiar el contrato.

## Actualización (Fase 4)
- El contacto trae `telUri` (`tel:+591…`) y `whatsappUri` (`https://wa.me/591…`, sin "+") para los botones de la app, y `visibleUntil`. Se oculta `JOB_CONTACT_VISIBLE_AFTER_MS` (24 h) después de terminado o cancelado: 410 `CONTACT_EXPIRED`.
- Aceptar a un trabajador ocupado responde 409 `WORKER_BUSY` y le retira la oferta (ADR-0029).

## Actualización (Fase 6)
Cada cambio de una oferta (crear, reemplazar, retirar, aceptar y cerrar) queda además en `offer_events`, append-only y con el monto de ese momento (ADR-0042). La fila de `offers` sigue siendo el estado actual.

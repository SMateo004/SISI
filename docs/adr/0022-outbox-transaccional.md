# ADR-0022: Outbox transaccional, relay a BullMQ y reconciliador

- Estado: aceptada (reemplaza a ADR-0020)
- Fecha: 2026-10-15
- Fase: 3

## Contexto
El ADR-0020 emitía los eventos de dominio en memoria (`@nestjs/event-emitter`) después de confirmar la transacción. Si la instancia caía entre el commit y el oyente, el evento se perdía, y una solicitud podía quedar en `buscando` sin que nadie buscara trabajadores. El matching de la Fase 3 corre en otro proceso (Render Background Worker) y no puede depender de memoria.

## Decisión
- **Tabla `outbox_events`:** `id` bigserial, `type`, `aggregate_id`, `payload`, `available_at`, `published_at`, `attempts`, `last_error`.
  - `OutboxService.add(tx, …)` escribe el evento **en la misma transacción** que el cambio de estado.
  - `RequestStatusService.apply` acepta la transacción de quien llama, sin perder su validación ni su historial.
  - Si la transacción se revierte, el evento no existe; si se confirma, el evento ya está guardado.
- **Relay en el proceso worker (`OutboxRelay`):**
  - cada `OUTBOX_POLL_MS` toma un lote con `FOR UPDATE SKIP LOCKED`, lo que permite varias instancias sin que se pisen;
  - publica cada evento a BullMQ con **jobId determinístico** y lo marca publicado;
  - si falla, guarda el error y reintenta con espera exponencial (máximo 5 min).
- **jobIds:** `request.searching` se convierte en `ring_{solicitud}_1` (el mismo que usa el reconciliador); el resto, en `evt_{id del outbox}`. BullMQ ignora un `add` con un jobId que ya existe, y los jobs completados se guardan `QUEUE_KEEP_COMPLETED_SEC` (24 h). Si el proceso cae entre encolar y marcar, la republicación no duplica nada.
- **Handlers idempotentes:** revisan el estado en la base y usan `ON CONFLICT DO NOTHING`. Un evento puede llegar más de una vez.
- **Reconciliador:** job repetible (`MATCHING_RECONCILE_MS`, 60 s) que busca solicitudes en `buscando`/`con_ofertas` sin el job que les corresponde según la base (`expectedMatchingJob`) y lo vuelve a encolar. Un job completado y guardado cuenta como presente; uno fallido o perdido se reemplaza. Cubre lo que el outbox no ve: un Redis restaurado o un job borrado.
- La API no usa BullMQ: solo escribe en Postgres. Colas y relay viven en el worker (`WorkerModule`).
- Se elimina `@nestjs/event-emitter`.
- Implementación propia (unas 150 líneas, sin librerías de outbox): la lógica del relay (`OutboxRelayCore`) se prueba sin infraestructura, con puertos para el almacén y el publicador.

## Consecuencias
- Garantía de **al menos una vez** de la base a la cola. Los consumidores deben ser idempotentes.
- Latencia extra de hasta `OUTBOX_POLL_MS` (500 ms). Si hiciera falta menos, se puede agregar `LISTEN/NOTIFY` sin cambiar la garantía.
- La tabla crece: la **limpieza** (Fase 4, `OutboxCleanupService`) es un job repetible del worker (`OUTBOX_CLEANUP_MS`, diario) que borra, por lotes de 5000, los eventos **publicados** hace más de `OUTBOX_RETENTION_DAYS` (7). Los pendientes nunca se borran. 7 días superan con holgura los 24 h que BullMQ guarda los jobs completados, así que la deduplicación por jobId no depende de esas filas. El ledger no se limpia nunca (append-only).

## Actualización (Fase 5)
Eventos de cobros, todos consumidos por el worker e idempotentes:
- `job.completed` deja la comisión en el ledger (índice único por trabajo);
- `billing.balance_changed` y `billing.payment_registered` reconcilian el bloqueo y el tope;
- `billing.notice` es un aviso registrado una sola vez por periodo y tipo en `billing_notices`.

El cron de cobros (ADR-0036) escribe en el outbox y no envía nada directamente.

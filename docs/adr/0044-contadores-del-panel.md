# ADR-0044: Contadores del panel por socket, con respaldo por sondeo

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
El menú del panel muestra las colas pendientes:
- verificaciones;
- solicitudes y mensajes retenidos;
- reportes;
- disputas;
- comprobantes.

Deben actualizarse sin recargar. No todos los cambios de cola pasan por el outbox: un mensaje retenido, un reporte nuevo, un comprobante o un perfil enviado a revisión no emiten eventos. Agregar un evento a cada camino sería frágil, porque una ruta nueva que olvide emitirlo deja el contador desactualizado.

## Decisión
- **Socket, emitido por el worker según el estado y no por evento:**
  - `AdminCountersPublisher` cuenta las colas cada `ADMIN_COUNTERS_EMIT_MS` (10 s): 6 conteos sobre índices por estado (los mismos de `GET /admin/counters`);
  - emite `admin:counters` a la sala `admins` **solo si cambiaron** (último valor en Redis);
  - con varias instancias del worker, un candado en Redis deja contar a una sola por vuelta.
- **Sala `admins`:** el gateway la une solo para tokens con rol admin y `aud=admin` (ADR-0040). La app de un admin no la recibe.
- **Respaldo:** el panel pide `GET /admin/counters` al conectar y cada 60 s. Así un evento perdido o un socket caído no deja el número desactualizado más de un minuto.
- **Nuevo evento de tiempo real:** `admin:counters`, documentado en `docs/realtime-events.md`. Amplía la lista de doc 02 §6 solo para el panel; queda en pendientes actualizar doc 02.

## Consecuencias
- Un cambio llega al panel en 10 s como máximo, venga de donde venga.
- El costo es fijo y bajo (6 conteos indexados cada 10 s) y no crece con el número de admins conectados.
- Se descartó el sondeo corto puro: con varios admins multiplica las consultas y deja de servir con el panel en segundo plano.

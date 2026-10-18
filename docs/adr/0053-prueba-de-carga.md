# ADR-0053: Prueba de carga con Docker contra staging

- Estado: aceptada (corrida en staging pendiente)
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Antes del piloto hay que saber si los planes de Render alcanzan, y cuánto tarda en llegar una solicitud al trabajador. Las herramientas no se instalan en la máquina, y la prueba nunca corre contra producción.

## Decisión
- **k6 2.3.0** en Docker (`loadtest/k6/pilot.js`):
  - trabajadores disponibles que mandan su ubicación cada 30 s, ofertan a lo que les llega (20 % de contraofertas) y avanzan su trabajo;
  - empleadores que publican, eligen la primera oferta, chatean y confirman;
  - **cifras propuestas:** 200 trabajadores, 40 empleadores y 6 solicitudes por minuto (~30 abiertas a la vez), durante 30 min más un pico al doble de 5 min;
  - umbrales por endpoint;
  - renueva el token ante un 401.
- **Entrega de `request:new`** (`loadtest/socket/delivery.mjs`): Node 24 en Docker con el `socket.io-client` del backend. Mide desde la respuesta de la publicación hasta que el socket recibe el evento.
- **Usuarios:** `dev-tools loadtest-seed` (solo local y staging) crea usuarios en un rango reservado (+591 699xxxxx), con trabajadores aprobados y textos aceptados, y escribe sus tokens.
- **Conexiones a Postgres:** `dev-tools db-stats` las muestrea; CPU y memoria salen de las métricas de Render.
- **Staging se ajusta temporalmente:** planes de producción y límites por IP altos, porque k6 sale de una sola IP. Todo se revierte al terminar (`loadtest/README.md`).

## Consecuencias
- El reporte dice si el plan alcanza y qué ajustar: instancias, plan del worker, pool de Prisma u `OUTBOX_POLL_MS`.
- Mientras staging siga bloqueado, solo hay una validación local a escala chica: prueba el escenario de punta a punta, no la capacidad.

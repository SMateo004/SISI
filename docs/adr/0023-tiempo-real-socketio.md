# ADR-0023: Tiempo real con Socket.IO

- Estado: aceptada
- Fecha: 2026-10-15
- Fase: 3

## Contexto
El matching (R4) y las ofertas (R5) necesitan avisos inmediatos: la solicitud entrante al trabajador y las ofertas en vivo al empleador. El doc 02 fija Socket.IO con `@socket.io/redis-adapter` y la lista de eventos (§6). La API puede tener varias instancias, y el matching corre en el worker, que no debe levantar un servidor.

## Decisión
- **Gateway en la API** (`RealtimeGateway`) sobre el mismo servidor HTTP.
  - El handshake trae `auth.token` y se valida con `authenticateAccessToken`, la misma función que usa `JwtAuthGuard` (mismos códigos de error: `UNAUTHENTICATED`, `TOKEN_INVALID`).
  - Un temporizador corta el socket al vencer `exp`.
- **`RedisIoAdapter`:** mismo CORS que HTTP y `@socket.io/redis-adapter`, con conexiones pub y sub propias.
- **Emisión desde cualquier proceso:** `RealtimeEmitter` sobre `@socket.io/redis-emitter` (publica en Redis; el adapter de cada instancia lo entrega). La usa el worker; la API no necesita una segunda implementación.
- **Salas:** `user:{id}` (al conectar) y `request:{id}` (las arma el servidor con `socketsJoin`/`socketsLeave`, incluso desde el worker). El cliente no envía eventos ni elige salas.
- **Eventos:** solo los nombres del doc 02 §6. Payloads tipados en `realtime.events.ts` y documentados en `docs/realtime-events.md`.
- **Resincronización:** los eventos son avisos. Al reconectar, la app pide el estado por REST.
- **El anillo actual no tiene evento propio** (no está en §6): la app lo refresca por REST cada 15 s mientras busca.

## Consecuencias
- Varias instancias de la API funcionan sin sticky sessions mientras el cliente use el transporte `websocket` (con `polling` harían falta sticky sessions en Render).
- Redis pasa a ser crítico para el tiempo real (ya lo era para colas y límites).
- Los eventos pueden perderse sin conexión: por diseño, nada depende de ellos.
- Versiones: socket.io 4.8.4, @socket.io/redis-adapter 8.3.0, @socket.io/redis-emitter 5.1.0, @nestjs/websockets y @nestjs/platform-socket.io 12.1.3 (peer NestJS ^12, sin scripts de instalación).

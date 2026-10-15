# Eventos en tiempo real (Socket.IO)

> Contrato de los eventos que la API envía por Socket.IO (ADR-0023). No salen en Swagger.
> Fuente en el código: `backend/src/realtime/realtime.events.ts` (tipos `RealtimePayloads`).

## Conexión

- URL: la misma de la API (`SOCKET_URL` en la app), ruta por defecto `/socket.io`. Transporte recomendado: `websocket`.
- Autenticación: en el handshake, `auth: { token: "<token de acceso>" }`. Se valida igual que el header `Authorization` de HTTP.
- Errores de handshake (`connect_error`): `err.data.code` es `UNAUTHENTICATED` (sin token) o `TOKEN_INVALID` (inválido o vencido); `err.message` viene en español.
- Vencimiento: el servidor corta el socket cuando vence el token de acceso (`disconnect` con motivo `io server disconnect`). La app renueva el token (`POST /auth/refresh`) y vuelve a conectar.
- El cliente **no envía eventos** ni elige salas: todo cambio se hace por REST.

## Salas

| Sala | Quién está | Cuándo |
| --- | --- | --- |
| `user:{userId}` | todos los sockets del usuario | al conectar |
| `request:{requestId}` | el empleador y los trabajadores notificados | la une el servidor al notificar; se vacía al asignar, cancelar o expirar |

## Reconexión y resincronización

Los eventos son **avisos**: el estado verdadero está en la API. Al (re)conectar, y cada vez que llega un aviso, la app pide el estado por REST:

- trabajador: `GET /worker/requests` (solicitudes abiertas que le llegaron, con su oferta);
- empleador: `GET /requests/{id}` y `GET /requests/{id}/offers`.

Un evento perdido mientras no había conexión no deja a la app en un estado incorrecto.

## Eventos

Los montos son strings con 2 decimales (Bs). Las fechas, ISO 8601 en UTC.

### `request:new`
Para: el trabajador notificado (`user:{id}`). Hay una solicitud cerca; el detalle (descripción, fotos firmadas) se pide con `GET /worker/requests/{requestId}`.

```json
{
  "requestId": "uuid",
  "ring": 1,
  "distanceM": 850,
  "category": { "slug": "plomeria", "name": "Plomería" },
  "proposedPriceBs": "150.00",
  "respondBy": "2026-10-15T14:00:45.000Z"
}
```

### `offer:new`
Para: el empleador (`user:{id}`). Llegó o se reemplazó una oferta. La lista completa, con `GET /requests/{requestId}/offers`.

```json
{
  "requestId": "uuid",
  "offerId": "uuid",
  "type": "counter",
  "amountBs": "180.00",
  "etaMin": 12,
  "worker": { "shortName": "María P.", "ratingAvg": "4.80", "ratingCount": 25 }
}
```

`type`: `accept` (aceptó el precio propuesto) o `counter` (contraoferta).

### `request:assigned`
Para: el empleador y todos los trabajadores notificados. `jobId` solo viene para las dos partes (empleador y trabajador elegido); para los demás es `null`. Con el `jobId`, el contacto se pide a `GET /jobs/{jobId}/contact`.

```json
{ "requestId": "uuid", "jobId": "uuid" }
```

### `request:expired`
Para: el empleador y los notificados (sala `request:{id}`). Nadie ofertó a tiempo, o había ofertas y el empleador no eligió dentro del plazo (R4.5).

```json
{ "requestId": "uuid" }
```

### `offer:closed`
Para: los trabajadores notificados u ofertantes. Ya no pueden ofertar, o su oferta se cerró.

```json
{ "requestId": "uuid", "reason": "elegida_otra" }
```

`reason`: `elegida_otra` (el empleador eligió otra oferta), `cancelada` (el empleador canceló) o `expirada`.

## Reservados (fases siguientes)

`job:status`, `job:location`, `chat:message` (Fase 4), `billing:due` (Fase 5), `account:blocked`, `account:unblocked`.

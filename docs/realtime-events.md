# Eventos en tiempo real (Socket.IO)

> Contrato de los eventos que la API envía por Socket.IO (ADR-0023). No salen en Swagger.
> Fuente en el código: `backend/src/realtime/realtime.events.ts` (tipos `RealtimePayloads`).

## Conexión

- URL: la misma de la API (`SOCKET_URL` en la app), ruta por defecto `/socket.io`. Transporte: **solo `websocket`** (el servidor rechaza `polling`; ADR-0023).
- Autenticación: en el handshake, `auth: { token: "<token de acceso>" }`. Se valida igual que el header `Authorization` de HTTP.
- Errores de handshake (`connect_error`): `err.data.code` es `UNAUTHENTICATED` (sin token) o `TOKEN_INVALID` (inválido o vencido); `err.message` viene en español.
- Vencimiento: el servidor corta el socket cuando vence el token de acceso (`disconnect` con motivo `io server disconnect`). La app renueva el token (`POST /auth/refresh`) y vuelve a conectar.
- El cliente **no envía eventos** ni elige salas: todo cambio se hace por REST.
- Presencia: mientras el socket está conectado, el usuario cuenta como "conectado" y los mensajes de chat no le llegan por push (ADR-0031).

## Salas

| Sala | Quién está | Cuándo |
| --- | --- | --- |
| `user:{userId}` | todos los sockets del usuario | al conectar |
| `request:{requestId}` | el empleador y los trabajadores notificados | la une el servidor al notificar; se vacía al asignar, cancelar o expirar |

## Reconexión y resincronización

Los eventos son **avisos**: el estado verdadero está en la API. Al (re)conectar, y cada vez que llega un aviso, la app pide el estado por REST:

- trabajador: `GET /worker/requests` (solicitudes abiertas que le llegaron, con su oferta);
- empleador: `GET /requests/{id}` y `GET /requests/{id}/offers`;
- trabajo (las dos partes): `GET /jobs/{id}`, `GET /jobs/{id}/messages` y, el empleador en camino, `GET /jobs/{id}/location`;
- cobros (trabajador): `GET /me/earnings/summary`, `GET /me/billing/pay-info` y `GET /me` (estado y modo).

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

También va **al empleador** con `reason: "retirada"` y `offerId` cuando una oferta se retira (Fase 4): la retiró el trabajador, o se retiró sola porque el trabajador fue elegido en otra solicitud o ya estaba ocupado. Si era la única, la solicitud vuelve a `buscando`.

```json
{ "requestId": "uuid", "reason": "retirada", "offerId": "uuid" }
```

### `job:status`
Para: las dos partes del trabajo (`user:{id}`). El trabajo cambió (ADR-0029); el detalle, con `GET /jobs/{jobId}`.

```json
{ "jobId": "uuid", "requestId": "uuid", "status": "en_curso", "action": "FINISH" }
```

`status`: `asignado`, `en_camino`, `en_curso`, `terminado` o `cancelado`. `action` dice qué pasó: `START_TRIP`, `START_WORK`, `FINISH` ("Terminé"), `CONFIRM`, `AUTO_CONFIRM`, `DISPUTE`, `RESOLVE_CONFIRM`, `RESOLVE_CANCEL` o `CANCEL`. `FINISH` y `DISPUTE` no cambian el estado.

### `job:location`
Para: **solo el empleador** del trabajo, mientras el trabajador va en camino. Como máximo uno cada 5 s (`JOB_LOCATION_EMIT_MS`). Deja de llegar al pasar a en curso o al cancelar.

```json
{ "jobId": "uuid", "latitude": -17.7834, "longitude": -63.1821, "at": "2026-10-16T14:00:05.000Z" }
```

### `chat:message`
Para: las dos partes del trabajo (también llega a los otros dispositivos de quien lo envió). Solo mensajes entregados: un mensaje retenido por moderación no se emite (ADR-0031). Si el destinatario no está conectado, además recibe un aviso con push.

```json
{
  "jobId": "uuid",
  "messageId": "uuid",
  "senderId": "uuid",
  "body": "Llego en 10 minutos.",
  "createdAt": "2026-10-16T14:00:00.000Z"
}
```

### `billing:due`
Para: el trabajador (`user:{id}`). Hay una comisión para pagar (R7.6, ADR-0036). Llega al cerrar el corte (`cierre`), la víspera (`vispera`) y el día del vencimiento (`dia`), a las 09:00 locales; una sola vez por periodo y tipo. Si ya pagó, no llega. Detalle con `GET /me/billing/pay-info`.

```json
{
  "periodId": "uuid",
  "kind": "cierre",
  "amountBs": "19.50",
  "paymentReference": "SISI-2643-K7M2QX",
  "dueAt": "2026-10-22T04:00:00.000Z"
}
```

`dueAt` es exclusivo: jueves 00:00 local, que se muestra como "miércoles 23:59".

### `account:blocked`
Para: el trabajador. Su modo trabajador quedó bloqueado: por deuda vencida (R7.7) o por moderación (R9.3). La cuenta ya pasó a modo empleador y puede seguir pidiendo servicios (R1.6).

```json
{ "reason": "deuda", "status": "bloqueado_deuda" }
```

`reason`: `deuda` (`status: bloqueado_deuda`; la app lleva a "Pagar comisión") o `moderacion` (`status: suspendido_moderacion`).

### `account:unblocked`
Para: el trabajador. Se levantó el bloqueo (por ejemplo, al registrarse su pago). **No cambia de modo solo:** vuelve a trabajador con el interruptor.

```json
{ "status": "aprobado" }
```

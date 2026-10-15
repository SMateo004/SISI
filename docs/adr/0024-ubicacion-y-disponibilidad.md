# ADR-0024: Ubicación en vivo y disponibilidad del trabajador

- Estado: aceptada
- Fecha: 2026-10-15
- Fase: 3

## Contexto
R4.1 exige trabajadores "disponibles" y cerca. El doc 02 define `worker_locations` con una copia en vivo en Redis GEO. Escribir en Postgres en cada reporte de GPS sería costoso, y la ubicación en segundo plano requiere permisos especiales y pasa por la revisión de las tiendas (Android `ACCESS_BACKGROUND_LOCATION` y servicio en primer plano; iOS "Always").

## Decisión
- **Tabla `worker_locations`:**
  - `worker_id`, `city_id`;
  - `geog geography(Point,4326)` con índice GiST;
  - `available`, `available_since`, `located_at`.
  - CHECK: disponible exige ubicación.
- **Toggle "Disponible"** (`PUT /worker/availability`): exige modo worker, perfil `aprobado` y la ubicación actual. Si no, responde 409 con el mismo código y mensaje que el interruptor de modo (`WORKER_UNDER_REVIEW`, `WORKER_BLOCKED_DEBT`...) o `WORKER_MODE_REQUIRED`.
- **Ubicación** (`POST /worker/location`, solo con "Disponible"; límite por usuario `RATE_WORKER_LOCATION_PER_MIN`):
  - siempre a Redis GEO `geo:workers:{ciudad}`;
  - a Postgres solo si pasaron `WORKER_LOCATION_PERSIST_MS` (30 s) o se movió más de `WORKER_LOCATION_PERSIST_M` (100 m) desde el último punto guardado (`shouldPersist`, función pura).
  - La app envía cada `sendEverySec` (lo devuelve la API).
- **Vencimiento:** sin ubicación en `WORKER_LOCATION_STALE_MS` (10 min) no cuenta como disponible.
  - El matching filtra por `located_at`.
  - Un barrido periódico (`LOCATION_SWEEP_MS`) marca `available = false` y limpia Redis.
- **No disponible automática** (en la misma transacción del cambio, `WorkerAvailabilityService.markUnavailable`):
  - al pasar a modo empleador;
  - con cualquier estado distinto de `aprobado` (bloqueo por deuda, suspensión, etc.).
- **MVP solo en primer plano:** la app envía la ubicación mientras está abierta y el trabajador está disponible. Al pasar a segundo plano deja de enviarla; a los 10 min deja de estar disponible.
- **Fuente de verdad:** Postgres. Redis GEO es la copia en vivo (para `job:location` en la Fase 4 y diagnóstico); si se pierde, no afecta al matching (ADR-0025).

## Consecuencias
- Un trabajador que cierra la app deja de recibir solicitudes a los 10 minutos como máximo; hasta entonces puede recibir alguna que no verá en vivo (le llega por push).
- La ubicación en segundo plano queda pendiente: permisos, textos para las tiendas y consumo de batería (docs/pendientes.md).
- La posición en Postgres puede estar atrasada hasta 30 s o 100 m: aceptable para anillos de 2, 5 y 10 km.

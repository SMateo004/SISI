# ADR-0025: Matching por anillos

- Estado: aceptada
- Fecha: 2026-10-15
- Fase: 3

## Contexto
R4 define candidatos (R4.1), anillos (R4.2), espera por anillo (R4.3), orden (R4.4) y expiración (R4.5). El doc 02 §5 lo plantea como jobs de BullMQ con consultas PostGIS. Los eventos no pueden perderse (ADR-0022), y los tiempos deben poder ser de milisegundos en los tests.

## Decisión
- **Jobs en la cola `matching`** del worker, con jobId determinístico: `ring_{id}_{n}`, `close_{id}` y `expire_{id}`.
  - Cada job bloquea la solicitud (`SELECT … FOR UPDATE`) y revisa su estado y su anillo. Repetirlo no repite avisos ni transiciones.
  - Los cambios de estado pasan por `RequestStatusService` y los efectos, por el outbox.
- **Selección en dos pasos:**
  1. **SQL (PostGIS, fuente de verdad):** trabajadores de la ciudad y la categoría, disponibles, a ≤ radio del anillo (`ST_DWithin` sobre geography con el índice GiST de `worker_locations`). Devuelve estado, modo, ubicación, radio máximo, distancia, calificación y si ya fue notificado.
  2. **`selectCandidates`, función pura:** aplica todos los criterios de R4.1:
     - aprobado, modo worker, disponible, ubicación de menos de 10 min;
     - con la categoría;
     - distancia ≤ su `max_radius_km` y ≤ el radio del anillo;
     - **no es el propio empleador**;
     - no fue notificado antes;
     - pasa el hook de tope de deuda (`DebtCapPolicy`, hoy siempre elegible; Fase 5).
     - Ordena por distancia y calificación (R4.4) y corta al límite del anillo.
  - Redis GEO **no** decide: la consulta en Postgres es consistente con estado, modo y categorías en la misma transacción, y con GiST alcanza a la escala del MVP. Redis GEO queda como copia en vivo (ADR-0024).
- **Configuración** (todo por entorno, propuestas en docs/pendientes.md):
  - `MATCHING_RINGS=2:5,5:10,10:10` (km:límite; anillos 2 y 3 con 10, propuesta);
  - `MATCHING_RING_WAIT_MS=45000`;
  - `MATCHING_ENOUGH_OFFERS=3`;
  - `MATCHING_OFFERS_GRACE_MS=600000`.
  - Los e2e usan 3000 ms para ambos (margen para ofertar o cancelar dentro de un anillo con la máquina cargada).
- **Progresión** (`ring-plan.ts`, puro):
  - el anillo que avisó a alguien espera `RING_WAIT` antes de ampliar;
  - **un anillo sin candidatos nuevos amplía de inmediato** (decidido en el plan);
  - con ≥ `ENOUGH_OFFERS` ofertas activas no amplía y pasa al cierre;
  - el cierre nunca corta antes el plazo del último aviso.
- **Cierre (R4.5):** con ofertas, `expires_at = ahora + gracia`; si el empleador no elige a tiempo, `expirada` y las ofertas se cierran (`offer:closed`). Sin ofertas, expira solo después del **tiempo mínimo de búsqueda**.
- **Tiempo mínimo de búsqueda** (Fase 4, propuesta: `MATCHING_MIN_SEARCH_MS=180000`, `MATCHING_RESCAN_MS=45000`):
  - sin ofertas y antes de `published_at + mínimo`, el cierre vuelve a consultar el radio del último anillo (sin repetir a los ya avisados) y se reprograma cada 45 s;
  - el reintento nunca corta el plazo de un aviso recién enviado;
  - al cumplirse el mínimo, sin ofertas, expira.
- **Cierres numerados:** cada cierre o expiración programado lleva `close_seq` en el jobId (`close_{id}_{seq}`, `expire_{id}_{seq}`), porque BullMQ ignora un jobId repetido mientras el anterior siga guardado. Un job con un número viejo no hace nada. El reconciliador arma el jobId con el `close_seq` de la base.
- **Avisos:** por cada notificado, evento de outbox `request.notified`; el handler une al trabajador a la sala, emite `request:new` y envía el push. `request_notifications` registra quién, en qué anillo, a qué distancia y cuándo.
- **Cancelación:** en la misma transacción se cierran las ofertas y se escribe `request.cancelled`. El handler quita los jobs pendientes y avisa con `offer:closed`.
- **Interruptor por ciudad:** flag `matching.enabled` (seed: encendido en Santa Cruz). Apagado, el job falla y se reintenta; luego lo retoma el reconciliador al volver a encenderlo.
- **Reconciliador** (ADR-0022): conoce el job esperado de cada estado (anillo siguiente con la espera restante, cierre o expiración).
- **Apagado ordenado:** relay y workers de BullMQ se detienen en `beforeApplicationShutdown` y Prisma se desconecta al final, para no reabrir conexiones durante un deploy.

## Consecuencias
- Sin trabajadores cerca, la solicitud expira casi de inmediato (todos los anillos vacíos). Si se prefiere un tiempo mínimo de búsqueda, es un parámetro nuevo (docs/pendientes.md).
- La consulta trae todos los disponibles de la categoría dentro del anillo. Si una ciudad crece mucho, se puede limitar en SQL o prefiltrar con Redis GEO sin cambiar la regla pura.
- El tope de deuda se conecta en la Fase 5 implementando `DebtCapPolicy`.

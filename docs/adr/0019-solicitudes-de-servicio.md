# ADR-0019: Solicitudes: borrador, máquina de estados, PostGIS y validación de ubicación

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 2

## Contexto
R3 define la solicitud del empleador (categoría, descripción, fotos, ubicación, precio propuesto) y R3.4 sus estados. Las fotos se suben directo al almacenamiento (ADR-0012), así que la solicitud debe existir antes de tener fotos. La Fase 3 buscará trabajadores por cercanía.

## Decisión
- **Flujo en borrador**: `POST /requests` crea `borrador` → `POST /requests/:id/photos/upload-url` y `PUT /requests/:id/photos` (confirmación con HEAD, prefijo `requests/{id}/`, máx. 4) → `POST /requests/:id/publish`. Solo en modo empleador (403 `EMPLOYER_MODE_REQUIRED`).
- **Máquina de estados** (`request-status.machine.ts`, tabla pura): borrador→retenida|buscando|cancelada · retenida→buscando (admin libera)|cancelada (admin rechaza, `cancel_reason=moderacion`) · buscando→con_ofertas|cancelada|expirada · con_ofertas→asignada|cancelada|expirada. Lo demás → 409. `RequestStatusService` escribe con control de concurrencia (`where status = actual`) y deja fila en `service_request_events` (append-only).
- **Ubicación**: columna `geog geography(Point,4326)` con índice GiST (`Unsupported` en Prisma; se lee y escribe con SQL crudo). La ciudad tiene `center`, `service_radius_km` y `service_area` (polígono) opcional. Válida si cae dentro del polígono (`ST_Covers`) o, sin polígono, a ≤ radio del centro. Santa Cruz: Plaza 24 de Septiembre, radio **provisional** 15 km.
- **Precio**: Decimal(10,2) > 0. Bajo el mínimo efectivo (ADR-0016) no se rechaza: responde la advertencia `PRICE_BELOW_REFERENCE` (R3.2).
- **Publicar**: modera descripción y dirección (ADR-0018) → `retenida` con las coincidencias guardadas y mensaje neutral, o `buscando` y evento `request.searching` (ADR-0020).
- **Límites**: por usuario 10 publicaciones por hora y 30 por día (`RateLimitStore`), y por IP para crear borradores (`@RateLimit`, ADR-0010).
- Admin: `GET /admin/requests?status=`, `POST /admin/requests/:id/release`, `POST /admin/requests/:id/reject`.

## Consecuencias
La Fase 3 consulta por cercanía con el índice GiST y escucha `request.searching`. Los borradores abandonados (y sus fotos) quedan en la base: falta un job de limpieza (docs/pendientes.md).

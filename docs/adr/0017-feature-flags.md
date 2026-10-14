# ADR-0017: Feature flags por ciudad con caché en Redis

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 2

## Contexto
R10.2 pide activar o desactivar funciones por ciudad sin desplegar. Se consultan en caminos calientes (publicar solicitudes, matching), así que no deben costar una consulta a Postgres cada vez.

## Decisión
- Tabla `feature_flags` (`key`, `city_id` opcional, `enabled`, `description`). Unicidad `(key, city_id)` con `NULLS NOT DISTINCT` (un solo valor global por clave) y CHECK de formato de clave (`a-z0-9._-`).
- `FeatureFlagsService.isEnabled(key, cityId?)`: precedencia **ciudad > global > false** (`resolveFlag`, función pura).
- Caché en Redis `ff:{key}` (todas las filas de la clave) con TTL de 60 s; al cambiar un flag se hace `DEL` de la clave, así el cambio se ve de inmediato en todas las instancias.
- Escritura con `INSERT … ON CONFLICT` en SQL (Prisma no expresa el conflicto sobre `NULLS NOT DISTINCT`).
- Admin: `GET /admin/feature-flags`, `PUT /admin/feature-flags/:key` (`{ enabled, cityId?, description? }`).
- Implementación propia: no se agrega una librería de flags (no hace falta segmentación por usuario ni porcentajes en el MVP).

## Consecuencias
Un flag inexistente está apagado: las funciones nuevas nacen desactivadas. Si más adelante se necesita lanzamiento gradual por porcentaje, se extiende `resolveFlag`.

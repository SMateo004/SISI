# ADR-0004: Infra local equivalente a producción

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
Render ofrece Postgres 17 con PostGIS y Key Value compatible con Redis. Las colas BullMQ requieren `noeviction`.

## Decisión
`infra/docker-compose.yml` usa `postgis/postgis:17-3.5` y `redis:7-alpine` con `maxmemory-policy noeviction` y AOF. Se crea además la base `sisi_test` para tests e2e. CI usa las mismas imágenes.

## Consecuencias
Lo que pasa en local y en CI se parece a producción. Actualizar la versión aquí, en CI y en `render.yaml` a la vez.

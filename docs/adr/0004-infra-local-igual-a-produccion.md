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

Puertos del host: 15432 (Postgres) y 16379 (Redis), para no chocar con instalaciones nativas en 5432/5433/6379. Se cambian con `SISI_DB_PORT` y `SISI_REDIS_PORT`.

**Actualización (Fase 4, 2026-10-17):** los puertos del host pasaron de 55432/56379/59000/59001 a **15432/16379/19000/19001**. Los anteriores caían en el rango dinámico de Windows (49152–65535), donde Hyper-V/WinNAT reserva bloques que cambian al reiniciar (`netsh interface ipv4 show excludedportrange protocol=tcp`). Así, un día Docker no pudo publicar 56379. Los nuevos quedan fuera de ese rango y siguen sin chocar con los servicios nativos (5432, 5433, 6379).

# ADR-0007: Render Blueprint con entornos staging y production

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
Se necesitan `api`, `worker`, `billing-cron`, `db` y `cache` en staging (develop) y producción (main).

## Decisión
Un solo `render.yaml` con `projects` → `environments` (`staging`, `production`). Los nombres de servicio llevan sufijo de entorno porque deben ser únicos en el workspace. Migraciones con `preDeployCommand: npx prisma migrate deploy` en `api`. Secretos con `sync: false` o `generateValue: true`; nunca en el archivo. Región `virginia`.

## Consecuencias
Cualquier cambio de infraestructura pasa por PR al `render.yaml`. `billing-cron` usa UTC (`59 3 * * 1` = domingo 23:59 en Bolivia).

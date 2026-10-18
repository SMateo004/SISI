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

## Actualización (Fase 7)
- **Producción no se despliega sola:** `autoDeployTrigger: off` en api, worker y billing-cron; los despliega `deploy-production` con deploy hooks y el sha del tag (ADR-0046). Staging sigue con `checksPass`.
- **Planes de producción:** api `standard`, worker y cron `starter`, Key Value `256mb` (pago, con persistencia) y Postgres `basic-1gb`.
- **Backups:** recuperación a un punto en el tiempo (3 días en un workspace Hobby, 7 en Pro) y exportes lógicos de 7 días. Restaurar crea una base nueva (runbook).
- **Worker:** recibe las variables del almacenamiento para borrar archivos (ADR-0049, ADR-0050).
- **El cron de cobros** ya no usa una hora fija de Bolivia: corre cada hora y los límites se calculan en la zona de la ciudad (ADR-0035, ADR-0036).

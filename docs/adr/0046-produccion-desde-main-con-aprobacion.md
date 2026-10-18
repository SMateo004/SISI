# ADR-0046: Producción desde main con aprobación, versión única y migraciones que expanden y luego contraen

- Estado: aceptada
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Producción no existía. Hasta la Fase 6, un merge a `main` desplegaba solo (`autoDeployTrigger: checksPass`) y la migración corría en el `preDeploy` de la API. El worker y el cron viejos seguían corriendo un rato contra el esquema nuevo. Faltaban tres cosas:
- un punto de control humano antes de producción;
- una versión única para backend y apps;
- una regla que impida que una migración rompa al código que todavía está corriendo.

## Decisión
- **Despliegue solo con un tag `vX.Y.Z` sobre `main`** (`deploy-production.yml`).
  1. `verify`:
     - el commit está en `main`;
     - backend-ci pasó en ese commit;
     - la versión de backend, mobile y admin coincide con el tag;
     - no hay textos legales en borrador (ADR-0051);
     - las migraciones son compatibles hacia atrás.
  2. `approve`: Environment `production-approval`, con revisores obligatorios. Una sola aprobación cubre todo.
  3. `backend`: deploy hooks de Render con `?ref=<sha>` para api, worker y billing-cron, y espera hasta que `GET /version` muestre ese sha y `/health` responda.
  4. `web`: `deploy-web` como workflow reutilizable con `environment=production`.
  - En `render.yaml` los servicios de producción quedan con `autoDeployTrigger: off`: un push a `main` no despliega nada solo. El Environment `production` de GitHub guarda los secretos y solo acepta tags `v*`.
- **Versión única:**
  - `tools/bump-version.mjs X.Y.Z` actualiza `backend/package.json` y los dos pubspec, y sube el número de build, que Play exige creciente;
  - `--check` lo valida;
  - `CHANGELOG.md` con Keep a Changelog;
  - el primer piloto es la `0.9.0`;
  - `GET /version` devuelve `{version, sha, env}`.
- **Expandir y luego contraer:** una migración nunca rompe la versión anterior del código.
  - Primero se agrega: columnas opcionales, tablas o índices nuevos.
  - El código pasa a usarlo, y en una release posterior se quita lo viejo.
  - `npm run check:migrations` falla en CI ante un `DROP`, `RENAME`, `SET NOT NULL`, `TRUNCATE`, `DELETE` o cambio de tipo si la línea anterior no lleva `-- contract: <motivo>`.
  - Las migraciones hasta `20261020000000` son anteriores a producción y quedan exentas: no se editan, porque cambiaría su checksum.

## Consecuencias
- Producción cambia solo con una persona que aprueba. Revertir el código es un deploy anterior (Render "Rollback" o un tag nuevo); revertir una migración, nunca: se corrige hacia adelante (runbook).
- La aprobación vive en un Environment aparte. Así, el workflow web, que es reutilizable, no pide una segunda aprobación.
- Una columna que deja de usarse sigue en la base una release más. Es el costo de no cortar el servicio en cada deploy.

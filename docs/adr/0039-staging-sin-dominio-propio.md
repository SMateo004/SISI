# ADR-0039: Staging sin dominio propio (URLs fijas de Render y Vercel)

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
SISI todavía no tiene dominio. `CORS_ORIGINS` de `api-staging` necesita orígenes fijos, pero los deployments preview de Vercel cambian de URL en cada deploy. La app web y el admin también necesitan una `API_URL` fija al compilar (`--dart-define`).

## Decisión
- **API:** la URL `https://<servicio>.onrender.com` de `api-staging`. Render la asigna al crear el servicio y no cambia entre deploys. Se usa igual para el socket (`SOCKET_URL`).
- **App web y admin:** proyectos de Vercel **separados por ambiente**: `app-web-staging` y `admin-staging` para staging, y los de producción aparte.
  - `deploy-web.yml` despliega siempre con `--prod` al proyecto del ambiente, elegido por los secretos `VERCEL_PROJECT_ID_*` del GitHub Environment (`staging` en develop, `production` en main).
  - Cada proyecto tiene su URL de producción fija, `https://<proyecto>.vercel.app`.
- **`CORS_ORIGINS` de `api-staging`:** `https://app-web-staging.vercel.app,https://admin-staging.vercel.app`. Si Vercel asigna otro nombre porque el subdominio está ocupado, se usa el que muestre el proyecto.
- **Proxy del admin:** el admin compila con `API_URL=/api` y llama a la API por su propio origen (`/api/*` → `API_URL`, rewrite generado por `apps/admin/tool/vercel-json.mjs`). Ver ADR-0040.

## Consecuencias
- URLs estables sin comprar dominio. Las previews por rama ya no se usan: develop es el único despliegue de staging.
- "Producción" en un proyecto de staging es solo la etiqueta de Vercel, no el ambiente de SISI: `APP_ENV` sigue siendo `staging`.
- **Migración a dominio propio:**
  1. asignar el dominio a cada proyecto en Vercel y como Custom Domain en Render;
  2. actualizar `CORS_ORIGINS`, las variables `API_URL` y `SOCKET_URL` del Environment y el CORS del bucket R2;
  3. volver a desplegar.

  No cambia código.

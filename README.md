# SISI — app de servicios inmediatos (Bolivia)

Monorepo de SISI: quien necesita un trabajo publica una solicitud, los trabajadores más cercanos ofertan y el empleador elige. Lanzamiento en Santa Cruz de la Sierra.

Antes de tocar código lee `CLAUDE.md` y los documentos de `docs/` (00 a 03), `docs/pendientes.md` y las decisiones en `docs/adr/`.

```
apps/mobile/            Flutter (Android, iOS, web → Vercel "app-web")
apps/admin/             Flutter web (→ Vercel "admin")
backend/                NestJS 12 + Prisma 7 + PostgreSQL/PostGIS + Redis
packages/api_contract/  OpenAPI generado y cliente Dart sisi_api
infra/                  docker-compose para desarrollo local
render.yaml             Blueprint de Render (staging y production)
.github/workflows/      backend-ci, deploy-web, mobile-release
```

## Requisitos

| Herramienta | Versión |
| --- | --- |
| Node.js | 24 LTS (`.nvmrc`; mínimo 24.9) |
| Flutter | 3.44.9 estable (la misma que usa CI) |
| Docker Desktop | con Docker Compose v2 |
| Git | cualquiera reciente |

## Levantar todo en local

### 1. Base de datos, Redis y almacenamiento

```bash
docker compose -f infra/docker-compose.yml up -d --wait
```

Crea:
- Postgres 17 + PostGIS 3.5 (bases `sisi` y `sisi_test`);
- Redis 7 con `noeviction`;
- RustFS (S3 local, reemplazo de MinIO; ADR-0012) con los buckets `sisi-local` y `sisi-test` y su CORS.

| Servicio | Puerto del host | Variable para cambiarlo |
| --- | --- | --- |
| Postgres | 55432 | `SISI_DB_PORT` |
| Redis | 56379 | `SISI_REDIS_PORT` |
| RustFS (API S3) | 59000 | `SISI_S3_PORT` |
| RustFS (consola web) | 59001 | `SISI_S3_CONSOLE_PORT` |

Los puertos son poco comunes a propósito, para no chocar con instalaciones nativas. Credenciales locales de RustFS: `sisi-local` / `sisi-local-secret`.

### 2. Backend

```bash
cd backend
cp .env.example .env          # valores de desarrollo; ajusta si cambiaste puertos
npm install                   # también genera el cliente Prisma
npx prisma migrate deploy     # habilita PostGIS y crea las tablas
npm run prisma:seed           # Santa Cruz de la Sierra (America/La_Paz)
npm run start:dev             # http://localhost:3000
```

**Login en local:** el código OTP no se envía por SMS; aparece en la consola de la API (`Código OTP para +591…`). Ver `docs/runbook.md`.

- Estado: <http://localhost:3000/health> → `{"status":"ok", ...}` (503 si la base, PostGIS o Redis fallan).
- Swagger: <http://localhost:3000/docs> (JSON en `/docs-json`).

Otros comandos:

```bash
npm run lint            # ESLint (strict-type-checked) + Prettier
npm test                # unitarios + Supertest con dependencias simuladas (no necesita Docker)
npm run test:e2e        # Supertest contra Postgres, Redis y RustFS reales (base sisi_test, bucket sisi-test)
npm run typecheck       # tsc --noEmit
npm run build
npm run start:worker            # proceso BullMQ (vacío hasta la Fase 3)
npm run start:billing-cron      # corte semanal (vacío hasta la Fase 5)
npm run prisma:migrate          # crear una migración nueva en desarrollo (y regenera el cliente)
npm run openapi:export          # actualiza packages/api_contract/openapi.json
npm run dev:tools -- review-worker --phone 70012345 --approve   # ver docs/runbook.md
```

Para regenerar el contrato completo (OpenAPI y cliente Dart; necesita Docker): `node packages/api_contract/generate.mjs`.

### Probar el flujo completo en local

1. Crear una categoría de prueba (no hay seed de categorías hasta la Fase 2):
   `cd backend && npm run build && node dist/scripts/dev-tools.js create-category --name "Plomeria prueba" --min 80 --max 250`
2. Abrir la app web (paso 3), ingresar un celular (p. ej. 70012345) y copiar el código de la consola de la API.
3. En "¿Quieres trabajar en SISI?" completar los 5 pasos y enviar.
4. Aprobar: `node dist/scripts/dev-tools.js review-worker --phone 70012345 --approve`.
5. En la app, mover el interruptor a **Trabajador**.

### 3. App (empleador + trabajador)

```bash
cd apps/mobile
flutter pub get
flutter run -d chrome --web-port 8080
# Emulador Android: la API local se ve como 10.0.2.2
flutter run --dart-define=API_URL=http://10.0.2.2:3000 --dart-define=SOCKET_URL=http://10.0.2.2:3000
flutter test
```

### 4. Panel admin

```bash
cd apps/admin
flutter pub get
flutter run -d chrome --web-port 8081
flutter test
```

Los puertos web 8080 y 8081 coinciden con `CORS_ORIGINS` del `.env` del backend.

## Configuración

- Backend: variables en `backend/.env.example`, validadas al arrancar con zod (`backend/src/config/env.schema.ts`). Si falta una obligatoria la API no arranca y dice cuál.
- Apps: `--dart-define` `API_URL`, `SOCKET_URL`, `APP_ENV` (ver `apps/*/.env.example`).
- Nunca subas secretos: `.env` está en `.gitignore`.

## Ramas y despliegue

| Rama | Ambiente | Backend (Render) | Web (Vercel) |
| --- | --- | --- | --- |
| `develop` | staging | `api-staging`, `worker-staging`, `billing-cron-staging` | deployment preview |
| `main` | production | `api`, `worker`, `billing-cron` | `--prod` |

Render despliega cuando pasa `backend-ci` (`autoDeployTrigger: checksPass`) y corre `prisma migrate deploy` + seed antes de cada deploy. Las webs se compilan en GitHub Actions y se suben con `vercel deploy --prebuilt`.

## Problemas comunes

- **`P1000: Authentication failed`**: hay otro Postgres escuchando en el puerto de `DATABASE_URL`. Usa el puerto de Docker (55432 por defecto).
- **Jest: `Must use import to load ES Module`**: estás con Node < 24.9. NestJS 12 es ESM y Jest necesita `require(esm)` (ver ADR-0008).
- **npm avisa de `install-scripts`**: npm 11 bloquea scripts de instalación; los necesarios ya están aprobados en `backend/package.json#allowScripts`.
- **`dev-tools` guarda nombres con `^`**: en Windows `npm run` escapa paréntesis y otros caracteres especiales. Usa `node dist/scripts/dev-tools.js …` directamente.
- **La app web no sube fotos**: revisa que RustFS esté arriba (`docker compose -f infra/docker-compose.yml ps`) y que la app corra en el puerto 8080 u 8081 (CORS del bucket).

# SISI — app de servicios inmediatos (Bolivia)

Monorepo de SISI: quien necesita un trabajo publica una solicitud, los trabajadores más cercanos ofertan y el empleador elige. Lanzamiento en Santa Cruz de la Sierra.

Antes de tocar código lee `CLAUDE.md` y los documentos de `docs/` (00 a 03), `docs/pendientes.md` y las decisiones en `docs/adr/`.

```
apps/mobile/            Flutter (Android, iOS, web → Vercel "app-web")
apps/admin/             Flutter web (→ Vercel "admin")
backend/                NestJS 12 + Prisma 7 + PostgreSQL/PostGIS + Redis
packages/api_contract/  OpenAPI generado (cliente Dart: pendiente)
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

### 1. Base de datos y Redis

```bash
docker compose -f infra/docker-compose.yml up -d --wait
```

Crea Postgres 17 + PostGIS 3.5 (bases `sisi` y `sisi_test`) y Redis 7 con `noeviction`.
Puertos del host: **55432** (Postgres) y **56379** (Redis), elegidos para no chocar con instalaciones nativas. Se pueden cambiar con `SISI_DB_PORT` / `SISI_REDIS_PORT`.

### 2. Backend

```bash
cd backend
cp .env.example .env          # valores de desarrollo; ajusta si cambiaste puertos
npm install                   # también genera el cliente Prisma
npx prisma migrate deploy     # habilita PostGIS y crea las tablas
npm run prisma:seed           # Santa Cruz de la Sierra (America/La_Paz)
npm run start:dev             # http://localhost:3000
```

- Estado: <http://localhost:3000/health> → `{"status":"ok", ...}` (503 si la base, PostGIS o Redis fallan).
- Swagger: <http://localhost:3000/docs> (JSON en `/docs-json`).

Otros comandos:

```bash
npm run lint            # ESLint (strict-type-checked) + Prettier
npm test                # unitarios + Supertest con dependencias simuladas (no necesita Docker)
npm run test:e2e        # Supertest contra Postgres/Redis reales (base sisi_test)
npm run build
npm run start:worker            # proceso BullMQ (vacío hasta la Fase 3)
npm run start:billing-cron      # corte semanal (vacío hasta la Fase 5)
npm run prisma:migrate          # crear una migración nueva en desarrollo
npm run openapi:export          # actualiza packages/api_contract/openapi.json
```

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

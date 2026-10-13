# SISI — Contexto técnico para Claude Code

> Lee primero `00-contexto-general-SISI.md` y `01-reglas-de-negocio.md`. Este documento define cómo se construye.

## 1. Arquitectura
- Clientes: app móvil Flutter (Android/iOS, tiendas), app web Flutter (Vercel), panel admin Flutter web (Vercel).
- Todos hablan con **una sola API** en Render por HTTPS + WebSocket.
- Render: `api` (Web Service NestJS + Socket.IO), `worker` (Background Worker BullMQ), `billing-cron` (Cron Job), Render Postgres + PostGIS, Render Key Value (Redis-compatible).
- Externos: Firebase Cloud Messaging, S3/Cloudflare R2, Google Maps o Mapbox.

## 2. Stack
| Capa | Tecnología |
| --- | --- |
| App y web | Flutter (estable), Riverpod, go_router, dio, socket_io_client, firebase_messaging, google_maps_flutter o mapbox |
| Admin | Flutter web |
| Backend | Node.js LTS, NestJS, TypeScript estricto |
| ORM | Prisma + SQL directo (`$queryRaw`) para PostGIS |
| BD | PostgreSQL + PostGIS |
| Tiempo real | Socket.IO + @socket.io/redis-adapter |
| Colas | BullMQ sobre Key Value |
| Auth | Teléfono + OTP (SMS/WhatsApp), JWT de acceso + refresh |
| Validación | class-validator / zod |
| Tests | Jest + Supertest (backend), flutter_test (app) |
| Observabilidad | Sentry, logs de Render |
| Contrato API | OpenAPI generado por NestJS Swagger; cliente Dart generado |

## 3. Estructura del monorepo
```
sisi/
├── CLAUDE.md
├── render.yaml
├── docs/                      # copia de 00, 01 y 02 + decisiones (ADR)
├── apps/
│   ├── mobile/                # Flutter: empleador + trabajador (Android, iOS, web)
│   │   ├── vercel.json
│   │   └── lib/
│   │       ├── core/          # tema, rutas, http, sockets, config por ambiente
│   │       ├── features/
│   │       │   ├── auth/
│   │       │   ├── mode_switch/
│   │       │   ├── requests/
│   │       │   ├── offers/
│   │       │   ├── jobs/
│   │       │   ├── worker_onboarding/
│   │       │   └── earnings/
│   │       └── shared/
│   └── admin/                 # Flutter web
│       └── vercel.json
├── backend/
│   ├── prisma/
│   └── src/
│       ├── auth/  users/  workers/  categories/  cities/
│       ├── requests/  matching/  offers/  jobs/  reviews/
│       ├── billing/  moderation/  notifications/  realtime/
│       ├── feature-flags/  storage/
│       └── common/
├── packages/api_contract/     # OpenAPI + cliente Dart generado
├── infra/docker-compose.yml   # Postgres+PostGIS y Redis locales
└── .github/workflows/
    ├── backend-ci.yml
    ├── deploy-web.yml         # Flutter web → Vercel
    └── mobile-release.yml
```

## 4. Modelo de datos
| Tabla | Campos clave |
| --- | --- |
| cities | id, nombre, país, zona horaria, activa |
| users | id, phone, name, photo_url, active_mode (employer/worker), city_id, created_at |
| worker_profiles | user_id, status (R1.4), transport, max_radius_km, rating_avg, rating_count, level |
| worker_categories | worker_id, category_id |
| worker_documents | worker_id, type (ci_front, ci_back, selfie, cert), file_key, review_status, reviewed_by |
| worker_locations | worker_id, geog (geography Point), available, updated_at (+ copia en vivo en Redis GEO) |
| categories | id, name, description, price_min_bs, price_max_bs, commission_pct, extra_requirements, active |
| category_cities | category_id, city_id, overrides |
| service_requests | id, employer_id, category_id, city_id, description, photos, geog, address, proposed_price_bs, status (R3.4), ring, created_at |
| offers | id, request_id, worker_id, type (accept/counter), amount_bs, eta_min, status |
| jobs | id, request_id, worker_id, employer_id, final_price_bs, commission_pct, commission_bs, status (R6.1), timestamps |
| reviews | id, job_id, from_user, to_user, stars, comment |
| billing_periods | id, worker_id, start, end, due_date, gross_bs, commission_bs, status (R7.8), payment_reference |
| ledger_entries | id, worker_id, period_id, job_id?, type (comision/pago/ajuste), amount_bs, created_at — **append-only** |
| payments | id, worker_id, period_id, amount_bs, method, receipt_key, registered_by, paid_at |
| reports | id, reporter_id, target_type, target_id, reason, status, resolution |
| moderation_terms | id, term/pattern, category |
| feature_flags | key, city_id?, enabled |
| notifications | id, user_id, type, payload, read_at |

Montos en Bs con 2 decimales (`Decimal`), nunca `float`. Fechas en UTC en BD; se muestran en hora de Bolivia.

## 5. Flujo de matching (R4)
1. Solicitud creada → moderación → estado `buscando`.
2. Job BullMQ `match:ring` con anillo 1: consulta PostGIS `ST_DWithin` sobre trabajadores aprobados, disponibles, de la categoría, no bloqueados y cuyo `max_radius_km` cubra la distancia; orden por distancia y rating; límite 5.
3. Emite evento Socket.IO `request:new` a esos trabajadores + push FCM.
4. Programa el siguiente anillo con delay de 45 s; si ya hay ofertas suficientes, no amplía.
5. Ofertas llegan por `offer:new` al empleador en vivo.
6. Aceptación → `job` creado, otras ofertas cerradas, `request:assigned` a todos los notificados.

## 6. Eventos en tiempo real (Socket.IO)
`request:new`, `request:assigned`, `request:expired`, `offer:new`, `offer:closed`, `job:status`, `job:location`, `chat:message`, `billing:due`, `account:blocked`, `account:unblocked`.

## 7. Billing (R7)
- Al terminar un job: insertar `ledger_entries` tipo `comision` y sumar al `billing_period` abierto.
- `billing-cron` domingo 23:59 (UTC−4): cierra periodos, genera referencia de pago, notifica.
- Revisión diaria: periodos vencidos → `bloqueado_deuda`.
- Registro de pago (admin o pasarela): `ledger_entries` tipo `pago`, periodo `pagado`, desbloqueo si no hay otra deuda.
- Revisión de tope de deuda en cada comisión nueva.

## 8. Despliegue
- `render.yaml`: servicios `api`, `worker`, `billing-cron`, base `db` (Postgres), `cache` (Key Value, `maxmemoryPolicy: noeviction`).
- Al crear la BD: `CREATE EXTENSION IF NOT EXISTS postgis;` (en una migración).
- CORS: solo dominios de Vercel y orígenes de la app.
- Vercel: proyectos `app-web` y `admin`; build en GitHub Actions con versión fija de Flutter (`flutter build web --release --dart-define=API_URL=...`), luego `vercel deploy --prebuilt`. `vercel.json` con rewrite de todas las rutas a `/index.html`.
- Ambientes: `develop` → staging, `main` → producción.
- Planes pagos en producción (un servicio inmediato no tolera arranques en frío).

## 9. Fases de desarrollo
| Fase | Semanas | Entregable |
| --- | --- | --- |
| 0. Base | 1 | Monorepo, CLAUDE.md, docker-compose, NestJS y Flutter vacíos, /health, CI, render.yaml y deploy a staging |
| 1. Cuentas | 2 | OTP, JWT, perfil, interruptor de modo, upgrade a trabajador con documentos |
| 2. Solicitudes | 2–3 | Categorías y ciudades, crear solicitud con fotos y mapa, moderación |
| 3. Matching y ofertas | 3 | Ubicación en vivo, anillos, ofertas y contraofertas en tiempo real |
| 4. Trabajo | 2 | Estados, chat, calificaciones, push |
| 5. Cobros | 2 | Ledger, cortes, pantalla de ganancias, historial de pagos, QR, bloqueo/desbloqueo |
| 6. Admin | 2 | Verificaciones, reportes, pagos, categorías, precios, feature flags |
| 7. Piloto | 2 | Pruebas con usuarios reales, tiendas, producción |

Forma de trabajo: cada fase empieza en **modo plan**; Claude propone diseño y archivos; se revisa; luego implementa con tests y los corre antes de terminar. Un commit/PR por funcionalidad.

## 10. Plantilla de CLAUDE.md
```
# SISI — app de servicios inmediatos (Bolivia)
Lee docs/00-contexto-general-SISI.md, docs/01-reglas-de-negocio.md y docs/02-contexto-tecnico-claude-code.md antes de cambiar algo.

## Stack
- backend/: NestJS + TypeScript estricto, Prisma, PostgreSQL+PostGIS, BullMQ, Socket.IO.
- apps/mobile y apps/admin: Flutter, Riverpod, go_router, carpeta por feature.
- Deploy: backend en Render (render.yaml), web en Vercel.

## Reglas
- No inventes reglas de negocio; si falta una, pregunta y anótala en docs/.
- Interfaz en español (Bolivia). Moneda Bs, montos Decimal con 2 decimales.
- ledger_entries es append-only: nunca UPDATE ni DELETE.
- Categorías solo desde la tabla categories.
- Toda entidad relevante lleva city_id.
- Cada funcionalidad lleva tests; corre los tests y el linter antes de dar por terminado.
- No subas secretos; usa variables de entorno (.env.example actualizado).

## Comandos
- Local: docker compose -f infra/docker-compose.yml up -d
- Backend: cd backend && npm run start:dev / npm test
- App: cd apps/mobile && flutter run / flutter test
```

## 11. Variables de entorno
Backend (Render): `DATABASE_URL`, `REDIS_URL`, `JWT_SECRET`, `JWT_REFRESH_SECRET`, `OTP_PROVIDER_KEY`, `FIREBASE_SERVICE_ACCOUNT`, `STORAGE_BUCKET`, `STORAGE_ACCESS_KEY`, `STORAGE_SECRET_KEY`, `MAPS_API_KEY`, `SENTRY_DSN`, `CORS_ORIGINS`, `TZ_DEFAULT=America/La_Paz`.
Frontend (build): `API_URL`, `SOCKET_URL`, `MAPS_API_KEY` (restringida por dominio), config de Firebase web.

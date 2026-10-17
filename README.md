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
| Postgres | 15432 | `SISI_DB_PORT` |
| Redis | 16379 | `SISI_REDIS_PORT` |
| RustFS (API S3) | 19000 | `SISI_S3_PORT` |
| RustFS (consola web) | 19001 | `SISI_S3_CONSOLE_PORT` |

Los puertos son poco comunes a propósito, para no chocar con instalaciones nativas. Credenciales locales de RustFS: `sisi-local` / `sisi-local-secret`.

### 2. Backend

```bash
cd backend
cp .env.example .env          # valores de desarrollo; ajusta si cambiaste puertos
npm install                   # también genera el cliente Prisma
npx prisma migrate deploy     # habilita PostGIS y crea las tablas
npm run prisma:seed           # Santa Cruz, 6 categorías (rangos provisionales) y términos de moderación; idempotente
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
npm run start:worker            # worker: relay del outbox, matching por anillos y avisos (ADR-0022)
npm run start:billing-cron      # corte semanal (vacío hasta la Fase 5)
npm run prisma:migrate          # crear una migración nueva en desarrollo (y regenera el cliente)
npm run openapi:export          # actualiza packages/api_contract/openapi.json
npm run dev:tools -- review-worker --phone 70012345 --approve   # ver docs/runbook.md
```

Para regenerar el contrato completo (OpenAPI y cliente Dart; necesita Docker): `node packages/api_contract/generate.mjs`.

### Probar el flujo completo en local

Cuentas y trabajador (Fase 1):

1. Abrir la app web (paso 3), ingresar un celular (p. ej. 70012345) y copiar el código de la consola de la API.
2. En "¿Quieres trabajar en SISI?" completar los 5 pasos y enviar (las categorías vienen del seed).
3. Aprobar: `cd backend && npm run build && node dist/scripts/dev-tools.js review-worker --phone 70012345 --approve`.
4. En la app, mover el interruptor a **Trabajador**.

Solicitudes (Fase 2), en modo **Empleador**:

1. "Pedir un servicio": categoría → descripción (mín. 20 caracteres) y fotos → mapa (sin llave de Maps aparece un mapa de prueba que se arrastra; la dirección la sugiere el geocodificador falso) → precio → Publicar. Queda en **Buscando trabajador**.
2. Repetir con un término prohibido en la descripción (p. ej. "marihuana" o "m4rihuana"): queda **En revisión** con un mensaje neutral.
3. Liberarla como admin por API (ver `docs/runbook.md`, "Solicitudes retenidas"). En "Mis solicitudes" pasa a **Buscando trabajador**.

Matching y ofertas (Fase 3): hacen falta **la API y el worker** corriendo (`npm run start:dev` y, en otra terminal, `npm run build && npm run start:worker`).

1. Dos sesiones a la vez en el mismo navegador: abrir la app en `http://localhost:8080` (empleador) y en `http://127.0.0.1:8080` (trabajador). Son orígenes distintos, así que cada una guarda su sesión. Agregar `http://127.0.0.1:8080` a `CORS_ORIGINS` del `.env`.
2. Trabajador: ingresar con otro celular (p. ej. 71111111) y aprobarlo sin subir documentos: `node dist/scripts/dev-tools.js quick-worker --phone 71111111 --categories plomeria,limpieza`. En la app, modo **Trabajador** → activar **Disponible** (pide la ubicación; debe estar a ≤ 2 km del punto de la solicitud para el anillo 1).
3. Empleador: pedir un servicio de una categoría del trabajador. Al trabajador le llega en vivo; puede **Aceptar precio** o **Contraofertar**. El empleador ve la oferta en vivo y la **elige**: los dos ven el teléfono del otro.
4. Sin trabajadores cerca (otra categoría), la solicitud expira enseguida y ofrece **Volver a publicar**.

Para ver los anillos sin esperar 45 s, bajar `MATCHING_RING_WAIT_MS` en el `.env` local.

Trabajo, chat y calificaciones (Fase 4), con las dos sesiones del paso anterior:

1. Después de elegir, las dos partes ven **el trabajo** (también en el inicio y en "Mis trabajos"): contacto con **Llamar** y **WhatsApp**, chat y línea de tiempo.
2. Trabajador: **Voy en camino**. Con la pantalla del trabajo abierta envía su ubicación cada 10 s; el empleador la ve en el mapa en vivo. Luego **Empecé el trabajo** y **Terminé el trabajo**.
3. Empleador: **Confirmar que terminó** (o **Hubo un problema**). Si no responde, se confirma solo (`JOB_AUTOCONFIRM_MS`, 24 h; bajarlo en local para probar).
4. Los dos califican. Cada calificación se ve cuando califican ambos. El trabajador ve en "Mis trabajos" el monto, la comisión y lo que recibe.
5. Chat: un mensaje con un término prohibido no le llega a la otra parte; quien lo envió ve un aviso neutral.
6. Cancelar en camino: cualquiera de los dos, con un motivo. El empleador puede **Volver a publicar**.

Disputas, reportes y mensajes retenidos se revisan por API o con `dev-tools` (ver `docs/runbook.md`).

Cobros (Fase 5), con el trabajador de antes y un admin (ver `docs/runbook.md`, "Cobros"):

1. Terminar dos trabajos (por ejemplo, 150 Bs y 80 Bs). En "Mis ganancias" el trabajador ve el bruto, la comisión (19,50 + 10,40) y el neto.
2. Simular el corte con el worker corriendo: `node dist/scripts/dev-tools.js billing-run --at <lunes 00:05 local en UTC>`. Llega el aviso con la referencia y el monto.
3. Simular el vencimiento (`--at <jueves 00:05 local>`): el modo trabajador queda bloqueado, el interruptor explica el motivo y lleva a "Pagar comisión", y el modo empleador sigue funcionando.
4. El admin registra el pago con el comprobante (`POST /admin/billing/payments` con `Idempotency-Key`): se desbloquea solo y el historial de pagos muestra el comprobante.

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
- Apps: `--dart-define` `API_URL`, `SOCKET_URL`, `APP_ENV` y, en la app, `MAPS_API_KEY` y `FIREBASE_*` (ver `apps/*/.env.example`).
- Nunca subas secretos: `.env` está en `.gitignore`.

### Llaves de Google Maps (ADR-0021)

Sin llaves todo funciona en local: el backend usa `GEOCODING_PROVIDER=fake` y la app muestra un mapa de prueba. Para usar Google hacen falta **llaves separadas**, creadas en Google Cloud Console → APIs y servicios → Credenciales, cada una restringida:

| Llave | Dónde va | Restricción de aplicación | Restricción de API |
| --- | --- | --- | --- |
| Servidor | Render: `MAPS_API_KEY` (sync:false) en `api` (y `api-staging` si se usa `google`) | Direcciones IP de salida de Render, si el plan las ofrece fijas; si no, ninguna | Solo **Geocoding API** |
| Web | GitHub Environments: variable `MAPS_API_KEY_WEB` | Sitios web (HTTP referrer): dominios de Vercel de la app | Solo **Maps JavaScript API** |
| Android | GitHub secret `MAPS_API_KEY_ANDROID`; en local `-PMAPS_API_KEY=…` o variable de entorno `MAPS_API_KEY` | Apps de Android: paquete + huella SHA-1 (debug, upload y la de Play App Signing) | Solo **Maps SDK for Android** |
| iOS | Xcode: build setting `MAPS_API_KEY` (llega a `Info.plist` → `GMSApiKey`) | Apps de iOS: bundle id | Solo **Maps SDK for iOS** |

La llave del servidor **nunca** se manda a la app. Las de la app son visibles para cualquiera; su protección son las restricciones. Poner alertas de presupuesto en el proyecto de Google Cloud.

Correr la app con llave: `flutter run -d chrome --web-port 8080 --dart-define=MAPS_API_KEY=<llave web>`.

### Firebase (push, ADR-0027)

Sin Firebase todo funciona en local: el backend usa `PUSH_PROVIDER=fake` (deja el aviso en el log y en la tabla `notifications`) y la app no pide permiso de notificaciones. Para activarlo:

1. **Proyecto:** en la [consola de Firebase](https://console.firebase.google.com) crear uno por ambiente (p. ej. `sisi-staging` y `sisi-prod`). Analytics no hace falta.
2. **Cuenta de servicio (backend):** Configuración del proyecto → Cuentas de servicio → "Generar nueva clave privada".
   - Pasar el JSON a base64 (`base64 -w0 clave.json`) y cargarlo en Render como `FIREBASE_SERVICE_ACCOUNT` (sync:false) en `api` y `worker`. Después, `PUSH_PROVIDER=fcm` (production ya lo trae en `render.yaml`).
   - Nunca subir el JSON a git (`firebase-service-account*.json` está en `.gitignore`). Borrar la copia local después de cargarla.
3. **App Android:** Configuración del proyecto → "Agregar app" → Android, con paquete `bo.sisi.sisi_mobile` (y la huella SHA-1 de la llave de firma).
   - De `google-services.json` solo se toman los valores, no se versiona: `mobilesdk_app_id` → `FIREBASE_APP_ID_ANDROID`; `current_key` → `FIREBASE_API_KEY_ANDROID`; `project_number` → `FIREBASE_SENDER_ID`; `project_id` → `FIREBASE_PROJECT_ID`.
   - Cargarlos como variables de GitHub (environment `production`) para `mobile-release.yml`.
4. **App web:** "Agregar app" → Web (sin Hosting).
   - Del objeto `firebaseConfig`: `apiKey` → `FIREBASE_API_KEY_WEB` y `appId` → `FIREBASE_APP_ID_WEB`, como variables de los environments `staging` y `production` de GitHub.
   - Restringir esa llave de API por HTTP referrer a los dominios de Vercel (Google Cloud → Credenciales).
5. **Llave VAPID (web):** Configuración del proyecto → Cloud Messaging → Configuración web → "Certificados de push web" → "Generar par de claves". La clave pública va como `FIREBASE_VAPID_KEY`.
   - `deploy-web.yml` la pasa por `--dart-define` y escribe `firebase-config.js` para el service worker.
6. **iOS:** pendiente hasta tener la cuenta de Apple (subir la llave APNs `.p8` en Cloud Messaging).

Probar en local con Firebase: `flutter run -d chrome --web-port 8080 --dart-define=FIREBASE_API_KEY=… --dart-define=FIREBASE_APP_ID=… --dart-define=FIREBASE_SENDER_ID=… --dart-define=FIREBASE_PROJECT_ID=… --dart-define=FIREBASE_VAPID_KEY=…`. Además hay que crear `apps/mobile/web/firebase-config.js` con `self.FIREBASE_CONFIG = {apiKey, appId, messagingSenderId, projectId};` (no se versiona).

## Ramas y despliegue

| Rama | Ambiente | Backend (Render) | Web (Vercel) |
| --- | --- | --- | --- |
| `develop` | staging | `api-staging`, `worker-staging`, `billing-cron-staging` | deployment preview |
| `main` | production | `api`, `worker`, `billing-cron` | `--prod` |

Render despliega cuando pasa `backend-ci` (`autoDeployTrigger: checksPass`) y corre `prisma migrate deploy` + seed antes de cada deploy. Las webs se compilan en GitHub Actions y se suben con `vercel deploy --prebuilt`.

## Problemas comunes

- **`P1000: Authentication failed`**: hay otro Postgres escuchando en el puerto de `DATABASE_URL`. Usa el puerto de Docker (15432 por defecto).
- **Jest: `Must use import to load ES Module`**: estás con Node < 24.9. NestJS 12 es ESM y Jest necesita `require(esm)` (ver ADR-0008).
- **npm avisa de `install-scripts`**: npm 11 bloquea scripts de instalación; los necesarios ya están aprobados en `backend/package.json#allowScripts`.
- **`dev-tools` guarda nombres con `^`**: en Windows `npm run` escapa paréntesis y otros caracteres especiales. Usa `node dist/scripts/dev-tools.js …` directamente.
- **La app web no sube fotos**: revisa que RustFS esté arriba (`docker compose -f infra/docker-compose.yml ps`) y que la app corra en el puerto 8080 u 8081 (CORS del bucket).

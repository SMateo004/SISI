# Runbook de SISI

Operación de los ambientes. Complementa el README (desarrollo local) y los ADR.

## ⚠️ Staging no es para usuarios reales

`api-staging` usa `OTP_PROVIDER=console`: **el código de cada login se escribe en los logs de Render** (ADR-0011). Cualquiera con acceso a los logs puede entrar a cualquier cuenta de staging.

Mientras esto siga así:
- No publicar staging (app, admin ni API) a personas fuera del equipo.
- No usar números ni documentos reales de terceros en staging.
- Para abrir staging a probadores externos, primero configurar Bird en staging: `OTP_PROVIDER=bird`, `OTP_PROVIDER_KEY` y `OTP_SENDER`.

Producción no arranca con el OTP por consola: la API se niega a iniciar.

## Montar staging (una sola vez)

Orden: R2 → Vercel → Render → GitHub. Staging y producción son Blueprints separados (`render.staging.yaml` y `render.yaml`): crear staging no crea los servicios pagos de producción.

1. **Cloudflare R2:**
   - crear el bucket `sisi-staging` (privado, sin acceso público ni `r2.dev`);
   - R2 → Manage API tokens → token con "Object Read & Write" solo para ese bucket. Anotar Access Key ID, Secret Access Key y el endpoint `https://<account_id>.r2.cloudflarestorage.com`;
   - bucket → Settings → CORS: el contenido de `infra/storage/cors.production.json` con las dos URLs de Vercel del paso 2.
2. **Vercel** (CLI, en tu terminal: `npm i -g vercel@63.1.2`, `vercel login`):
   - `vercel project add app-web-staging` y `vercel project add admin-staging`;
   - de cada proyecto, Settings → General → Project ID; del equipo, Settings → General → Team ID (es el `VERCEL_ORG_ID`);
   - Account → Tokens → token nuevo para GitHub Actions.
3. **Clave del panel de staging** (en tu terminal, distinta de la local): `cd backend && npm run dev:tools -- admin-totp`.
4. **Render:** New → Blueprint → repo `SISI`, rama `develop`, **Blueprint Path = `render.staging.yaml`**. Completar los valores `sync: false`:
   - `CORS_ORIGINS` = las URLs que Vercel asignó a los dos proyectos (Settings → Domains); hoy `https://app-web-staging.vercel.app,https://admin-staging-eight-snowy.vercel.app`;
   - `STORAGE_ENDPOINT`, `STORAGE_BUCKET` (`sisi-staging`), `STORAGE_ACCESS_KEY`, `STORAGE_SECRET_KEY` (paso 1), en `api-staging` y `worker-staging`;
   - `ADMIN_TOTP_SECRET` (paso 3);
   - el resto (`OTP_PROVIDER_KEY`, `OTP_SENDER`, `FIREBASE_SERVICE_ACCOUNT`, `MAPS_API_KEY`, `SENTRY_DSN`) puede quedar vacío en staging.
   - Al terminar el primer deploy: `curl https://<api-staging>.onrender.com/health`.
5. **GitHub → Settings → Environments → `staging`:**
   - secretos (en tu terminal): `gh secret set VERCEL_TOKEN --env staging`, y lo mismo con `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID_APP_WEB` y `VERCEL_PROJECT_ID_ADMIN`;
   - variables: `API_URL` y `SOCKET_URL` = `https://<api-staging>.onrender.com`.
6. **Publicar la web:** Actions → `deploy-web` → Run workflow (o un push a `develop`).

## Desplegar, revertir y ver logs (ADR-0039)

### URLs de staging
| Pieza | URL | Origen |
|---|---|---|
| API y socket | `https://api-staging-ch8k.onrender.com` | Render, servicio `api-staging` |
| App web | `https://app-web-staging.vercel.app` | Vercel, proyecto `app-web-staging` |
| Admin | `https://admin-staging-eight-snowy.vercel.app` (la API va por `/api/*`) | Vercel, proyecto `admin-staging` (`admin-staging.vercel.app` ya era de otra cuenta) |

`CORS_ORIGINS` de `api-staging` = las dos URLs de Vercel separadas por coma.

### Desplegar
- **Staging:** push o merge a `develop`.
  - Backend: Render despliega `api-staging`, `worker-staging` y `billing-cron-staging` solo si pasa backend-ci (`autoDeployTrigger: checksPass`). La API corre `prisma migrate deploy` y el seed antes de arrancar.
  - Web: `deploy-web` publica app-web y admin con `--prod` en sus proyectos de staging.
- **Producción:** solo con un tag `vX.Y.Z` sobre `main` y una aprobación manual. Un push a `main` no despliega nada (ADR-0046). Ver "Producción (Fase 7)".
- **Verificar:** `curl https://<api-staging>.onrender.com/health`, y el resumen del run de `deploy-web` (Actions), que muestra las URLs.

### Revertir
- **Backend:** Render → servicio → Events → deploy anterior → "Rollback". Una migración no se revierte sola: si el deploy malo incluía una, se escribe una migración correctiva (nunca editar una aplicada).
- **Web:** `vercel rollback <url-del-deployment-anterior> --token=…`, o Vercel → proyecto → Deployments → "Promote to Production" sobre el anterior.
- **Código:** `git revert <sha>` en `develop` o `main` y push. Vuelve a desplegar todo por el camino normal.

### Logs
- **API, worker y cron:** Render → servicio → Logs. El OTP de staging sale aquí.
- **Web:** Vercel → proyecto → Deployments → Logs (solo build; la app corre en el navegador).
- **CI y deploys:** GitHub → Actions (`backend-ci`, `deploy-web`).

## Probar un login en staging

1. Pedir el código desde la app.
2. Panel → **Códigos OTP**: aparece el código de cada número en segundos, con nombre y modo, o "Registro nuevo" (ADR-0056). Solo mientras no hay SMS; nunca en producción.
3. También sigue en Render → `api-staging` → Logs → `Código OTP para +591…`.

## Herramienta de desarrollo (`dev-tools`)

Sirve para aprobar o rechazar verificaciones, simular estados, crear categorías de prueba y dar rol admin. **Se niega a correr con `APP_ENV=production`.** No es un endpoint.

Local:
```bash
cd backend
npm run dev:tools -- review-worker --phone 70012345 --approve
```

Staging (Render → `api-staging` → Shell), sin recompilar:
```bash
node dist/scripts/dev-tools.js review-worker --phone 70012345 --approve
node dist/scripts/dev-tools.js review-worker --phone 70012345 --reject "La foto del carnet está borrosa"
node dist/scripts/dev-tools.js worker-event --phone 70012345 --event BLOCK_FOR_DEBT
node dist/scripts/dev-tools.js worker-event --phone 70012345 --event SUSPEND --reason "Prueba"
node dist/scripts/dev-tools.js create-category --name "Plomería prueba" --min 80 --max 250
node dist/scripts/dev-tools.js admin-totp   # clave nueva del panel (ADR-0055)
# Trabajador aprobado para pruebas, sin subir carnet ni selfie (pasa igual por SUBMIT + APPROVE):
node dist/scripts/dev-tools.js quick-worker --phone 71111111 --categories plomeria,limpieza --transport moto --radius 10
# Resolver una disputa de un trabajo (Fase 4): confirm = terminado con comisión; cancel = cancelado sin comisión.
node dist/scripts/dev-tools.js resolve-dispute --job <uuid> --decision confirm --reason "Se verificó con las dos partes"
# Resolver un reporte (Fase 4): --approve = válido (cuenta para la suspensión); --reject = descartado.
node dist/scripts/dev-tools.js resolve-report --report <uuid> --approve --reason "Se verificó el mensaje"
node dist/scripts/dev-tools.js resolve-report --report <uuid> --reject "No corresponde"
```

En Windows, si el argumento lleva paréntesis u otros caracteres especiales, usar `node dist/scripts/dev-tools.js …` directamente: `npm run` en Windows pasa los argumentos por `cmd` y les agrega `^`.

**Categorías:** el seed crea las 6 categorías de Santa Cruz (rangos provisionales). `create-category` crea una extra de prueba (slug `prueba-<fecha>`) activa en `DEFAULT_CITY_SLUG`.

## Solicitudes retenidas por moderación (R3.3)

Desde la Fase 6 se revisan en el panel (ver "Panel admin"). Por API, con una sesión del panel (`aud=admin`):

1. Ingresar al panel (`POST /auth/admin/login` con el usuario y el código de la app autenticadora, ADR-0055) y usar su token de acceso.
2. Ver las retenidas y qué término las retuvo (`matches`):
   ```bash
   curl -H "Authorization: Bearer $TOKEN" "$API/admin/requests?status=retenida"
   ```
3. Liberar (pasa a `buscando` y emite `request.searching`) o rechazar (pasa a `cancelada` con `cancel_reason=moderacion`):
   ```bash
   curl -X POST -H "Authorization: Bearer $TOKEN" "$API/admin/requests/<id>/release"
   curl -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"      -d '{"reason":"Ofrece venta de sustancias"}' "$API/admin/requests/<id>/reject"
   ```

El empleador nunca ve el término que disparó la retención, solo el mensaje neutral.

**Términos:** `GET/POST/PATCH/DELETE /admin/moderation-terms` (DELETE es baja lógica). Las regex se validan al guardar (ADR-0018). Los cambios se aplican en todas las instancias sin reiniciar.

**Feature flags:** `PUT /admin/feature-flags/<clave>` con `{"enabled":true,"cityId":"…"}` (sin `cityId` = global). Se ven de inmediato.

## Worker: outbox, matching y avisos (Fase 3)

El servicio `worker` de Render publica los eventos del outbox a BullMQ, corre los anillos de matching y envía los avisos (ADR-0022, ADR-0025, ADR-0027). Si está caído, las solicitudes quedan en `buscando` sin avisar a nadie, pero **no se pierden**: al volver, el relay publica lo pendiente y el reconciliador (cada 60 s) vuelve a encolar lo que falte.

Diagnóstico rápido (SQL de solo lectura en la base del ambiente):
```sql
-- Eventos sin publicar (debería ser ~0; si crece, el worker no corre o Redis falla).
SELECT type, count(*), min(created_at), max(attempts), max(last_error)
FROM outbox_events WHERE published_at IS NULL GROUP BY type;

-- Solicitudes abiertas y su anillo.
SELECT id, status, ring, ring_started_at, expires_at FROM service_requests
WHERE status IN ('buscando', 'con_ofertas') ORDER BY published_at;
```

**Pausar el matching en una ciudad** (interruptor de emergencia): `PUT /admin/feature-flags/matching.enabled` con `{"enabled": false, "cityId": "…"}`. Las solicitudes quedan en `buscando`; al volver a encenderlo, el reconciliador las retoma.

**Push:** con `PUSH_PROVIDER=fake` los avisos quedan en la tabla `notifications` y en el log del worker (`FakePush`). Con `fcm`, los tokens inválidos se borran solos. Si nadie recibe push, revisar `FIREBASE_SERVICE_ACCOUNT` en `api` y `worker` (README, "Firebase").

**Tests e2e:** no se pueden correr dos suites a la vez contra la misma infraestructura local (hay un candado en Postgres). `npm run test:e2e:repeat -- 20` corre la suite 20 veces y guarda las salidas en `backend/.e2e-runs/` (ADR-0028).

## Secretos y rotación

| Variable | Efecto de rotarla |
| --- | --- |
| `JWT_SECRET` | Invalida los tokens de acceso vigentes (máx. 15 min) y los OTP pendientes. |
| `JWT_REFRESH_SECRET` | Cierra todas las sesiones: todos vuelven a ingresar con su número. |
| `OTP_PROVIDER_KEY` | Rotar en Bird y actualizar en Render; no afecta las sesiones. |
| `FIREBASE_SERVICE_ACCOUNT` | Generar una clave nueva en Firebase, actualizarla en `api` y `worker`, y borrar la anterior en la consola. Los tokens de los dispositivos siguen sirviendo. |
| `STORAGE_ACCESS_KEY` / `STORAGE_SECRET_KEY` | Crear un token nuevo en R2, actualizarlo en `api` y `worker`, y revocar el anterior. Las URLs firmadas vigentes (≤ 15 min en producción) dejan de funcionar. |
| `SENTRY_DSN` | Crear una llave nueva en Sentry (Project → Client Keys), cargarla en api, worker y cron y en las variables `SENTRY_DSN_*` de GitHub, y desactivar la anterior. No afecta a los usuarios. |
| `MAPS_API_KEY` (servidor) | Crear la llave nueva con las mismas restricciones, cargarla, verificar una geocodificación y borrar la anterior. |
| Upload key de Android | No se rota sola: si se pierde o se filtra, Play Console → Integridad de la app → "Solicitar restablecimiento de la clave de carga" (Play App Signing conserva la llave de firma). |
| Deploy hooks de Render | Render → servicio → Settings → Deploy Hook → "Regenerate"; actualizar `RENDER_DEPLOY_HOOK_*` en el Environment `production`. |

Después de rotar: `GET /health` y, si tocó Bird o Firebase, el humo (ingresar con un número de prueba y recibir un aviso).

## Documentos de identidad (R9.5)

- Bucket privado. Carnet y selfie viven bajo `identity/{userId}/`.
- Solo un admin obtiene enlaces, de 5 minutos: `GET /admin/workers/{userId}/documents/{documentId}/url`.
- No compartir enlaces firmados fuera del panel ni por chat.

## Incidentes rápidos

- **Muchos 429 legítimos:** revisar `RATE_*` en Render (ADR-0010). Los contadores están en Redis con prefijo `rl:`; borrar una clave libera ese límite.
- **Bird caído o rechazando:** la API responde 503 `OTP_SEND_FAILED` y el detalle queda en el log (`BirdOtpProvider`). Revisar el saldo y los destinos habilitados en Bird.
- **Fallan las subidas en web:** revisar el CORS del bucket R2 (deben estar los dominios de Vercel).

## Disputas, reportes y mensajes retenidos (Fase 4)

Desde la Fase 6 se resuelven en el panel. Por API, con una sesión del panel (`aud=admin`):

- **Disputas** ("Hubo un problema", ADR-0029): el trabajo queda en curso, sin autoconfirmación ni comisión.
  ```bash
  curl -H "Authorization: Bearer $TOKEN" "$API/admin/jobs/disputed"
  curl -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
    -d '{"decision":"confirm","note":"Se verificó con las dos partes"}' "$API/admin/jobs/<id>/resolve"
  ```
  `confirm` lo deja terminado con comisión (emite `job.completed`); `cancel`, cancelado sin comisión y la solicitud cancelada. La nota queda en `job_events`.
- **Reportes** (ADR-0033): `GET /admin/reports?status=pendiente` y `POST /admin/reports/<id>/resolve` con `{"valid": true, "resolution": "…"}`. Con 3 reportes válidos de personas distintas, el trabajador queda `suspendido_moderacion` (modo empleador). Si solo es empleador, se marca `users.moderation_flagged_at` y aparece en el log del API como aviso.
- **Mensajes de chat retenidos** (ADR-0031): `GET /admin/chat/held` (no se entregan; solo los ve quien los envió).

`job_events` es append-only: un trigger rechaza `UPDATE` y `DELETE` (para corregir algo, se agrega un evento nuevo).

## Mantenimiento del worker

El reconciliador (cada `MATCHING_RECONCILE_MS`) también:
- autoconfirma los trabajos cuyo "Terminé" venció sin respuesta (respaldo del job `autoconfirm_{jobId}`);
- publica las calificaciones ciegas cuyo plazo venció.

Una vez por día (`OUTBOX_CLEANUP_MS`) se borran los eventos del outbox publicados hace más de `OUTBOX_RETENTION_DAYS` días.

## Cobros (Fase 5)

### Configurar el QR de cobro de la empresa
Con un usuario admin (`$TOKEN`):
```bash
# 1. URL de subida (imagen JPEG, PNG o HEIC del QR de la cuenta de la empresa)
curl -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"contentType":"image/png","sizeBytes":<bytes>}' "$API/admin/billing/qr/upload-url"
# 2. PUT del archivo a uploadUrl con los headers que devuelve
# 3. Guardarlo
curl -X PUT -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"key":"company/qr-cobro-…png"}' "$API/admin/billing/qr"
```
Los trabajadores lo ven en "Pagar comisión" con una URL temporal.

### Registrar un pago
1. Comprobantes enviados por los trabajadores: `GET /admin/billing/submissions` (pendientes).
2. Si hace falta subir el comprobante: `POST /admin/billing/receipts/upload-url` con `{workerId, contentType, sizeBytes}`, y después el PUT.
3. Registrar el pago. **`Idempotency-Key` es obligatorio:** usa una clave nueva por pago y la misma si reintentas.
   ```bash
   curl -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
     -H "Idempotency-Key: pago-<worker>-<fecha>-1" \
     -d '{"workerId":"<uuid>","amountBs":"29.90","method":"qr_transferencia","paidAt":"2026-10-21T15:00:00Z","reference":"SISI-2643-K7M2QX","receiptKey":"receipts/<uuid>/pago-….jpg","submissionId":"<uuid opcional>"}' \
     "$API/admin/billing/payments"
   ```
- Se aplica a los periodos más antiguos primero; lo que sobra queda a favor.
- Desbloquea solo si ya no queda ningún periodo vencido.
- Un admin no puede registrar pagos ni ajustes sobre su propia cuenta (403).
- Un comprobante ilegible se rechaza con `POST /admin/billing/submissions/<id>/reject {"note":"…"}`.

### Ajustes
Nunca se edita un movimiento. Se agrega un ajuste con signo (positivo aumenta la deuda), motivo obligatorio e `Idempotency-Key`:
```bash
curl -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -H "Idempotency-Key: ajuste-<worker>-1" \
  -d '{"workerId":"<uuid>","amountBs":"-19.50","reason":"Comisión cobrada por error","correctsEntryId":"42"}' \
  "$API/admin/billing/adjustments"
```
Saldo, periodos y movimientos de un trabajador: `GET /admin/billing/workers/<uuid>`.

### Corte y vencimiento
- `billing-cron` corre cada hora (`render.yaml`) y se pone al día solo. Si falla, la corrida siguiente recupera lo pendiente.
- Para probar con reloj simulado (nunca en producción), con el worker corriendo para que salgan los avisos y bloqueos:
  ```bash
  cd backend && npm run build
  node dist/scripts/dev-tools.js billing-run --at 2026-10-19T04:05:00Z   # lunes 00:05 en Bolivia: corte
  node dist/scripts/dev-tools.js billing-run --at 2026-10-20T13:05:00Z   # martes 09:05: víspera
  node dist/scripts/dev-tools.js billing-run --at 2026-10-22T04:05:00Z   # jueves 00:05: vencido → bloqueo
  ```
- El bloqueo por deuda lo decide billing: un `worker-event BLOCK_FOR_DEBT` manual sin periodos vencidos se revierte en el barrido del worker.

### Staging
- Variables: `BILLING_DUE_AFTER_DAYS`, `BILLING_REMINDER_HOUR`, `BILLING_DEBT_CAP_BS`, `BILLING_LOCK_TTL_MS` y `RECEIPT_URL_TTL_SEC`. Hay valores por defecto; ver `backend/.env.example`.
- El servicio `billing-cron-staging` necesita `DATABASE_URL` y `REDIS_URL` (candado). Ya están en `render.yaml`.
- Cargar el QR de prueba con el usuario admin de staging (sección de arriba).

## Panel admin (Fase 6)

### Acceso
- **Acceso:** una sola cuenta, usuario `admin` y código de la app autenticadora (ADR-0055). Ver "Producción → Acceso al panel" para generar y cargar la clave (también en staging).
- **Ingreso:** el admin entra con su celular y el código de 6 dígitos. La sesión dura 10 min de acceso y 8 h como máximo desde el login. El refresh va en una cookie httpOnly (ADR-0040). Una cuenta sin rol admin ve "Esta cuenta no tiene acceso al panel".
- **Una sesión del panel no sirve en la app ni al revés.** Las rutas `/admin` exigen `aud=admin`; por API se obtiene con `POST /auth/admin/login` (usuario y código de la app autenticadora, ADR-0055).

### Operación diaria
1. **Dashboard:** solicitudes, asignación, expiración, primera oferta, trabajos, cancelaciones, comisión generada y cobrada, deuda vencida y disponibles (hoy o esta semana, hora local).
2. **Menú:** los números son las colas pendientes y se actualizan solos (socket y, como respaldo, cada 60 s).
3. **Verificaciones**, de la más antigua a la más nueva: revisar datos, edad y requisitos extra; los documentos se ven con enlaces de 5 min.
   - **Aprobar** con una nota.
   - **Rechazar** con un motivo de la lista y una nota para el trabajador. Se le avisa con push.
4. **Moderación:**
   - **Retenidas:** liberar o rechazar, con motivo. Se muestra qué término coincidió.
   - **Chat retenido:** liberar o descartar.
   - **Reportes:** marcar como válido o descartarlo. Con 3 válidos de personas distintas, el trabajador queda suspendido.
   - **Disputas:** ver línea de tiempo, chat y ofertas, y confirmar (con comisión) o cancelar (sin comisión).
   - **Términos:** usar el probador antes de agregar uno.
5. **Cobros:**
   - **Comprobantes:** "Registrar pago" desde el comprobante. El monto viene precargado y la vista previa muestra el saldo y si desbloquea.
   - **Vencidos:** días de atraso.
   - **Ficha del trabajador:** ledger con saldo acumulado y ajustes ("Corregir" sobre un movimiento).
   - **QR de cobro.**
   - **Exportar:** CSV del ledger y de los pagos para el contador.
6. **Usuarios:** buscar por celular o nombre. Desde la ficha se puede suspender o reactivar al trabajador y quitar la marca "revisar" a un empleador.
7. **Catálogo y configuración:**
   - **Comisión:** cambiarla solo afecta a los trabajos asignados desde ese momento.
   - **Parámetros:** se escriben en su unidad (los tiempos, en minutos) y se aplican en segundos.
   - **Flags:** por ciudad.
8. **Auditoría:** toda acción que cambia algo queda con admin, motivo, antes y después. Filtrar por acción (p. ej. `billing.`) o por id del objetivo.

**Toda acción pide un motivo** (queda en la auditoría). **Ningún admin puede actuar sobre su propia cuenta** (403 `SELF_REVIEW_FORBIDDEN`).

### Configuración por ambiente
- **Staging y producción:**
  - el admin compila con `API_URL=/api`, y el proxy de Vercel lleva `/api/*` a la API (`apps/admin/tool/vercel-json.mjs`, lo genera `deploy-web`);
  - `SOCKET_URL` apunta directo a Render;
  - `ADMIN_COOKIE_PATH` no se define (por defecto `/api/auth/admin`);
  - `CORS_ORIGINS` de la API incluye la URL del admin (para el socket).
- **Local:**
  - `ADMIN_COOKIE_PATH=/auth/admin` en `backend/.env`;
  - `flutter run -d chrome --web-port 8081 --dart-define=API_URL=http://localhost:3000`.
- **Parámetros (ADR-0043):** el valor del panel manda; sin valor, el de la variable de entorno. "Volver al valor por defecto" borra el del panel. Si algo se comporta raro después de un cambio, revisar la auditoría (`config.setting_`).

## Producción (Fase 7)

### Antes del primer despliegue (una sola vez)
1. **GitHub → Settings → Environments:**
   - `production-approval`: revisores obligatorios (tú y otra persona). Sin secretos.
   - `production`: regla "Deployment branches and tags" que solo admita tags `v*`.
     - **Secretos:**
       - `RENDER_DEPLOY_HOOK_API`, `RENDER_DEPLOY_HOOK_WORKER`, `RENDER_DEPLOY_HOOK_CRON`;
       - `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID_APP_WEB`, `VERCEL_PROJECT_ID_ADMIN` (los proyectos de producción);
       - `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`;
       - `MAPS_API_KEY_ANDROID`.
     - **Variables:**
       - `API_URL`, `SOCKET_URL`, `MAPS_API_KEY_WEB`;
       - `FIREBASE_*` (web y Android), `FIREBASE_VAPID_KEY`;
       - `SENTRY_DSN_WEB`, `SENTRY_DSN_ADMIN`, `SENTRY_DSN_MOBILE`;
       - `ANDROID_APP_ID`, `APP_NAME`;
       - `CSP_ENFORCE` (`false` hasta validar la CSP).
2. **Render:** aplicar el Blueprint en el ambiente `production`. Cargar los valores `sync: false`:
   - `CORS_ORIGINS`: solo https, las URLs de Vercel de producción;
   - `OTP_PROVIDER_KEY` y `OTP_SENDER` (Bird);
   - `FIREBASE_SERVICE_ACCOUNT`;
   - `STORAGE_*` (bucket R2 de producción);
   - `MAPS_API_KEY` (servidor);
   - `SENTRY_DSN`.

   Copiar los deploy hooks de api, worker y billing-cron a los secretos de GitHub.
3. **R2:** bucket privado (sin acceso público ni `r2.dev`), CORS desde `infra/storage/cors.production.json` con las URLs reales y un token con permisos solo sobre ese bucket.
4. **Textos legales finales** en `backend/legal/` sin el marcador (si no, ni la API ni el AAB de producción se construyen).

### Desplegar
1. En `main`:

   ```bash
   node tools/bump-version.mjs 0.9.1
   ```

   Actualizar `CHANGELOG.md`, hacer el commit y esperar backend-ci en verde.
2. Crear y subir el tag:

   ```bash
   git tag v0.9.1
   git push origin v0.9.1
   ```
3. GitHub → Actions → `deploy-production`: `verify` revisa el commit, CI, versión, legales y migraciones. Luego **aprobar** en `approve`.
4. El workflow llama a los deploy hooks de Render con el sha y espera a que `GET /version` lo muestre y `/health` responda. Después publica la web.
5. **Humo:**
   - `GET /health`;
   - ingresar con tu número (OTP real);
   - publicar una solicitud de prueba y cancelarla.

### Revertir
- **Código:** Render → servicio → Events → el deploy anterior → "Rollback" (api, worker y cron). O un tag nuevo con el `git revert`.
- **Web:** Vercel → proyecto → Deployments → el anterior → "Promote to Production".
- **Migraciones:** **no se revierten.** Por la regla de expandir y luego contraer, una migración nunca rompe el código anterior, así que volver al deploy anterior funciona con el esquema nuevo. Si una migración tuvo un error, se corrige con otra migración hacia adelante; nunca se edita una aplicada. Para quitar algo (`DROP`), se espera a que ninguna versión en uso lo lea y se marca con `-- contract:`.

### Restaurar un backup de Postgres
Restaurar **nunca sobrescribe la base actual: crea una nueva.**

1. **Recuperación a un punto en el tiempo:** Render → `db` → Recovery → "Restore Database".
   - Nombre nuevo, por ejemplo `db-restore-AAAAMMDD`.
   - Elegir la hora (no puede ser de los últimos 10 minutos).
   - Ventana: 3 días en un workspace Hobby, 7 en Pro.
2. Validar los datos en la base nueva (Info → PSQL): conteos de `users`, `jobs` y `ledger_entries`, y el saldo de un trabajador conocido.
3. Pausar el cron (Render → `billing-cron` → Suspend) y el worker.
4. Cambiar `DATABASE_URL` de api, worker y billing-cron a la base nueva y redeployar los tres.
5. Reanudar el worker y el cron, y verificar `/health` y el panel.
6. La base original se conserva hasta confirmar. Después se suspende; no se borra sin una segunda persona.

**Exportes lógicos** (7 días): Recovery → Export. Sirven para llevar una copia afuera o restaurar en local con `pg_restore` sobre una base vacía.

### Re-ejecutar el cron de cobros
Es idempotente (ADR-0036): correrlo de más no duplica nada.
- Render → `billing-cron` → "Trigger Run". El monitor de Sentry recibe el check-in.
- Si el cron estuvo caído varias horas, una sola corrida pone todo al día.

### Acceso al panel (ADR-0055)
Una sola cuenta: usuario `admin` y el código de 6 dígitos de una app autenticadora. Sin teléfono ni SMS.
1. **Generar la clave** (en tu máquina, nunca en el servidor):

   ```bash
   cd backend
   npm run dev:tools -- admin-totp
   ```

   Muestra `ADMIN_TOTP_SECRET=…` y un enlace `otpauth://…`.
2. **Cargarla en el ambiente:** Render → `api` → Environment → `ADMIN_TOTP_SECRET`, y reiniciar. Producción no arranca sin ella. En local va en `backend/.env`.
3. **Cargarla en la app autenticadora** de cada persona del equipo: "Agregar código" → "Ingresar clave de configuración", cuenta "SISI admin", la clave y "Basada en el tiempo".
4. **Ingresar al panel** con el usuario `admin` y el código que muestra la app (cambia cada 30 s; cada código sirve una vez).
5. **Quitar el acceso a alguien:** generar una clave nueva, cambiarla en Render y volver a cargarla en la app de quienes siguen. La anterior deja de servir.
6. **"Demasiados intentos":** 20 intentos en 15 minutos o 30 en el día bloquean el ingreso para todos hasta que vence el tope. Llegan alertas por email: `admin-login-failures` (5 fallos en 15 min) y `admin-login-blocked`. Si nadie del equipo estaba intentando entrar, **rota la clave** (pasos 1 a 3). En local se destraba borrando `rl:adminLogin:*` en Redis.
7. **"El ingreso al panel no está configurado":** falta `ADMIN_TOTP_SECRET` en la API.

### Alertas (ADR-0048)
**En Sentry:**
- **Proyectos:** `sisi-backend`, `sisi-mobile` y `sisi-admin`.
- **Reglas de alerta** por **email** al equipo (canal aprobado; acción "Send a notification to Team"):
  - Backend, "A new issue is created" con el tag `alert` (outbox, colas, OTP y push del `OpsMonitor`);
  - Backend, "Number of events > 10 in 5 min" (5xx);
  - Mobile y admin: issues nuevas.
- **Crons:** los monitores `billing-cron` y `worker-heartbeat` se crean solos con el primer check-in. Configurar sus avisos (Crons → monitor → Alerts).

**Monitor externo de `/health`**, opciones:

| Opción | Costo | Frecuencia | Avisa por |
| --- | --- | --- | --- |
| UptimeRobot (propuesta, por email) | Gratis | 5 min | Email, Slack, webhook |
| Better Stack | Gratis | 3 min; 30 s pago | Email, Slack, página de estado |
| Sentry Uptime | En el plan de Sentry | 1 min | Las mismas reglas de Sentry |

**Render:** Account → Notifications → email en "Deploy failed" y "Service unhealthy" de los servicios de producción.

**Simulacro (solo staging):**
- `npm run dev:tools -- ops-drill outbox` (o `otp`, `push`); esperar la alerta (≤ 1 min más la regla); `ops-drill clear` lo deshace.
- **5xx:** `POST /admin/ops/drill-500` con la sesión del panel.
- **Worker caído:** Render → `worker-staging` → Suspend por 10 minutos (salta el latido y el outbox atascado).
- **Cron caído:** suspender `billing-cron-staging` por 2 h.

### Google Maps (llaves de producción)
- **Servidor** (`MAPS_API_KEY`): solo Geocoding API, sin referer.
- **Android:** Maps SDK for Android con el paquete (`ANDROID_APP_ID`) y los SHA-1 del certificado de Play App Signing (Play Console → Integridad de la app) y del upload key.
- **Web:** Maps JavaScript API, restringida a los dominios de producción.
- **Google Cloud → Billing → Budgets:** presupuesto mensual con alertas al 50, 90 y 100 % al email del equipo, y cuotas diarias por API (Geocoding y Maps).

### Android: upload key y Play
1. **Generar la upload key** una sola vez, fuera del repositorio, y guardarla con sus contraseñas en el gestor de contraseñas del equipo:

   ```bash
   keytool -genkey -v -keystore upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Cargarla en GitHub:
   - `ANDROID_KEYSTORE_BASE64`: el resultado de `base64 -w0 upload.jks`;
   - `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` (`upload`) y `ANDROID_KEY_PASSWORD`.
3. Actions → `mobile-release` → Run (o el tag). Descargar el artefacto: AAB y APK firmados.
4. **Play Console:**
   - crear la app con el nombre comercial;
   - activar Play App Signing;
   - Pruebas → Prueba interna → crear versión → subir el AAB;
   - agregar a los probadores por email.
5. Completar el formulario de seguridad de datos con `docs/tiendas/play-seguridad-de-datos.md` y la declaración de ubicación.

### Piloto cerrado (ADR-0052)
1. **Zona:** Panel → Catálogo → Ciudades → Zona. Pegar el GeoJSON del área (dibujado en geojson.io), probar puntos de los bordes y guardar con motivo.
2. **Números:** Panel → Configuración → Piloto: pegar los números invitados (uno por línea).
3. **Cerrar el piloto:** Configuración → Feature flags → `pilot.closed` (Santa Cruz) → encender. Con los textos v0 vigentes, en producción el seed ya lo encendió y no se puede apagar (sección siguiente).
4. **Inicio del piloto:** Parámetros → "Inicio del piloto" (AAAA-MM-DD), para las métricas del dashboard.
5. **Soporte:** Parámetros → "WhatsApp de soporte".
6. **Seguimiento:**
   - Dashboard → Piloto, una vez por semana;
   - Configuración → Piloto → Interés: exportar el CSV para medir la demanda.

### Textos v0 del piloto (ADR-0051)
Los textos de `backend/legal/` son la versión v0 del piloto cerrado (`stage: piloto-cerrado`).
1. **Revisarlos y aprobarlos:** completar o quitar los `[COMPLETAR: …]` y **borrar la primera línea** ("VERSIÓN v0 PARA TU REVISIÓN — PENDIENTE DE REVISIÓN LEGAL"). Sin esa línea, `node tools/check-legal.mjs` pasa y avisa que son textos del piloto.
2. **Mientras sean los vigentes, en producción:**
   - el seed de cada deploy enciende `pilot.closed` en la ciudad por defecto. Cargar la lista de números antes del primer deploy: con el flag encendido, solo los invitados crean cuenta;
   - la API no arranca si `pilot.closed` quedara apagado ("Producción no arranca con los textos v0 del piloto…"): encenderlo con SQL revisado o volver a correr el seed;
   - el panel responde 409 `PILOT_TEXTS_ACTIVE` si se intenta apagarlo.
3. **Abrir el piloto:** publicar los textos definitivos como `version: 2` sin `stage` (todos los aceptan de nuevo). Recién entonces se puede apagar `pilot.closed`.
4. **Un texto v0 ya publicado como final no se edita:** un cambio exige subir la versión (el seed falla si no).

### Actualización obligatoria (ADR-0054)
Si una versión de la app tiene un error grave:
1. Publicar la versión corregida en Play.
2. Panel → Parámetros → "Versión mínima (Android)" = la versión corregida.

Las apps viejas ven "Actualiza la app" en segundos.

### Retención (ADR-0050)
Apagada hasta aprobar los plazos.
1. Ver cuánto borraría:

   ```bash
   npm run dev:tools -- retention --dry-run
   ```

   (staging o local; en producción, con `RETENTION_ENABLED=true` el worker la corre una vez por día).
2. Encender: `RETENTION_ENABLED=true` en el worker de producción. Se revierte igual.

### Eliminación de cuenta (ADR-0049)
- **La persona la pide desde la app** (Perfil → Acerca de → Eliminar mi cuenta) **o en `/eliminar-cuenta`** de la app web.
- **Si tiene deuda:** ve el monto y la referencia y no puede eliminar hasta pagar. Un pago registrado lo destraba.
- **Si escribe a soporte:** indicarle esas dos vías. El panel no elimina cuentas, porque la confirmación es con el código que llega a su teléfono.


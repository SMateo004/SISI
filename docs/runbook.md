# Runbook de SISI

Operación de los ambientes. Complementa el README (desarrollo local) y los ADR.

## ⚠️ Staging no es para usuarios reales

`api-staging` usa `OTP_PROVIDER=console`: **el código de cada login se escribe en los logs de Render** (ADR-0011). Cualquiera con acceso a los logs puede entrar a cualquier cuenta de staging.

Mientras esto siga así:
- No publicar staging (app, admin ni API) a personas fuera del equipo.
- No usar números ni documentos reales de terceros en staging.
- Para abrir staging a probadores externos, primero configurar Bird en staging: `OTP_PROVIDER=bird`, `OTP_PROVIDER_KEY` y `OTP_SENDER`.

Producción no arranca con el OTP por consola: la API se niega a iniciar.

## Probar un login en staging

1. Pedir el código desde la app.
2. Render → `api-staging` → Logs → buscar `Código OTP para +591…`.

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
node dist/scripts/dev-tools.js make-admin --phone 70012345
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

Hasta el panel admin (Fase 6) se revisan por API con un usuario admin:

1. Dar rol admin: `node dist/scripts/dev-tools.js make-admin --phone 70012345`. El rol entra en el token siguiente: volver a ingresar o renovar con `POST /auth/refresh`.
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
| `STORAGE_ACCESS_KEY` / `STORAGE_SECRET_KEY` | Crear un token nuevo en R2, actualizar en Render y revocar el anterior. Las URLs firmadas vigentes (≤ 1 h) dejan de funcionar. |

## Documentos de identidad (R9.5)

- Bucket privado. Carnet y selfie viven bajo `identity/{userId}/`.
- Solo un admin obtiene enlaces, de 5 minutos: `GET /admin/workers/{userId}/documents/{documentId}/url`.
- No compartir enlaces firmados fuera del panel ni por chat.

## Incidentes rápidos

- **Muchos 429 legítimos:** revisar `RATE_*` en Render (ADR-0010). Los contadores están en Redis con prefijo `rl:`; borrar una clave libera ese límite.
- **Bird caído o rechazando:** la API responde 503 `OTP_SEND_FAILED` y el detalle queda en el log (`BirdOtpProvider`). Revisar el saldo y los destinos habilitados en Bird.
- **Fallan las subidas en web:** revisar el CORS del bucket R2 (deben estar los dominios de Vercel).

## Disputas, reportes y mensajes retenidos (Fase 4)

Hasta la consola de la Fase 6, con un usuario admin (ver arriba cómo darle el rol):

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

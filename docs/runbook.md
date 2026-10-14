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
```

En Windows, si el argumento lleva paréntesis u otros caracteres especiales, usar `node dist/scripts/dev-tools.js …` directamente: `npm run` en Windows pasa los argumentos por `cmd` y les agrega `^`.

**Categorías:** hasta la Fase 2 no hay seed de categorías. Sin al menos una categoría activa nadie puede enviar la solicitud de upgrade. En staging, crear una de prueba con `create-category`.

## Secretos y rotación

| Variable | Efecto de rotarla |
| --- | --- |
| `JWT_SECRET` | Invalida los tokens de acceso vigentes (máx. 15 min) y los OTP pendientes. |
| `JWT_REFRESH_SECRET` | Cierra todas las sesiones: todos vuelven a ingresar con su número. |
| `OTP_PROVIDER_KEY` | Rotar en Bird y actualizar en Render; no afecta las sesiones. |
| `STORAGE_ACCESS_KEY` / `STORAGE_SECRET_KEY` | Crear un token nuevo en R2, actualizar en Render y revocar el anterior. Las URLs firmadas vigentes (≤ 1 h) dejan de funcionar. |

## Documentos de identidad (R9.5)

- Bucket privado. Carnet y selfie viven bajo `identity/{userId}/`.
- Solo un admin obtiene enlaces, de 5 minutos: `GET /admin/workers/{userId}/documents/{documentId}/url`.
- No compartir enlaces firmados fuera del panel ni por chat.

## Incidentes rápidos

- **Muchos 429 legítimos:** revisar `RATE_*` en Render (ADR-0010). Los contadores están en Redis con prefijo `rl:`; borrar una clave libera ese límite.
- **Bird caído o rechazando:** la API responde 503 `OTP_SEND_FAILED` y el detalle queda en el log (`BirdOtpProvider`). Revisar el saldo y los destinos habilitados en Bird.
- **Fallan las subidas en web:** revisar el CORS del bucket R2 (deben estar los dominios de Vercel).

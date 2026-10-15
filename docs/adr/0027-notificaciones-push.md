# ADR-0027: Notificaciones y push (FCM)

- Estado: aceptada
- Fecha: 2026-10-15
- Fase: 3

## Contexto
El trabajador debe enterarse de una solicitud cercana aunque no tenga la app en pantalla, y el empleador, de las ofertas y del resultado. El doc 02 fija Firebase Cloud Messaging y la tabla `notifications`. Desde la Fase 2 quedó pendiente avisar al empleador cuando el admin libera o rechaza una solicitud retenida.

## Decisión
- **`PushProvider`** con dos implementaciones:
  - `FcmPushProvider`: firebase-admin 14.5.0, credencial en `FIREBASE_SERVICE_ACCOUNT` (JSON o base64). Envía con `sendEach`, un mensaje por token; el multicast por token está obsoleto en la v14;
  - `FakePushProvider` para local y tests (guarda lo enviado; los tokens `invalid…` simulan uno vencido).
  - `PUSH_PROVIDER=fake|fcm`. Production exige `fcm` al arrancar, como el OTP (ADR-0011). Staging usa `fake` hasta configurar Firebase.
- **Tabla `notifications`:** `user_id`, `city_id`, `type`, `title`, `body`, `payload` (con `route`, la pantalla a abrir), `dedupe_key` única, `push_sent_at`, `read_at`.
  - `NotificationsService.notify` guarda el aviso y lo envía por push.
  - Es idempotente: `dedupe_key` = evento del outbox + destinatario. Un job reintentado no duplica la fila ni reenvía un push ya enviado.
- **Tabla `device_tokens`:** token único y plataforma (`android`, `web`, `ios`).
  - `POST /me/devices` (si el token era de otra cuenta, pasa a la que lo registra) y `DELETE /me/devices/:token` (al cerrar sesión).
  - Los tokens que FCM declara inválidos (`registration-token-not-registered`, `invalid-registration-token`) se borran al enviar.
- **Bandeja:** `GET /me/notifications` (paginado) y `POST /me/notifications/:id/read`.
- **Textos en español de Bolivia** en `notification-texts.ts`, con montos en "Bs 150,00".
- **Los avisos se envían desde el worker,** a partir de eventos del outbox (ADR-0022). Cierra el pendiente de la Fase 2: `request.released` y `request.rejected` avisan al empleador.
- **App (Android y web):** `firebase_core` 4.15.0 y `firebase_messaging` 16.7.0, inicializados con `FirebaseOptions` desde `--dart-define`.
  - `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_SENDER_ID`, `FIREBASE_PROJECT_ID` y, en web, `FIREBASE_VAPID_KEY`.
  - No se versiona `google-services.json` ni `firebase_options.dart`. Sin valores, el push queda apagado, como Maps sin llave.
  - Con sesión, pide permiso y registra el token (`POST /me/devices`) y sus rotaciones. Al cerrar sesión lo da de baja antes de borrar los tokens.
  - Tocar un aviso abre `payload.route`, solo si es una ruta de avisos de la app (`/solicitudes/…`, `/trabajo/solicitudes/…`, `/trabajos/…`). Con la app abierta se muestra un SnackBar con "Ver".
  - **Android:** canal `sisi_avisos` creado en `MainActivity` y declarado como canal por defecto de FCM.
  - **Web:** `firebase-messaging-sw.js` (SDK compat 12.19.0 desde gstatic) importa `firebase-config.js`, que escribe el workflow deploy-web con la configuración pública del ambiente.
  - iOS queda pendiente.
- **Scripts de instalación de las dependencias de firebase-admin** (`@firebase/util`, `protobufjs`) denegados en `allowScripts`: no se necesitan en el servidor.

## Consecuencias
- Los avisos quedan guardados aunque el push falle o el usuario no tenga dispositivos.
- iOS queda pendiente hasta tener la cuenta de Apple (APNs en Firebase).
- La bandeja de avisos en la app y las preferencias (silenciar tipos) quedan para fases siguientes.

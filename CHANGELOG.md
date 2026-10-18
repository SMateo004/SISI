# Changelog

Formato: [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/). Versionado semántico ([ADR-0046](docs/adr/0046-produccion-desde-main-con-aprobacion.md)):
- la versión es una sola para backend, mobile y admin (`node tools/bump-version.mjs X.Y.Z`);
- cada release a producción es un tag `vX.Y.Z` sobre `main`.

## [Sin publicar]

## [0.9.0] — piloto cerrado en Santa Cruz (Fase 7)
Primera versión para producción.

### Agregado
- **Producción:** arranque estricto con `APP_ENV=production`, `GET /version`, despliegue solo desde `main` con aprobación y migraciones que expanden y luego contraen.
- **Seguridad:**
  - headers de seguridad y origen verificado en el socket;
  - prueba de IDOR en todas las rutas con id;
  - límites por usuario en reportes, subidas y dispositivos;
  - datos personales redactados en logs y Sentry.
- **Observabilidad:**
  - Sentry en api, worker y cron;
  - logs JSON con `requestId` de punta a punta;
  - alertas de outbox, colas, OTP, push y cron, con su simulacro.
- **Datos:** eliminación de cuenta por anonimización (app y página web), retención con limpieza (apagada hasta aprobar los plazos), y textos legales con versión y aceptación.
- **Piloto:** lista de teléfonos permitidos, "Pronto en tu zona" con registro de interés, zonas editables, soporte por WhatsApp y métricas del piloto.
- **Apps:** "Acerca de", actualización obligatoria por versión mínima, explicaciones antes de pedir permisos, firma de Android y configuración de iOS.

### Corregido
- Un socket desconectado durante el handshake dejaba vivo el temporizador de vencimiento del token.

## [0.6.0] — panel de administración (Fase 6)
### Agregado
- **Panel web:**
  - sesión propia con cookie httpOnly;
  - permisos por área y auditoría append-only;
  - pantallas: verificaciones, moderación (retenidas, chat, reportes, disputas y términos), cobros (periodos, vencidos, comprobantes, pagos, ajustes, QR y CSV), usuarios, catálogo, parámetros, flags y auditoría.
- **Datos:** historial de ofertas (`offer_events`) y parámetros de negocio en `app_settings`.
- **Contadores en vivo:** colas del panel por socket.

### Corregido
- **Avisos:** recordatorio de calificar repetido.
- **Tiempo real:** canal de Socket.IO compartido entre ambientes.
- **Fechas:** fechas sin hora corridas un día.

## [0.5.0] — cobros (Fase 5)
### Agregado
- Ledger inmutable y periodos semanales en la zona de la ciudad, con referencia de pago.
- Cron horario, tope y bloqueo por deuda.
- Pagos y ajustes con idempotencia, comprobantes y QR.
- Pantalla de ganancias.

## [0.4.0] — trabajo (Fase 4)
### Agregado
- Ciclo del trabajo con autoconfirmación y disputa.
- Chat moderado con presencia.
- Calificaciones ciegas.
- Reportes con suspensión.
- Avisos push y bandeja de avisos.

## [0.3.0] — matching y ofertas (Fase 3)
### Agregado
- Ubicación en vivo y matching por anillos.
- Ofertas y contraofertas en tiempo real.
- Outbox transaccional con BullMQ.

## [0.2.0] — solicitudes (Fase 2)
### Agregado
- Categorías por ciudad.
- Solicitudes con fotos y mapa.
- Moderación de texto con retención para revisión.

## [0.1.0] — cuentas (Fases 0 y 1)
### Agregado
- **Base:** monorepo, infraestructura local, CI y `/health`.
- **Cuentas:** login con OTP y JWT con rotación, perfil, cambio de modo y solicitud de trabajador con documentos.

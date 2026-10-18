# ADR-0055: Ingreso al panel con una cuenta única y app autenticadora

- Estado: aceptada
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Hasta ahora se entraba al panel con el teléfono de una persona y el código por SMS (ADR-0040). Además, esa cuenta tenía que tener `role=admin`. Por decisión del dueño del producto (2026-10-18), el panel no debe pedir un número ni estar atado a un usuario de la app: hay un único usuario "admin" que entra con un código.

## Decisión
- **Una sola cuenta del panel**, sin persona ni teléfono:
  - es una fila de `users` con `phone = 'panel:admin'` (no E.164: nunca recibe un SMS ni entra a la app), `role = admin` y nombre "Administrador";
  - se crea en el primer ingreso;
  - es el actor de la auditoría (`admin_audit_log`);
  - la restricción `users_phone_e164_check` solo admite ese valor con rol admin (no puede perder el rol);
  - no aparece en la lista de usuarios del panel.
- **Ingreso:** `POST /auth/admin/login {username, code}`.
  - **Usuario:** `ADMIN_USERNAME`, por defecto `admin`; no distingue mayúsculas.
  - **Código:** los 6 dígitos de una app autenticadora (TOTP, RFC 6238: HMAC-SHA1, cada 30 s; Google Authenticator, Microsoft Authenticator, Authy).
  - **Clave:** la clave base32 vive solo en el ambiente (`ADMIN_TOTP_SECRET`). La implementación es propia, con `node:crypto`, sin dependencias.
  - **Reloj corrido:** se acepta un paso de 30 s antes y uno después.
  - **Un código sirve una sola vez** (Redis, `admin:totp:used:<paso>`): 401 `ADMIN_CODE_USED`.
  - **Usuario o código incorrecto:** 401 `ADMIN_LOGIN_INVALID`, el mismo mensaje en los dos casos.
  - **Límites:**
    - el de siempre por IP (`otpVerifyIp`);
    - un tope global, sumando todas las IP, de `RATE_ADMIN_LOGIN_PER_15MIN` = 20 intentos cada 15 min (`RateLimitStore`, ADR-0010), porque hay una sola cuenta.
  - **Sin clave configurada:** 503 `ADMIN_LOGIN_NOT_CONFIGURED`.
- **La sesión no cambia** (ADR-0040): acceso de 10 min en memoria, refresh en cookie httpOnly, 8 h como máximo, `aud=admin`, CSRF y permisos por área.
- **Se elimina el ingreso por teléfono** (`POST /auth/admin/otp/verify`). `dev-tools make-admin` se reemplaza por `dev-tools admin-totp`, que genera una clave nueva y el enlace `otpauth://` para la app.
- **Producción no arranca sin `ADMIN_TOTP_SECRET`.** Esto reemplaza el procedimiento del "primer admin por SQL" que estaba propuesto.

## Consecuencias
- **Sin SMS y sin depender de Bird:** el panel funciona aunque el proveedor de SMS falle. Si alguien ve un código, a los 30 s ya no sirve.
- **La auditoría registra "Administrador", no qué persona actuó.** Es aceptado para un equipo chico. Si se necesita, más adelante: una cuenta por persona.
- **Compartir el acceso** es compartir la clave para la app autenticadora.
- **Quitarle el acceso a alguien** exige una clave nueva (`dev-tools admin-totp`), cambiarla en Render y volver a cargarla en la app de quienes siguen.
- **Bloqueo por abuso:** 20 intentos fallidos en 15 min bloquean el ingreso para todos durante ese rato. Se prefiere eso a dejar adivinar códigos.
- **`assertNotSelf` sigue protegiendo** que el actor no se revise a sí mismo. Con la cuenta del panel nunca coincide con un usuario de la app.
- **Las pruebas e2e** usan una clave fija de prueba (`test/e2e-env.ts`) y calculan el código.

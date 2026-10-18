# ADR-0009: Autenticación por teléfono, OTP y JWT con rotación

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
R1.1 identifica cada cuenta por su teléfono. El doc 02 pide OTP por SMS/WhatsApp y JWT de acceso + refresh. Restricciones: NestJS 12 en ESM, sin dependencias con binarios nativos (npm 11 bloquea scripts de instalación).

## Decisión
**Teléfono.** `libphonenumber-js/max` normaliza a E.164 con +591 por defecto y exige celular. Solo se aceptan los prefijos de `PHONE_ALLOWED_COUNTRY_CODES` (MVP: 591). La BD tiene `UNIQUE(phone)` y un `CHECK` de formato E.164.

**OTP.**
- 6 dígitos con `crypto.randomInt`.
- En Redis (`otp:{sha256(teléfono)}`) se guarda solo `HMAC-SHA256(teléfono:código)` y el contador de intentos. La clave del HMAC se deriva con HKDF de `JWT_SECRET` (info `otp-hmac-v1`), así que un volcado de Redis no permite probar los 10⁶ códigos sin el secreto.
- Vence a los 300 s. La comparación y el conteo de intentos se hacen en un script Lua atómico; al 5.º fallo el código se borra.
- Un código nuevo reemplaza al anterior.
- Mensajes genéricos: "Código incorrecto o vencido." Pedir un código responde igual exista o no la cuenta.

**Tokens.**
- Acceso: JWT HS256 de 15 min con `{sub, role, typ:'access'}`, firmado con `JWT_SECRET`.
- Refresh: JWT de 30 días con `{sub, fam, jti, typ:'refresh'}`, firmado con `JWT_REFRESH_SECRET`. En `refresh_tokens` se guarda `sha256(token)`, nunca el token.
- Rotación en cada uso, dentro de una transacción: `updateMany … where used_at IS NULL` y luego se crea el reemplazo en la misma familia.
- Si llega un refresh ya usado (o se pierde la carrera contra otro request), se revoca **toda la familia** (posible robo).
- Logout revoca la familia y es idempotente.

**Guards.** Uso un guard propio con `@nestjs/jwt` 12 en lugar de passport (menos piezas, ESM sin fricción):
- `JwtAuthGuard` global (APP_GUARD) protege todo salvo `@Public()`: `/health`, `/auth/*`. Swagger se sirve fuera del pipeline de Nest.
- `RolesGuard` aplica `@Roles('admin')`.

**Hash.** Todo con `node:crypto`; se descartan bcrypt y argon2 (binarios nativos). El refresh tiene alta entropía, así que SHA-256 basta; el OTP de baja entropía va con HMAC y un secreto del servidor.

## Consecuencias
- El rol viaja en el token: un cambio de rol se aplica en el siguiente refresh (≤ 15 min).
- Rotar `JWT_SECRET` invalida los accesos vigentes y los OTP pendientes. Rotar `JWT_REFRESH_SECRET` cierra todas las sesiones.
- La app debe hacer un solo refresh a la vez (si no, la segunda rotación parece una reutilización): lo resuelve el interceptor de dio (ver ADR-0014).

## Actualización (Fase 6)
El panel admin tiene una sesión propia (ADR-0040): `aud=admin`, acceso de 10 min, máximo de 8 h desde el login, y refresh solo en una cookie httpOnly. Las sesiones de la app y del panel no se cruzan.

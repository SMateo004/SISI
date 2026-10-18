# ADR-0010: Rate limiting en Redis reutilizable

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
Los límites deben funcionar con varias instancias de la API (contadores en Redis) y aplicarse por IP y por teléfono. `@nest-lab/throttler-storage-redis` declara compatibilidad solo hasta NestJS 11. Las fases siguientes (solicitudes, ofertas, chat, reportes) también necesitarán límites.

## Decisión
Una sola pieza central, `RateLimitStore` (`backend/src/common/rate-limit/`), sobre la conexión Redis compartida, con dos scripts Lua atómicos:
- `consume(reglas[])`: ventanas fijas. Revisa todas las reglas y **solo si ninguna está agotada** incrementa todas; un intento rechazado no gasta cupo de las demás. Devuelve el tiempo de espera.
- `hitWithBlock(...)`: semántica de `@nestjs/throttler` (contador + clave de bloqueo).

Encima de ella hay tres formas de uso:
1. **Límite global por IP** para toda la API: `@nestjs/throttler` 6.7 (compatible con NestJS 12) con `RedisThrottlerStorage` propio. Por defecto 300 peticiones por minuto; `/health` queda excluido.
2. **Políticas por endpoint** con `@RateLimit('politica')` y `RateLimitGuard`. Cada política toma su límite de una variable de configuración (`rate-limit.policies.ts`).
3. **Claves de dominio** (p. ej. teléfono) inyectando `RateLimitStore` en el servicio (`OtpService`).

Todo 429 sale con `{code:'RATE_LIMITED', message, retryAfterSec}` en español y el header `Retry-After` (lo agrega `RateLimitedFilter`). `trust proxy` está activo para tomar la IP real detrás de Render. Las claves de Redis llevan el prefijo `rl:`.

Para agregar un límite en una fase nueva: variable en `env.schema.ts`, política en `rate-limit.policies.ts` y `@RateLimit()` en el endpoint.

## Consecuencias
Ventanas fijas: permiten hasta el doble en el borde entre ventanas. Es aceptable para estos usos; si hiciera falta precisión se cambia el Lua a ventana deslizante sin tocar a quienes lo usan. Los valores iniciales son propuesta (docs/pendientes.md).

## Actualización (Fase 6)
Las rutas del panel tienen límites **por admin** (`AdminGuard`, ADR-0040): lecturas, escrituras y exportaciones. Detrás del proxy de Vercel todos los admins comparten IP, así que un límite por IP no serviría.

## Actualización (Fase 7)
Políticas **por usuario** con `@RateLimit` (`per: 'user'`), aplicadas por `UserRateLimitGuard` después de la autenticación:
- reportes: 10/h;
- URLs de subida: 60/h;
- registros de dispositivo: 20/h;
- eliminación de cuenta: 5/día;
- interés del piloto: 10/h por IP.

Ver ADR-0047. Para la prueba de carga, los límites por IP se suben temporalmente en staging (ADR-0053).

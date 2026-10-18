# ADR-0040: Seguridad del panel admin

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
El panel admin es una app web (Flutter web en Vercel) que puede ver documentos de identidad, mover dinero (pagos y ajustes) y suspender cuentas. Para la app, ADR-0009 dio un acceso de 15 min y un refresh de 30 días que el cliente guarda. En el navegador, un refresh largo en `localStorage` queda expuesto a cualquier XSS, y un token del panel no debería servir para actuar como usuario en la app (ni al revés).

## Decisión

### Sesión aparte
- `POST /auth/admin/otp/verify`: el código se pide con el mismo `/auth/otp/request`. Solo entran cuentas con `role=admin` (403 `ADMIN_ONLY`); este login no crea cuentas.
- **Duración:**
  - acceso de **10 min** (`JWT_ADMIN_ACCESS_TTL_SEC=600`);
  - la sesión dura como máximo **8 h desde el login** (`JWT_ADMIN_SESSION_MAX_SEC=28800`). Rotar el refresh no la extiende, y el acceso nunca dura más que lo que le queda a la sesión.
- **Audiencia:** el token de acceso y el refresh llevan `aud=admin`.
  - `RolesGuard`: una ruta `@Roles('admin')` exige `aud=admin` (403 `ADMIN_SESSION_REQUIRED`), y un token `aud=admin` solo entra a esas rutas (403 `ADMIN_SESSION_SCOPE`).
  - Un refresh de la app no rota como admin ni al revés.
  - Los tokens anteriores, sin `aud`, son de la app.
- Si la cuenta pierde el rol, el siguiente refresh revoca la familia.

### Refresh en cookie httpOnly
- `Set-Cookie: sisi_admin_rt=…; HttpOnly; Secure; SameSite=Strict; Path=/api/auth/admin` (`ADMIN_COOKIE_PATH`). El cuerpo nunca trae el refresh.
- **Primera parte:** el panel llama a la API por su propio origen, con un rewrite de Vercel `/api/*` → `API_URL` (`apps/admin/tool/vercel-json.mjs`, generado en `deploy-web`). Así la cookie es de primera parte y `Strict` no depende de las cookies de terceros, que los navegadores bloquean.
- **Socket:** va directo a Render con el token de acceso en memoria (Vercel no proxea websockets). Por eso las URLs del admin siguen en `CORS_ORIGINS`.
- **Token de acceso:** el panel lo guarda solo en memoria, nunca en `localStorage`. Al recargar pide `POST /api/auth/admin/refresh`.
- **CSRF:** `SameSite=Strict` y el header obligatorio `X-SISI-Admin: 1` en refresh y logout (403 `CSRF_HEADER_REQUIRED`). Un formulario de otro sitio no puede poner headers.
- **Sin dependencias:** la cookie se lee con un parser propio (`admin-cookie.ts`) y se escribe con `res.cookie` de Express.
- **Local:** el admin usa el proxy de desarrollo de `flutter run` (`web_dev_config.yaml`) con el mismo prefijo `/api`.

### Permisos por área
- `@Admin('<permiso>')` reemplaza a `@Roles('admin')` en todo controlador `/admin`. Los permisos son `verificaciones`, `moderacion`, `cobros`, `catalogo`, `configuracion`, `usuarios` y `auditoria`.
- `AdminGuard` (global, después de `RolesGuard`) verifica el permiso con `PERMISSIONS_BY_ROLE`. En el MVP, `admin` tiene todos.
- Un rol de moderador o de finanzas solo agrega su valor al enum `user_role` y una fila al mapa.
- Una ruta `@Roles('admin')` sin permiso declarado se rechaza (falla cerrada).
- El e2e `admin-routes` recorre todas las rutas `/admin` registradas en Nest:
  - todas declaran `admin` y un permiso válido;
  - 401 sin token;
  - 403 con un usuario normal;
  - 403 `ADMIN_SESSION_REQUIRED` con el token de la app de un admin.

### Límites del panel (ADR-0010)
- **Por admin, no por IP:** detrás del proxy de Vercel todos los admins comparten IP.
  - 300 lecturas por minuto (`RATE_ADMIN_READ_PER_MIN`);
  - 60 escrituras por minuto (`RATE_ADMIN_WRITE_PER_MIN`);
  - 10 exportaciones CSV por hora (`RATE_ADMIN_EXPORT_PER_HOUR`, `@AdminExport()`).
- El login del panel usa las políticas por IP de siempre (`otpVerifyIp`, `authIp`). Con el proxy, esa IP es la de Vercel: los intentos de todos los admins suman juntos. Para un equipo chico es aceptable (y más estricto, no menos).

### Documentos de identidad
- Solo por URL firmada de 5 minutos.
- El panel los muestra dentro de la página, sin botón de descarga ni caché.
- No se puede impedir una captura de pantalla; eso queda del lado de las normas internas.

## Consecuencias
- Un XSS en el panel puede usar el token de acceso mientras la página está abierta, pero no puede leer el refresh ni llevárselo. Lo limita la vida de 10 min del acceso y de 8 h de la sesión.
- Los e2e usan `loginAsAdmin` (token `aud=admin`, más `appAccessToken` para las rutas de usuario de la misma cuenta).
- **Auditoría:** con `trust proxy` en 1, `req.ip` de un request del panel es la IP de Vercel. La auditoría guarda también el `X-Forwarded-For` recibido como dato informativo (no confiable).
- **Pendientes:** roles de moderador y finanzas, y la IP real del cliente detrás del proxy.

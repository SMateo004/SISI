# ADR-0014: Almacenamiento de tokens en la app (Android, iOS y web)

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
La app guarda el par de tokens (ADR-0009) para mantener la sesión. Debe funcionar en Android, iOS y web con una sola librería.

## Decisión
- `flutter_secure_storage` 11.2 detrás de la interfaz `TokenStorage` (`lib/core/auth/token_storage.dart`), con una implementación en memoria para los tests.
  - **Android:** almacenamiento cifrado con claves del Android Keystore.
  - **iOS:** Keychain.
  - **Web:** el valor se cifra con AES-GCM (WebCrypto) y se guarda en `localStorage`. **La clave AES también se guarda en `localStorage`** (exportada en base64), lo verifiqué en el código de `flutter_secure_storage_web` 2.1.1. En web el cifrado **no** protege contra un script que corra en la página.
- Interceptor de dio (`AuthInterceptor`):
  - agrega el token de acceso;
  - ante un 401 hace **un solo** refresh aunque fallen varias peticiones a la vez (el refresh rota y reutilizarlo revocaría la familia);
  - reintenta las peticiones con el token nuevo;
  - si el servidor rechaza el refresh, cierra la sesión. Sin red, la sesión se mantiene.

## Riesgo en web
Un XSS en `app.` o `admin.` podría leer el refresh token y mantener la sesión de la víctima hasta 30 días. Mitigaciones actuales:
- acceso corto (15 min);
- rotación con detección de reutilización: si atacante y víctima refrescan, se revoca la familia y ambos quedan fuera;
- logout que revoca en el servidor;
- Flutter web no inyecta HTML de usuarios.

Pendiente antes de abrir la web a usuarios reales (docs/pendientes.md): mover el refresh de la versión web a una cookie `httpOnly; Secure; SameSite=Strict` emitida por la API (y solo el acceso en memoria), y una CSP estricta en Vercel. Las apps móviles no cambian.

## Consecuencias
El riesgo está acotado y documentado. El panel admin, que maneja documentos de identidad, debe tener esa protección antes de la Fase 6.

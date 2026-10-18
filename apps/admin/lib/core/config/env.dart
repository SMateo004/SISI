/// Configuración por ambiente inyectada en tiempo de compilación con `--dart-define`.
///
/// Staging y producción: `API_URL=/api` (el proxy del proyecto de Vercel lleva `/api/*` a la
/// API, así la cookie del refresh es de primera parte, ADR-0040) y `SOCKET_URL` con la URL
/// de Render (Vercel no proxea websockets).
///
/// Local: `--dart-define=API_URL=http://localhost:3000` y, en el backend,
/// `ADMIN_COOKIE_PATH=/auth/admin` (localhost:8080 y :3000 son el mismo sitio para la cookie).
abstract final class Env {
  /// URL base de la API REST (sin barra final). Si empieza con "/", es relativa al panel.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: '/api',
  );

  /// URL del servidor Socket.IO.
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// `local`, `staging` o `production`.
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'local',
  );

  static bool get isProduction => appEnv == 'production';

  /// Versión del panel (la pone deploy-web) y DSN de Sentry (ADR-0048). Vacíos en local.
  static const String appVersion = String.fromEnvironment('APP_VERSION');
  static const String appBuild = String.fromEnvironment('APP_BUILD');
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// [apiUrl] absoluta: una ruta relativa se resuelve contra el origen del panel.
  static String resolvedApiUrl([Uri? base]) {
    if (!apiUrl.startsWith('/')) return apiUrl;
    final origin = (base ?? Uri.base).replace(
      path: apiUrl,
      query: null,
      fragment: null,
    );
    return origin.toString().replaceFirst(RegExp(r'/$'), '');
  }
}

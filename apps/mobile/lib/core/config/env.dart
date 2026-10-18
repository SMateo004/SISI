/// Configuración por ambiente inyectada en tiempo de compilación con `--dart-define`.
///
/// Ejemplo:
/// `flutter run --dart-define=API_URL=https://api.ejemplo.bo --dart-define=APP_ENV=staging`
abstract final class Env {
  /// URL base de la API REST (sin barra final).
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// URL del servidor Socket.IO (Fase 3).
  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// `local`, `staging` o `production`.
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'local',
  );

  /// Llave de Google Maps de la APP (distinta de la del backend), restringida por
  /// plataforma o dominio (ADR-0021). Vacía = mapa sin proveedor (PlaceholderMapView).
  static const String mapsApiKey = String.fromEnvironment('MAPS_API_KEY');

  /// Firebase (push, ADR-0027). Cada build lleva los valores de su plataforma (web o
  /// Android) y ambiente. Son configuración pública, no secretos. Vacío = push apagado.
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );
  static const String firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const String firebaseSenderId = String.fromEnvironment(
    'FIREBASE_SENDER_ID',
  );
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  /// Llave VAPID de Web Push (solo web).
  static const String firebaseVapidKey = String.fromEnvironment(
    'FIREBASE_VAPID_KEY',
  );

  static bool get pushConfigured =>
      firebaseApiKey.isNotEmpty &&
      firebaseAppId.isNotEmpty &&
      firebaseSenderId.isNotEmpty &&
      firebaseProjectId.isNotEmpty;

  static bool get isProduction => appEnv == 'production';

  /// Versión de la app (X.Y.Z) y número de build, que pone el workflow de release desde el
  /// pubspec (ADR-0054). Vacía en desarrollo: la API no le aplica la versión mínima.
  static const String appVersion = String.fromEnvironment('APP_VERSION');
  static const String appBuild = String.fromEnvironment('APP_BUILD');

  /// DSN de Sentry de la app (ADR-0048). Vacío = sin reporte de errores.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
}

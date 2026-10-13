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

  static bool get isProduction => appEnv == 'production';
}

import 'package:dio/dio.dart';

import '../config/env.dart';
import 'client_app_repository.dart';

/// Envía la plataforma y la versión en cada petición, y avisa a la puerta de la app cuando
/// la API exige actualizar (426) o aceptar los textos legales (403) (ADR-0051, ADR-0054).
class AppGateInterceptor extends Interceptor {
  AppGateInterceptor({required this.onUpgrade, required this.onLegal});

  final void Function(String? storeUrl) onUpgrade;
  final void Function(List<String> pending) onLegal;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Env.appVersion.isNotEmpty) {
      options.headers['X-App-Platform'] = appPlatform();
      options.headers['X-App-Version'] = Env.appVersion;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    final code = data is Map ? data['code'] : null;
    if (err.response?.statusCode == 426 && code == 'APP_UPGRADE_REQUIRED') {
      onUpgrade(data is Map ? data['storeUrl'] as String? : null);
    } else if (err.response?.statusCode == 403 &&
        code == 'LEGAL_ACCEPTANCE_REQUIRED') {
      final pending = data is Map ? data['pending'] : null;
      onLegal([for (final p in pending is List ? pending : const []) '$p']);
    }
    handler.next(err);
  }
}

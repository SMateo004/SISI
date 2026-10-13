import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';

/// Resultado de GET /health.
class HealthStatus {
  const HealthStatus({
    required this.ok,
    required this.database,
    required this.postgis,
    required this.redis,
    this.postgisVersion,
  });

  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    final checks = (json['checks'] as Map?)?.cast<String, dynamic>() ?? {};
    bool isUp(String key) => (checks[key] as Map?)?['status'] == 'up';
    return HealthStatus(
      ok: json['status'] == 'ok',
      database: isUp('database'),
      postgis: isUp('postgis'),
      redis: isUp('redis'),
      postgisVersion: (checks['postgis'] as Map?)?['version'] as String?,
    );
  }

  final bool ok;
  final bool database;
  final bool postgis;
  final bool redis;
  final String? postgisVersion;
}

class HealthRepository {
  HealthRepository(this._dio);

  final Dio _dio;

  /// Devuelve el estado aunque la API responda 503 (servicio degradado).
  /// Lanza [DioException] si no hay conexión con la API.
  Future<HealthStatus> fetch() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/health');
      return HealthStatus.fromJson(res.data ?? const {});
    } on DioException catch (e) {
      final data = e.response?.data;
      if (e.response?.statusCode == 503 && data is Map<String, dynamic>) {
        return HealthStatus.fromJson(data);
      }
      rethrow;
    }
  }
}

final healthRepositoryProvider = Provider<HealthRepository>(
  (ref) => HealthRepository(ref.watch(dioProvider)),
);

final healthStatusProvider = FutureProvider.autoDispose<HealthStatus>(
  (ref) => ref.watch(healthRepositoryProvider).fetch(),
  // El usuario reintenta con el botón; sin reintentos automáticos.
  retry: (retryCount, error) => null,
);

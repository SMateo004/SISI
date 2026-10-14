import 'package:dio/dio.dart';

/// Error de la API con el formato `{statusCode, code, message}` (mensaje en español).
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.code = 'UNKNOWN',
    this.statusCode,
    this.extra = const {},
  });

  /// Traduce cualquier error de dio a un mensaje que se puede mostrar al usuario.
  factory ApiException.from(Object error) {
    if (error is ApiException) return error;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] is String) {
        final map = data.cast<String, dynamic>();
        return ApiException(
          message: map['message'] as String,
          code: map['code'] is String ? map['code'] as String : 'UNKNOWN',
          statusCode: error.response?.statusCode,
          extra: map,
        );
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const ApiException(
            code: 'TIMEOUT',
            message: 'El servidor tardó demasiado. Intenta de nuevo.',
          );
        case DioExceptionType.connectionError:
          return const ApiException(
            code: 'NO_CONNECTION',
            message: 'Sin conexión con el servidor. Revisa tu internet.',
          );
        default:
          break;
      }
    }
    return const ApiException(
      message: 'Ocurrió un error inesperado. Intenta de nuevo.',
    );
  }

  final String message;
  final String code;
  final int? statusCode;
  final Map<String, dynamic> extra;

  @override
  String toString() => 'ApiException($code, $statusCode): $message';
}

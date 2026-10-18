import 'package:dio/dio.dart';

/// Error de la API para mostrar al admin: el `message` en español de ApiErrorBody y su
/// `code` (p. ej. SELF_REVIEW_FORBIDDEN).
class ApiError implements Exception {
  const ApiError(this.message, {this.code, this.status});

  final String message;
  final String? code;
  final int? status;

  static ApiError from(Object error) {
    if (error is ApiError) return error;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message'];
        return ApiError(
          message is String
              ? message
              : message is List
              ? message.join(' ')
              : 'Algo salió mal. Intenta de nuevo.',
          code: data['code'] is String ? data['code'] as String : null,
          status: error.response?.statusCode,
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return const ApiError(
          'No hay conexión con el servidor.',
          code: 'NETWORK',
        );
      }
      return ApiError(
        'Algo salió mal. Intenta de nuevo.',
        status: error.response?.statusCode,
      );
    }
    return const ApiError('Algo salió mal. Intenta de nuevo.');
  }

  @override
  String toString() => message;
}

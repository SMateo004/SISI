import 'package:dio/dio.dart';

import '../http/api_exception.dart';
import 'picked_image.dart';

/// Sube una foto con el flujo de la API: pide la URL prefirmada, hace PUT directo al
/// almacenamiento y devuelve la clave para confirmar (ADR-0012).
Future<String> uploadWithPresignedUrl({
  required Dio api,
  required Dio storage,
  required String requestPath,
  required Map<String, dynamic> requestBody,
  required PickedImage image,
}) async {
  if (image.bytes.length > PickedImage.maxBytes) {
    throw const ApiException(
      code: 'UPLOAD_TOO_LARGE',
      message: 'La foto pesa más de 8 MB.',
    );
  }
  try {
    final res = await api.post<Map<String, dynamic>>(
      requestPath,
      data: {
        ...requestBody,
        'contentType': image.contentType,
        'sizeBytes': image.bytes.length,
      },
    );
    final data = res.data ?? const {};
    final headers = (data['headers'] as Map).cast<String, dynamic>();
    await storage.put<void>(
      data['uploadUrl'] as String,
      data: Stream.fromIterable([image.bytes]),
      options: Options(
        // Content-Length debe coincidir con el tamaño firmado.
        headers: {...headers, Headers.contentLengthHeader: image.bytes.length},
      ),
    );
    return data['key'] as String;
  } on DioException catch (e) {
    if (e.requestOptions.path.startsWith('http') &&
        e.response?.statusCode == 403) {
      throw const ApiException(
        code: 'UPLOAD_REJECTED',
        message: 'No se pudo subir la foto. Intenta de nuevo.',
      );
    }
    throw ApiException.from(e);
  }
}

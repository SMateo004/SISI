//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:sisi_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:sisi_api/src/model/app_config_dto.dart';

class AppApi {

  final Dio _dio;

  const AppApi(this._dio);

  /// Configuración de la app al abrirla
  /// Versión mínima por plataforma (si la instalada es menor, upgradeRequired y la tienda), WhatsApp de soporte y versiones legales vigentes.
  ///
  /// Parameters:
  /// * [platform] 
  /// * [version] - Versión instalada
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AppConfigDto] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AppConfigDto>> clientAppControllerConfig({ 
    required String platform,
    String? version,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/app/config';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'platform': platform,
      if (version != null) r'version': version,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AppConfigDto? _responseData;

    try {
final rawData = _response.data;
_responseData = rawData == null ? null : deserialize<AppConfigDto, AppConfigDto>(rawData, 'AppConfigDto', growable: true);

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AppConfigDto>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';

import '../auth/session.dart';
import '../config/env.dart';

/// Dio base: misma URL para todo, y en la web manda la cookie del refresh aunque la API
/// esté en otro puerto (desarrollo local).
Dio buildDio(String baseUrl) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['withCredentials'] = true;
        handler.next(options);
      },
    ),
  );
  return dio;
}

/// Dio sin token (login, refresh y logout del panel).
final publicDioProvider = Provider<Dio>((ref) {
  final dio = buildDio(Env.resolvedApiUrl());
  ref.onDispose(dio.close);
  return dio;
});

/// Dio con el token del panel: lo agrega a cada request y, ante un 401, renueva la
/// sesión una vez y reintenta.
final dioProvider = Provider<Dio>((ref) {
  final dio = buildDio(Env.resolvedApiUrl());
  final session = ref.read(sessionProvider.notifier);
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await session.accessToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) async {
        final retried = error.requestOptions.extra['retried'] == true;
        if (error.response?.statusCode != 401 || retried) {
          return handler.next(error);
        }
        final token = await session.accessToken(forceRefresh: true);
        if (token == null) return handler.next(error);
        final options = error.requestOptions
          ..headers['Authorization'] = 'Bearer $token'
          ..extra['retried'] = true;
        try {
          handler.resolve(await dio.fetch<dynamic>(options));
        } on DioException catch (e) {
          handler.next(e);
        }
      },
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

/// Cliente generado del contrato (ADR-0045) sobre el Dio con sesión.
final adminApiProvider = Provider<AdminApi>(
  (ref) => SisiApi(
    dio: ref.watch(dioProvider),
    interceptors: const [],
  ).getAdminApi(),
);

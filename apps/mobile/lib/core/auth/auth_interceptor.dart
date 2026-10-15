import 'dart:async';

import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Acceso a la sesión que necesita el interceptor (separado para probarlo sin Riverpod).
abstract class SessionHandle {
  AuthTokens? get tokens;
  Future<void> updateTokens(AuthTokens tokens);
  Future<void> signOut();
}

/// Agrega el token de acceso y, ante un 401, renueva la sesión una sola vez aunque
/// fallen varias peticiones a la vez (el refresh se rota y no puede usarse dos veces).
/// Si la renovación falla, cierra la sesión.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.session,
    required this.refreshDio,
    required this.retryDio,
  });

  final SessionHandle session;

  /// Dio sin este interceptor, para llamar a /auth/refresh.
  final Dio refreshDio;

  /// Dio con el que se reintenta la petición original.
  final Dio retryDio;

  Future<AuthTokens?>? _refreshing;

  static const _retriedFlag = 'sisi.retried';
  static const _publicPaths = ['/auth/', '/health'];

  bool _isPublic(RequestOptions options) =>
      _publicPaths.any(options.path.startsWith);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = session.tokens?.accessToken;
    if (token != null && !_isPublic(options)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final unauthorized = err.response?.statusCode == 401;
    if (!unauthorized ||
        _isPublic(options) ||
        options.extra[_retriedFlag] == true) {
      return handler.next(err);
    }

    final sentToken = (options.headers['Authorization'] as String?)
        ?.replaceFirst('Bearer ', '');
    final current = session.tokens;
    AuthTokens? fresh;
    if (current != null &&
        sentToken != null &&
        current.accessToken != sentToken) {
      // Otra petición ya renovó la sesión mientras esta estaba en vuelo.
      fresh = current;
    } else {
      fresh = await (_refreshing ??= _refresh().whenComplete(
        () => _refreshing = null,
      ));
    }
    if (fresh == null) return handler.next(err);

    try {
      options.headers['Authorization'] = 'Bearer ${fresh.accessToken}';
      options.extra[_retriedFlag] = true;
      handler.resolve(await retryDio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  /// Renueva la sesión ya (p. ej. antes de reconectar el socket con un token vencido).
  /// Comparte la renovación en curso si ya hay una.
  Future<AuthTokens?> refreshNow() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<AuthTokens?> _refresh() async {
    final refreshToken = session.tokens?.refreshToken;
    if (refreshToken == null) {
      await session.signOut();
      return null;
    }
    try {
      final res = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = res.data ?? const {};
      final tokens = AuthTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      await session.updateTokens(tokens);
      return tokens;
    } on DioException catch (e) {
      // Solo una respuesta del servidor invalida la sesión; sin red se mantiene.
      if (e.response != null) await session.signOut();
      return null;
    }
  }
}

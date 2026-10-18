import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_gate/app_gate.dart';
import '../app_gate/app_gate_interceptor.dart';
import '../auth/auth_interceptor.dart';
import '../auth/session_controller.dart';
import '../auth/token_storage.dart';
import '../config/env.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: Env.apiUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 20),
  headers: {'Accept': 'application/json'},
);

class _RiverpodSession implements SessionHandle {
  _RiverpodSession(this._ref);

  final Ref _ref;

  SessionController get _controller => _ref.read(sessionProvider.notifier);

  @override
  AuthTokens? get tokens => _controller.tokens;

  @override
  Future<void> updateTokens(AuthTokens tokens) =>
      _controller.updateTokens(tokens);

  @override
  Future<void> signOut() => _controller.signOut();
}

/// Cliente HTTP único hacia la API de SISI, con token y refresh automático.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(_baseOptions());
  final plain = Dio(_baseOptions());
  dio.interceptors.add(
    AuthInterceptor(
      session: _RiverpodSession(ref),
      refreshDio: plain,
      retryDio: dio,
    ),
  );
  // Versión de la app en cada petición y aviso de 426 y 403 legales (ADR-0051, ADR-0054).
  final gate = AppGateInterceptor(
    onUpgrade: (url) => ref.read(appGateProvider.notifier).upgradeRequired(url),
    onLegal: (pending) =>
        ref.read(appGateProvider.notifier).legalRequired(pending),
  );
  dio.interceptors.add(gate);
  plain.interceptors.add(gate);
  ref.onDispose(() {
    dio.close();
    plain.close();
  });
  return dio;
});

/// Dio sin base URL ni auth, para subir archivos a URLs prefirmadas del almacenamiento.
final uploadDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});

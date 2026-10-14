import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/auth/auth_interceptor.dart';
import 'package:sisi_mobile/core/auth/token_storage.dart';

class _Session implements SessionHandle {
  _Session(this.tokens);

  @override
  AuthTokens? tokens;
  bool signedOut = false;

  @override
  Future<void> updateTokens(AuthTokens tokens) async => this.tokens = tokens;

  @override
  Future<void> signOut() async {
    signedOut = true;
    tokens = null;
  }
}

/// Servidor falso: /me exige el token "nuevo"; /auth/refresh rota una sola vez.
class _FakeServer implements HttpClientAdapter {
  _FakeServer({this.refreshFails = false});

  final bool refreshFails;
  int refreshCalls = 0;
  final seenAuth = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    if (options.path == '/auth/refresh') {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 20));
      if (refreshFails) {
        return _json(401, {
          'code': 'SESSION_REUSED',
          'message': 'Sesión inválida',
        });
      }
      return _json(200, {'accessToken': 'nuevo', 'refreshToken': 'refresh-2'});
    }
    final auth = options.headers['Authorization'] as String?;
    seenAuth.add(auth);
    if (auth == 'Bearer nuevo') return _json(200, {'ok': true});
    return _json(401, {
      'code': 'TOKEN_INVALID',
      'message': 'Tu sesión venció.',
    });
  }

  ResponseBody _json(int status, Object data) => ResponseBody.fromString(
    jsonEncode(data),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );

  @override
  void close({bool force = false}) {}
}

(Dio, _Session, _FakeServer) _setup({bool refreshFails = false}) {
  final server = _FakeServer(refreshFails: refreshFails);
  final session = _Session(
    const AuthTokens(accessToken: 'viejo', refreshToken: 'refresh-1'),
  );
  final dio = Dio(BaseOptions(baseUrl: 'http://api'))
    ..httpClientAdapter = server;
  final plain = Dio(BaseOptions(baseUrl: 'http://api'))
    ..httpClientAdapter = server;
  dio.interceptors.add(
    AuthInterceptor(session: session, refreshDio: plain, retryDio: dio),
  );
  return (dio, session, server);
}

void main() {
  test(
    'agrega el token y renueva una sola vez aunque fallen varias peticiones',
    () async {
      final (dio, session, server) = _setup();
      final results = await Future.wait([
        dio.get<dynamic>('/me'),
        dio.get<dynamic>('/me/worker'),
        dio.get<dynamic>('/categories'),
      ]);
      expect(results.map((r) => r.statusCode), [200, 200, 200]);
      expect(server.refreshCalls, 1);
      expect(session.tokens?.accessToken, 'nuevo');
      expect(session.tokens?.refreshToken, 'refresh-2');
      expect(server.seenAuth.where((a) => a == 'Bearer viejo'), hasLength(3));
    },
  );

  test('si el refresh falla, cierra la sesión y propaga el 401', () async {
    final (dio, session, server) = _setup(refreshFails: true);
    await expectLater(
      dio.get<dynamic>('/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    expect(server.refreshCalls, 1);
    expect(session.signedOut, isTrue);
  });

  test('no agrega token ni renueva en endpoints de auth', () async {
    final (dio, _, server) = _setup();
    await expectLater(
      dio.post<dynamic>('/auth/otp/verify'),
      throwsA(isA<DioException>()),
    );
    expect(server.refreshCalls, 0);
    expect(server.seenAuth.single, isNull);
  });
}

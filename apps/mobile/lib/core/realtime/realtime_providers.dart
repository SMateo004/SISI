import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_interceptor.dart';
import '../auth/session_controller.dart';
import '../config/env.dart';
import '../http/api_client.dart';
import 'realtime_client.dart';
import 'socket_io_realtime_client.dart';

/// Segundos que le quedan al token de acceso (lee `exp` del JWT; no verifica la firma).
int? secondsUntilExpiry(String token, DateTime now) {
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final payload =
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))))
            as Map<String, dynamic>;
    final exp = payload['exp'];
    if (exp is! int) return null;
    return exp - now.millisecondsSinceEpoch ~/ 1000;
  } on FormatException {
    return null;
  }
}

/// Construye el cliente de tiempo real. En tests se reemplaza por uno falso.
typedef RealtimeClientFactory = RealtimeClient Function();

final realtimeClientFactoryProvider = Provider<RealtimeClientFactory>(
  (ref) =>
      () => SocketIoRealtimeClient(
        url: Env.socketUrl,
        token: ({bool forceRefresh = false}) async {
          final session = ref.read(sessionProvider.notifier);
          var tokens = session.tokens;
          if (tokens == null) return null;
          final left = secondsUntilExpiry(tokens.accessToken, DateTime.now());
          if (forceRefresh || left == null || left < 30) {
            final auth = ref
                .read(dioProvider)
                .interceptors
                .whereType<AuthInterceptor>()
                .first;
            tokens = await auth.refreshNow() ?? session.tokens;
          }
          return tokens?.accessToken;
        },
      ),
);

/// Conexión de tiempo real mientras hay sesión; se cierra al salir.
final realtimeClientProvider = Provider<RealtimeClient?>((ref) {
  if (ref.watch(sessionProvider) != SessionStatus.authenticated) return null;
  final client = ref.watch(realtimeClientFactoryProvider)();
  ref.onDispose(client.dispose);
  return client;
});

/// Avisos en tiempo real (para `ref.listen` en las pantallas).
final realtimeEventsProvider = StreamProvider<RealtimeEvent>((ref) {
  final client = ref.watch(realtimeClientProvider);
  return client?.events ?? const Stream.empty();
});

/// Cuenta las (re)conexiones: las pantallas lo observan para pedir su estado por REST.
final realtimeResyncProvider = StreamProvider<int>((ref) async* {
  final client = ref.watch(realtimeClientProvider);
  if (client == null) return;
  var n = 0;
  await for (final _ in client.resync) {
    yield ++n;
  }
});

import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import 'realtime_client.dart';

/// Devuelve un token de acceso vigente. Con `forceRefresh`, renueva la sesión primero.
typedef AccessTokenSource = Future<String?> Function({bool forceRefresh});

/// Cliente Socket.IO (ADR-0023):
/// - autentica el handshake con el token de acceso vigente (lo pide en cada conexión);
/// - reconecta con espera creciente si se cae la red;
/// - si el servidor rechaza el token o corta el socket al vencer, renueva la sesión y
///   vuelve a conectar;
/// - en cada conexión emite [resync] para que la app pida el estado por REST.
class SocketIoRealtimeClient implements RealtimeClient {
  SocketIoRealtimeClient({required String url, required this.token}) {
    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(10000)
          .enableForceNew()
          .setAuthFn((callback) {
            token().then(
              (t) => callback({'token': t ?? ''}),
              onError: (_) => callback({'token': ''}),
            );
          })
          .build(),
    );
    for (final name in RealtimeEvents.all) {
      _socket.on(name, (data) {
        if (data is Map) {
          _events.add(RealtimeEvent(name, Map<String, dynamic>.from(data)));
        }
      });
    }
    _socket.onConnect((_) {
      _authRetries = 0;
      _resync.add(null);
    });
    _socket.onConnectError(_onConnectError);
    _socket.onDisconnect((reason) {
      // El servidor cortó el socket (token vencido): no reconecta solo.
      if (reason == 'io server disconnect') _reconnectWithFreshToken();
    });
    _socket.connect();
  }

  final AccessTokenSource token;
  late final io.Socket _socket;
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _resync = StreamController<void>.broadcast();
  int _authRetries = 0;
  Timer? _retry;
  bool _disposed = false;

  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<void> get resync => _resync.stream;

  @override
  bool get isConnected => _socket.connected;

  void _onConnectError(dynamic error) {
    final code = error is Map
        ? (error['data'] is Map ? (error['data'] as Map)['code'] : null)
        : null;
    // Un rechazo del middleware no se reintenta solo: renueva el token y reconecta.
    if (code == 'TOKEN_INVALID' || code == 'UNAUTHENTICATED') {
      _reconnectWithFreshToken();
    }
  }

  void _reconnectWithFreshToken() {
    if (_disposed || _retry != null) return;
    final delay = Duration(seconds: (1 << _authRetries.clamp(0, 4)));
    _authRetries++;
    _retry = Timer(delay, () async {
      _retry = null;
      if (_disposed) return;
      await token(forceRefresh: true);
      if (!_disposed) _socket.connect();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _retry?.cancel();
    _socket.dispose();
    _events.close();
    _resync.close();
  }
}

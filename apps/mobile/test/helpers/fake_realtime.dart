import 'dart:async';

import 'package:sisi_mobile/core/realtime/realtime_client.dart';

/// Tiempo real falso: los tests emiten avisos y simulan reconexiones.
class FakeRealtimeClient implements RealtimeClient {
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _resync = StreamController<void>.broadcast();
  bool disposed = false;

  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<void> get resync => _resync.stream;

  @override
  bool get isConnected => !disposed;

  void emit(String name, Map<String, dynamic> data) =>
      _events.add(RealtimeEvent(name, data));

  /// Simula una reconexión: la app debe volver a pedir el estado por REST.
  void reconnect() => _resync.add(null);

  @override
  void dispose() {
    disposed = true;
  }
}

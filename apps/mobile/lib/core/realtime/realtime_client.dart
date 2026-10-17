import 'dart:async';

/// Eventos que envía la API (doc 02 §6, docs/realtime-events.md).
abstract final class RealtimeEvents {
  static const requestNew = 'request:new';
  static const requestAssigned = 'request:assigned';
  static const requestExpired = 'request:expired';
  static const offerNew = 'offer:new';
  static const offerClosed = 'offer:closed';
  static const jobStatus = 'job:status';
  static const jobLocation = 'job:location';
  static const chatMessage = 'chat:message';
  static const billingDue = 'billing:due';
  static const accountBlocked = 'account:blocked';
  static const accountUnblocked = 'account:unblocked';

  static const all = [
    requestNew,
    requestAssigned,
    requestExpired,
    offerNew,
    offerClosed,
    jobStatus,
    jobLocation,
    chatMessage,
    billingDue,
    accountBlocked,
    accountUnblocked,
  ];
}

/// Un aviso en tiempo real. Es solo un aviso: el estado verdadero se pide por REST.
class RealtimeEvent {
  const RealtimeEvent(this.name, this.data);

  final String name;
  final Map<String, dynamic> data;

  String? get requestId => data['requestId'] as String?;

  String? get jobId => data['jobId'] as String?;

  @override
  String toString() => 'RealtimeEvent($name, $data)';
}

/// Conexión de tiempo real (ADR-0023).
abstract class RealtimeClient {
  /// Avisos que llegan del servidor.
  Stream<RealtimeEvent> get events;

  /// Emite cada vez que (re)conecta: las pantallas vuelven a pedir su estado por REST,
  /// porque mientras no había conexión se pudieron perder avisos.
  Stream<void> get resync;

  bool get isConnected;

  void dispose();
}

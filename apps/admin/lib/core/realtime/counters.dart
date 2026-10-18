import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../auth/session.dart';
import '../config/env.dart';
import '../http/api_client.dart';

/// Colas pendientes del menú (ADR-0044).
class Counters {
  const Counters({
    this.verifications = 0,
    this.heldRequests = 0,
    this.heldMessages = 0,
    this.reports = 0,
    this.disputes = 0,
    this.submissions = 0,
  });

  factory Counters.fromDto(CountersDto d) => Counters(
    verifications: d.verifications.toInt(),
    heldRequests: d.heldRequests.toInt(),
    heldMessages: d.heldMessages.toInt(),
    reports: d.reports.toInt(),
    disputes: d.disputes.toInt(),
    submissions: d.submissions.toInt(),
  );

  factory Counters.fromJson(Map<String, dynamic> j) {
    int n(String k) => (j[k] as num?)?.toInt() ?? 0;
    return Counters(
      verifications: n('verifications'),
      heldRequests: n('heldRequests'),
      heldMessages: n('heldMessages'),
      reports: n('reports'),
      disputes: n('disputes'),
      submissions: n('submissions'),
    );
  }

  final int verifications;
  final int heldRequests;
  final int heldMessages;
  final int reports;
  final int disputes;
  final int submissions;

  int get moderation => heldRequests + heldMessages + reports + disputes;
}

/// Fuente de `admin:counters` por socket. Los tests la reemplazan.
abstract interface class CountersFeed {
  Stream<Map<String, dynamic>> get updates;
  void dispose();
}

/// Socket.IO directo a la API (Vercel no proxea websockets, ADR-0040), con el token de
/// acceso vigente en cada conexión.
class SocketCountersFeed implements CountersFeed {
  SocketCountersFeed(String url, Future<String?> Function() token) {
    _socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
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
    _socket.on('admin:counters', (data) {
      if (data is Map) _updates.add(Map<String, dynamic>.from(data));
    });
  }

  late final io.Socket _socket;
  final _updates = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get updates => _updates.stream;

  @override
  void dispose() {
    _socket.dispose();
    unawaited(_updates.close());
  }
}

final countersFeedProvider = Provider<CountersFeed>((ref) {
  final session = ref.read(sessionProvider.notifier);
  final feed = SocketCountersFeed(Env.socketUrl, session.accessToken);
  ref.onDispose(feed.dispose);
  return feed;
});

/// Cada cuánto se piden por REST como respaldo del socket.
const countersPollInterval = Duration(seconds: 60);

final countersProvider = NotifierProvider<CountersController, Counters>(
  CountersController.new,
);

class CountersController extends Notifier<Counters> {
  @override
  Counters build() {
    final signedIn = ref.watch(sessionProvider.select((s) => s is SignedIn));
    if (!signedIn) return const Counters();
    final sub = ref.watch(countersFeedProvider).updates.listen((json) {
      state = Counters.fromJson(json);
    });
    final timer = Timer.periodic(
      countersPollInterval,
      (_) => unawaited(refresh()),
    );
    ref.onDispose(() {
      unawaited(sub.cancel());
      timer.cancel();
    });
    unawaited(Future.microtask(refresh));
    return const Counters();
  }

  Future<void> refresh() async {
    try {
      final res = await ref
          .read(adminApiProvider)
          .dashboardControllerCounters();
      if (res.data != null) state = Counters.fromDto(res.data!);
    } catch (_) {
      // Sin red: queda el último valor; el socket o la próxima vuelta lo corrigen.
    }
  }
}

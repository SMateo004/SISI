import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/auth/session_controller.dart';
import 'package:sisi_mobile/core/auth/token_storage.dart';
import 'package:sisi_mobile/core/realtime/realtime_client.dart';
import 'package:sisi_mobile/core/realtime/realtime_providers.dart';

import '../helpers/fake_realtime.dart';
import '../helpers/fakes.dart';

String _jwt(int exp) {
  String part(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  return '${part({'alg': 'HS256'})}.${part({'sub': 'u1', 'exp': exp})}.firma';
}

void main() {
  test('lee cuántos segundos le quedan al token de acceso', () {
    final now = DateTime.fromMillisecondsSinceEpoch(1_800_000_000 * 1000);
    expect(secondsUntilExpiry(_jwt(1_800_000_900), now), 900);
    expect(secondsUntilExpiry(_jwt(1_799_999_990), now), -10);
    expect(secondsUntilExpiry('no-es-jwt', now), isNull);
  });

  test(
    'con sesión: entrega avisos y cuenta reconexiones; al salir, cierra',
    () async {
      final fake = FakeRealtimeClient();
      final container = ProviderContainer(
        overrides: [
          tokenStorageProvider.overrideWithValue(
            MemoryTokenStorage(testTokens),
          ),
          realtimeClientFactoryProvider.overrideWithValue(() => fake),
        ],
      );
      addTearDown(container.dispose);

      // Restaura la sesión guardada.
      container.read(sessionProvider);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(sessionProvider), SessionStatus.authenticated);

      final events = <RealtimeEvent>[];
      container.listen(realtimeEventsProvider, (_, next) {
        final value = next.value;
        if (value != null) events.add(value);
      });
      final resyncs = <int>[];
      container.listen(realtimeResyncProvider, (_, next) {
        final value = next.value;
        if (value != null) resyncs.add(value);
      });

      // Deja que los providers se suscriban antes de emitir.
      await Future<void>.delayed(Duration.zero);
      fake.emit(RealtimeEvents.offerNew, {'requestId': 'r1'});
      fake.reconnect();
      fake.reconnect();
      await Future<void>.delayed(Duration.zero);
      expect(events.single.requestId, 'r1');
      expect(resyncs, [1, 2]);

      await container.read(sessionProvider.notifier).signOut();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(realtimeClientProvider), isNull);
      expect(fake.disposed, isTrue);
    },
  );
}

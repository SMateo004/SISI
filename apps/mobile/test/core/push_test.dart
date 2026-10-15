import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/push/push_controller.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';

import '../helpers/fake_matching.dart';
import '../helpers/fake_push.dart';
import '../helpers/fakes.dart';

void main() {
  test('solo abre rutas de la app que corresponden a avisos', () {
    expect(isPushRoute('/solicitudes/r1'), isTrue);
    expect(isPushRoute('/trabajo/solicitudes/r1'), isTrue);
    expect(isPushRoute('/trabajos/j1/contacto'), isTrue);
    expect(isPushRoute('/perfil'), isFalse);
    expect(isPushRoute('https://otro.sitio/solicitudes/x'), isFalse);
    expect(isPushRoute(null), isFalse);
  });

  testWidgets('con sesión registra el token del dispositivo (y el rotado)', (
    tester,
  ) async {
    final push = FakePushService(token: 'tok-1');
    final devices = FakeDevicesApi();
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      push: push,
      devices: devices,
    );
    expect(devices.registered, [('tok-1', 'android')]);

    push.rotate('tok-2');
    await tester.pumpAndSettle();
    expect(devices.registered.last, ('tok-2', 'android'));
  });

  testWidgets('tocar el aviso abre la pantalla de la solicitud', (
    tester,
  ) async {
    final push = FakePushService(token: 'tok-1');
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      me: FakeMeRepository(user: testUser(mode: ActiveMode.worker)),
      offers: FakeOffersRepository(
        incoming: [testIncoming(id: 'r9', respondIn: Duration.zero)],
      ),
      push: push,
    );

    push.tap('/trabajo/solicitudes/r9');
    await tester.pumpAndSettle();
    expect(find.text('Solicitud cercana'), findsOneWidget);
    expect(find.byKey(const Key('incoming-r9')), findsOneWidget);
  });

  testWidgets(
    'con la app abierta muestra el aviso con "Ver"; ignora rutas ajenas',
    (tester) async {
      final push = FakePushService(token: 'tok-1');
      await pumpSisiApp(tester, storedTokens: testTokens, push: push);

      push.receive(
        'Recibiste una oferta',
        'Ana R. ofrece Bs 180,00.',
        '/solicitudes/r1',
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        find.text('Recibiste una oferta · Ana R. ofrece Bs 180,00.'),
        findsOneWidget,
      );
      expect(find.text('Ver'), findsOneWidget);

      push.tap('/perfil');
      await tester.pumpAndSettle();
      expect(find.text('Mi perfil'), findsNothing);
    },
  );

  testWidgets('al cerrar sesión da de baja el token', (tester) async {
    final devices = FakeDevicesApi();
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      push: FakePushService(token: 'tok-1'),
      devices: devices,
    );
    await tester.tap(find.byTooltip('Mi perfil'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(devices.unregistered, ['tok-1']);
  });
}

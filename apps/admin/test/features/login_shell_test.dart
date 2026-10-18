import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

FakeApi _api() =>
    FakeApi()..on(#dashboardControllerGet, (_) async => ok(dashboard()));

void main() {
  testWidgets(
    'sin sesión va al ingreso: usuario y código, sin teléfono; entra al dashboard',
    (tester) async {
      final gateway = FakeAuthGateway(signedIn: false);
      await pumpAdmin(tester, api: _api(), gateway: gateway);
      expect(find.text('Panel de SISI'), findsOneWidget);
      expect(find.text('Celular'), findsNothing);

      final submit = find.byKey(const Key('login-submit'));
      expect(tester.widget<FilledButton>(submit).onPressed, isNull);
      await tester.enterText(find.byKey(const Key('login-code')), '123456');
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(gateway.logins, [('admin', '123456')]);

      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Bs 136,50'), findsOneWidget);
      expect(find.text('75 %'), findsOneWidget);
    },
  );

  testWidgets(
    'usuario o código incorrecto: muestra el error y borra el código',
    (tester) async {
      final gateway = FakeAuthGateway(
        signedIn: false,
        loginError: apiError(
          401,
          'ADMIN_LOGIN_INVALID',
          'Usuario o código incorrecto.',
        ),
      );
      await pumpAdmin(tester, api: _api(), gateway: gateway);
      await tester.enterText(find.byKey(const Key('login-code')), '654321');
      await tester.pump();
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Usuario o código incorrecto.'), findsOneWidget);
      expect(find.byKey(const Key('nav-rail')), findsNothing);
      final code = tester.widget<TextField>(
        find.byKey(const Key('login-code')),
      );
      expect(code.controller!.text, isEmpty);
    },
  );

  testWidgets('con la cookie vigente entra directo; salir vuelve al ingreso', (
    tester,
  ) async {
    await pumpAdmin(tester, api: _api());
    expect(find.byKey(const Key('nav-rail')), findsOneWidget);
    await tester.tap(find.byKey(const Key('logout')));
    await tester.pumpAndSettle();
    expect(find.text('Panel de SISI'), findsOneWidget);
  });

  testWidgets('el menú muestra las colas y las actualiza en vivo por socket', (
    tester,
  ) async {
    final api = _api()
      ..countersValue = counters(
        verifications: 2,
        heldRequests: 1,
        reports: 2,
        submissions: 3,
      );
    final feed = FakeCountersFeed();
    await pumpAdmin(tester, api: api, feed: feed);
    expect(
      find.descendant(
        of: find.byKey(const Key('badge-/verificaciones')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('badge-/moderacion')),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('badge-/cobros')),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );

    feed.controller.add({
      'verifications': 5,
      'heldRequests': 0,
      'heldMessages': 0,
      'reports': 0,
      'disputes': 0,
      'submissions': 0,
      'at': '2026-10-19T14:00:00.000Z',
    });
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('badge-/verificaciones')),
        matching: find.text('5'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('badge-/moderacion')), findsNothing);
  });
}

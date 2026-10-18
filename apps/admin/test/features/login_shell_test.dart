import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

FakeApi _api() =>
    FakeApi()..on(#dashboardControllerGet, (_) async => ok(dashboard()));

void main() {
  testWidgets('sin sesión va al ingreso; con el código entra al dashboard', (
    tester,
  ) async {
    final gateway = FakeAuthGateway(signedIn: false);
    await pumpAdmin(tester, api: _api(), gateway: gateway);
    expect(find.text('Panel de SISI'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('login-phone')), '70000001');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(gateway.requested, ['70000001']);
    await tester.enterText(find.byKey(const Key('login-code')), '123456');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Bs 136,50'), findsOneWidget);
    expect(find.text('75 %'), findsOneWidget);
  });

  testWidgets('una cuenta sin rol admin ve el aviso y no entra', (
    tester,
  ) async {
    final gateway = FakeAuthGateway(
      signedIn: false,
      verifyError: apiError(
        403,
        'ADMIN_ONLY',
        'Esta cuenta no tiene acceso al panel.',
      ),
    );
    await pumpAdmin(tester, api: _api(), gateway: gateway);
    await tester.enterText(find.byKey(const Key('login-phone')), '70000002');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('login-code')), '123456');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Esta cuenta no tiene acceso al panel.'), findsOneWidget);
    expect(find.byKey(const Key('nav-rail')), findsNothing);
  });

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

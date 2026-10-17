import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_jobs.dart';
import '../../helpers/fakes.dart';

void main() {
  testWidgets(
    'el ícono muestra los no leídos; tocar un aviso abre su pantalla',
    (tester) async {
      final notifications = FakeNotificationsRepository(
        items: [
          testNotification(id: 'n1'),
          testNotification(id: 'n2', title: 'Recibiste una oferta'),
          testNotification(id: 'n3', title: 'Aviso viejo', read: true),
        ],
      );
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        notifications: notifications,
        jobs: FakeJobsRepository(jobs: [testJob(myRole: 'employer')]),
      );
      expect(find.byKey(const Key('unread-count')), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byKey(const Key('notifications-bell')));
      await tester.pumpAndSettle();
      expect(find.text('Ana R. va en camino'), findsOneWidget);
      expect(find.text('Aviso viejo'), findsOneWidget);

      await tester.tap(find.byKey(const Key('notification-n1')));
      await tester.pumpAndSettle();
      expect(notifications.markedRead, ['n1']);
      // Abrió el trabajo de la ruta del aviso.
      expect(find.byKey(const Key('job-status')), findsOneWidget);
    },
  );

  testWidgets('"Marcar todo como leído" deja el contador en cero', (
    tester,
  ) async {
    final notifications = FakeNotificationsRepository(
      items: [
        testNotification(id: 'n1'),
        testNotification(id: 'n2'),
      ],
    );
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      notifications: notifications,
    );
    await tester.tap(find.byKey(const Key('notifications-bell')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('read-all')));
    await tester.pumpAndSettle();
    expect(notifications.readAllCalls, 1);
    expect(find.byKey(const Key('read-all')), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('unread-count')), findsNothing);
  });
}

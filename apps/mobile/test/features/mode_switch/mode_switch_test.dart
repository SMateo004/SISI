import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/features/mode_switch/domain/mode_denial.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';
import 'package:sisi_mobile/features/worker_onboarding/domain/worker_models.dart';

import '../../helpers/fakes.dart';

ModeDeniedException denial(
  String code,
  String message,
  NextAction action,
  String label,
) => ModeDeniedException(
  code: code,
  message: message,
  nextAction: action,
  actionLabel: label,
);

void main() {
  testWidgets('aprobado: pasa a modo trabajador y vuelve a empleador', (
    tester,
  ) async {
    final me = FakeMeRepository();
    await pumpSisiApp(tester, storedTokens: testTokens, me: me);

    expect(find.text('¿Qué servicio necesitas?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('mode-worker')));
    await tester.pumpAndSettle();
    expect(me.user.activeMode, ActiveMode.worker);
    // En modo trabajador: toggle "Disponible" y bandeja de solicitudes.
    expect(find.byKey(const Key('availability-switch')), findsOneWidget);
    expect(find.byKey(const Key('incoming-empty')), findsOneWidget);

    await tester.tap(find.byKey(const Key('mode-employer')));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué servicio necesitas?'), findsOneWidget);
  });

  testWidgets('sin nombre el avatar muestra un ícono, no el + del teléfono', (
    tester,
  ) async {
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      me: FakeMeRepository(user: testUser(name: null)),
    );
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('+'), findsNothing);
  });

  testWidgets('también se cambia deslizando', (tester) async {
    final me = FakeMeRepository();
    await pumpSisiApp(tester, storedTokens: testTokens, me: me);
    await tester.fling(
      find.byKey(const Key('mode-switch')),
      const Offset(300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(me.user.activeMode, ActiveMode.worker);
  });

  final cases = <(String, ModeDeniedException, String)>[
    (
      'sin solicitar',
      denial(
        'WORKER_NOT_REQUESTED',
        'Para trabajar en SISI primero tienes que verificar tu identidad.',
        NextAction.completeVerification,
        'Completa tu verificación',
      ),
      'Tus datos',
    ),
    (
      'en revisión',
      denial(
        'WORKER_UNDER_REVIEW',
        'Tu solicitud está en revisión. Te avisaremos cuando esté lista.',
        NextAction.viewReviewStatus,
        'Ver el estado de tu solicitud',
      ),
      'Tu verificación',
    ),
    (
      'rechazado',
      denial(
        'WORKER_REJECTED',
        'Tu solicitud fue rechazada. Revisa el motivo y vuelve a enviarla.',
        NextAction.resubmitVerification,
        'Corregir y reenviar',
      ),
      'Tus datos',
    ),
    (
      'bloqueado por deuda',
      denial(
        'WORKER_BLOCKED_DEBT',
        'Tienes una comisión vencida. Págala para volver a recibir trabajos.',
        NextAction.payCommission,
        'Paga tu comisión pendiente',
      ),
      'Tu verificación',
    ),
    (
      'suspendido',
      denial(
        'WORKER_SUSPENDED',
        'Tu cuenta de trabajador está suspendida mientras revisamos un reporte.',
        NextAction.contactSupport,
        'Contactar a soporte',
      ),
      'Tu verificación',
    ),
  ];

  for (final (name, deniedWith, destination) in cases) {
    testWidgets('$name: muestra el motivo y la acción siguiente', (
      tester,
    ) async {
      final me = FakeMeRepository(denial: deniedWith);
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        me: me,
        worker: FakeWorkerRepository(
          profile: const WorkerProfile(
            status: WorkerStatus.sinSolicitar,
            documents: [],
            missingDocuments: DocumentType.values,
            editable: true,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('mode-worker')));
      await tester.pumpAndSettle();
      expect(me.user.activeMode, ActiveMode.employer);
      expect(find.text('Todavía no puedes trabajar'), findsOneWidget);
      expect(find.text(deniedWith.message), findsOneWidget);
      expect(find.text('Seguir como empleador'), findsOneWidget);

      await tester.tap(find.text(deniedWith.actionLabel));
      await tester.pumpAndSettle();
      expect(find.text(destination), findsWidgets);
    });
  }

  testWidgets('bloqueado: cambiar a empleador siempre funciona', (
    tester,
  ) async {
    final me = FakeMeRepository(
      user: testUser(mode: ActiveMode.worker),
      denial: denial(
        'WORKER_BLOCKED_DEBT',
        'Deuda',
        NextAction.payCommission,
        'Paga',
      ),
    );
    await pumpSisiApp(tester, storedTokens: testTokens, me: me);
    await tester.tap(find.byKey(const Key('mode-employer')));
    await tester.pumpAndSettle();
    expect(me.user.activeMode, ActiveMode.employer);
    expect(find.text('Todavía no puedes trabajar'), findsNothing);
  });
}

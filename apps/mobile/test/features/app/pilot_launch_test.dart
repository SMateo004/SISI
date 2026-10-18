import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/app_gate/client_app_repository.dart';
import 'package:sisi_mobile/core/http/api_exception.dart';
import 'package:sisi_mobile/core/permissions/permission_primer.dart';
import 'package:sisi_mobile/features/account_deletion/account_deletion.dart';

import '../../helpers/fake_app.dart';
import '../../helpers/fake_push.dart';
import '../../helpers/fakes.dart';

/// Fase 7: textos legales, versión mínima, "Acerca de", eliminación de cuenta, piloto
/// cerrado y explicaciones de permisos.
void main() {
  group('Textos legales (ADR-0051)', () {
    testWidgets(
      'sin aceptar, la app lleva a la pantalla de aceptación y no deja seguir sin '
      'las dos casillas',
      (tester) async {
        final app = FakeClientAppRepository(legalPending: ['terms', 'privacy']);
        await pumpSisiApp(tester, storedTokens: testTokens, clientApp: app);

        expect(find.text('Antes de empezar'), findsOneWidget);
        expect(find.byKey(const Key('legal-draft-banner')), findsOneWidget);
        final button = find.byKey(const Key('legal-continue'));
        expect(tester.widget<FilledButton>(button).onPressed, isNull);

        await tester.tap(find.byKey(const Key('legal-accept')));
        await tester.pump();
        expect(tester.widget<FilledButton>(button).onPressed, isNull);
        await tester.tap(find.byKey(const Key('legal-adult')));
        await tester.pump();
        await tester.tap(button);
        await tester.pumpAndSettle();

        expect(app.accepted, [(1, 1)]);
        expect(find.text('Antes de empezar'), findsNothing);
        expect(find.textContaining('Hola'), findsOneWidget);
      },
    );

    testWidgets('se puede leer cada texto con su versión', (tester) async {
      final app = FakeClientAppRepository(legalPending: ['terms']);
      await pumpSisiApp(tester, storedTokens: testTokens, clientApp: app);
      await tester.tap(find.byKey(const Key('legal-doc-terms')));
      await tester.pumpAndSettle();
      expect(find.text('Versión 1'), findsOneWidget);
      expect(find.textContaining('mayor de 18'), findsOneWidget);
      expect(find.byKey(const Key('legal-pilot-banner')), findsNothing);
    });

    testWidgets(
      'los textos v0 avisan que son del piloto cerrado con invitación',
      (tester) async {
        final app = FakeClientAppRepository(
          legalPending: ['terms', 'privacy'],
          draft: false,
          pilotOnly: true,
        );
        await pumpSisiApp(tester, storedTokens: testTokens, clientApp: app);
        expect(find.byKey(const Key('legal-pilot-banner')), findsOneWidget);
        expect(find.byKey(const Key('legal-draft-banner')), findsNothing);
        expect(find.text('Versión 1 · Piloto cerrado'), findsNWidgets(2));

        await tester.tap(find.byKey(const Key('legal-doc-privacy')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('legal-pilot-banner')), findsOneWidget);
        expect(find.textContaining('usuarios invitados'), findsOneWidget);
      },
    );
  });

  group('Versión mínima (ADR-0054)', () {
    testWidgets(
      'una versión vieja solo ve "Actualiza la app" con el enlace a la tienda',
      (tester) async {
        final opened = <Uri>[];
        await pumpSisiApp(
          tester,
          storedTokens: testTokens,
          openedUrls: opened,
          clientApp: FakeClientAppRepository(
            upgradeRequired: true,
            storeUrl: 'https://play.google.com/store/apps/details?id=bo.sisi',
          ),
        );
        expect(find.text('Actualiza la app'), findsOneWidget);
        await tester.tap(find.byKey(const Key('update-store')));
        await tester.pumpAndSettle();
        expect(opened.single.host, 'play.google.com');
      },
    );
  });

  group('Acerca de y soporte', () {
    testWidgets(
      'muestra la versión, la ayuda por WhatsApp y eliminar la cuenta',
      (tester) async {
        final opened = <Uri>[];
        await pumpSisiApp(
          tester,
          storedTokens: testTokens,
          openedUrls: opened,
          clientApp: FakeClientAppRepository(
            support: SupportInfo(
              whatsapp: '+59170000001',
              url: Uri.parse('https://wa.me/59170000001?text=Hola'),
            ),
          ),
        );
        await tester.tap(find.byTooltip('Mi perfil'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('profile-about')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('profile-support')), findsOneWidget);
        await tester.tap(find.byKey(const Key('profile-about')));
        await tester.pumpAndSettle();

        expect(find.text('Versión de desarrollo'), findsOneWidget);
        await tester.tap(find.byKey(const Key('about-support')));
        await tester.pumpAndSettle();
        expect(opened.single.host, 'wa.me');
        expect(find.byKey(const Key('about-delete')), findsOneWidget);
      },
    );
  });

  group('Eliminar la cuenta (ADR-0049)', () {
    Future<void> openDeletion(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Mi perfil'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('profile-about')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('profile-about')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('about-delete')));
      await tester.pumpAndSettle();
    }

    testWidgets('sin deuda: código por SMS, confirmar y vuelve al ingreso', (
      tester,
    ) async {
      final account = FakeAccountRepository();
      await pumpSisiApp(tester, storedTokens: testTokens, account: account);
      await openDeletion(tester);

      expect(find.text('Qué se borra'), findsOneWidget);
      await tester.tap(find.byKey(const Key('deletion-send-code')));
      await tester.pumpAndSettle();
      expect(account.codesSent, 1);
      await tester.enterText(find.byKey(const Key('deletion-code')), '123456');
      await tester.tap(find.byKey(const Key('deletion-confirm')));
      await tester.pumpAndSettle();

      expect(account.deletedWith, ['123456']);
      expect(find.text('Tu cuenta fue eliminada.'), findsOneWidget);
      expect(find.text('Recibir código'), findsOneWidget);
    });

    testWidgets(
      'con deuda: muestra el monto y lleva a pagar, sin opción de eliminar',
      (tester) async {
        await pumpSisiApp(
          tester,
          storedTokens: testTokens,
          account: FakeAccountRepository(
            blockers: const [
              DeletionBlocker(
                code: 'ACCOUNT_HAS_DEBT',
                message:
                    'Tienes una comisión pendiente. Págala para poder eliminar tu cuenta.',
                balanceBs: '19.50',
                paymentReference: 'SISI-2643-K7M2QX',
              ),
            ],
          ),
        );
        await openDeletion(tester);

        expect(find.text('Debes Bs 19,50'), findsOneWidget);
        expect(find.textContaining('SISI-2643-K7M2QX'), findsOneWidget);
        expect(find.byKey(const Key('deletion-send-code')), findsNothing);
        await tester.tap(find.byKey(const Key('deletion-pay')));
        await tester.pumpAndSettle();
        expect(find.text('Pagar comisión'), findsWidgets);
      },
    );
  });

  group('Piloto cerrado (ADR-0052)', () {
    testWidgets(
      'un número fuera de la lista ve "Pronto en tu zona" y deja su interés',
      (tester) async {
        final pilot = FakePilotRepository();
        await pumpSisiApp(
          tester,
          pilot: pilot,
          auth: FakeAuthRepository(
            requestError: const ApiException(
              code: 'PILOT_NOT_ALLOWED',
              message: 'Pronto en tu zona.',
              statusCode: 403,
              extra: {'cityName': 'Santa Cruz de la Sierra'},
            ),
          ),
        );
        await tester.enterText(find.byType(TextFormField).first, '70012345');
        await tester.tap(find.text('Recibir código'));
        await tester.pumpAndSettle();

        expect(find.text('Pronto en tu zona'), findsOneWidget);
        expect(find.textContaining('Santa Cruz de la Sierra'), findsOneWidget);
        await tester.tap(find.text('Trabajar ofreciendo servicios'));
        await tester.enterText(
          find.byKey(const Key('interest-zone')),
          'Plan 3000',
        );
        await tester.tap(find.byKey(const Key('interest-submit')));
        await tester.pumpAndSettle();

        expect(pilot.interests, [('70012345', 'worker', 'Plan 3000')]);
        expect(find.byKey(const Key('interest-done')), findsOneWidget);
      },
    );
  });

  group('Permisos explicados (ADR-0051)', () {
    testWidgets(
      'los avisos se explican en el inicio y recién con "Activar" se piden',
      (tester) async {
        final push = FakePushService(token: 'tok-1');
        final devices = FakeDevicesApi();
        final primers = MemoryPrimerStore();
        await pumpSisiApp(
          tester,
          storedTokens: testTokens,
          push: push,
          devices: devices,
          primers: primers,
          pushAvailable: true,
        );
        expect(find.byKey(const Key('notifications-primer')), findsOneWidget);
        expect(devices.registered, isEmpty);

        await tester.tap(find.byKey(const Key('notifications-primer-enable')));
        await tester.pumpAndSettle();
        expect(devices.registered, [('tok-1', 'android')]);
        expect(
          primers.answers[PrimedPermission.notifications],
          PrimerAnswer.accepted,
        );
        expect(find.byKey(const Key('notifications-primer')), findsNothing);
      },
    );

    testWidgets('"Ahora no" oculta la tarjeta y no pide el permiso', (
      tester,
    ) async {
      final devices = FakeDevicesApi();
      final primers = MemoryPrimerStore();
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        push: FakePushService(token: 'tok-1'),
        devices: devices,
        primers: primers,
        pushAvailable: true,
      );
      await tester.tap(find.byKey(const Key('notifications-primer-later')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('notifications-primer')), findsNothing);
      expect(devices.registered, isEmpty);
      expect(
        primers.answers[PrimedPermission.notifications],
        PrimerAnswer.declined,
      );
    });

    testWidgets('una explicación aceptada no se vuelve a mostrar', (
      tester,
    ) async {
      final store = MemoryPrimerStore();
      final results = <bool>[];
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () async => results.add(
                  await explainOnce(
                    context,
                    store,
                    PrimedPermission.camera,
                    icon: Icons.photo_camera_outlined,
                    title: 'Tu cámara',
                    message: 'Solo para tus fotos.',
                  ),
                ),
                child: const Text('Foto'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Foto'));
      await tester.pumpAndSettle();
      expect(find.text('Tu cámara'), findsOneWidget);
      await tester.tap(find.byKey(const Key('primer-camera-continue')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Foto'));
      await tester.pumpAndSettle();
      expect(find.text('Tu cámara'), findsNothing);
      expect(results, [true, true]);
    });
  });
}

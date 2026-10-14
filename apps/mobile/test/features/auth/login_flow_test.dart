import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/features/auth/presentation/phone_screen.dart';
import 'package:sisi_mobile/features/mode_switch/presentation/mode_switch.dart';

import '../../helpers/fakes.dart';

void main() {
  group('validateBolivianMobile', () {
    test('acepta celulares de 8 dígitos que empiezan con 6 o 7', () {
      expect(validateBolivianMobile('70012345'), isNull);
      expect(validateBolivianMobile('67891234'), isNull);
    });

    test('rechaza vacíos, fijos y longitudes incorrectas', () {
      expect(validateBolivianMobile(''), 'Ingresa tu número de celular.');
      expect(validateBolivianMobile('33456789'), isNotNull);
      expect(validateBolivianMobile('7001234'), isNotNull);
    });
  });

  testWidgets('sin sesión muestra el login con +591', (tester) async {
    await pumpSisiApp(tester);
    expect(find.text('Ingresa tu número'), findsOneWidget);
    expect(find.text('+591 '), findsOneWidget);
    expect(find.text('Recibir código'), findsOneWidget);
  });

  testWidgets('valida el número antes de pedir el código', (tester) async {
    final auth = FakeAuthRepository();
    await pumpSisiApp(tester, auth: auth);
    await tester.enterText(find.byKey(const Key('phone-field')), '3345');
    await tester.tap(find.text('Recibir código'));
    await tester.pumpAndSettle();
    expect(
      find.text('Ingresa un celular de 8 dígitos que empiece con 6 o 7.'),
      findsOneWidget,
    );
    expect(auth.requested, isEmpty);
  });

  testWidgets(
    'login completo: código, temporizador, reenvío, error y entrada',
    (tester) async {
      final auth = FakeAuthRepository(resendInSec: 3);
      await pumpSisiApp(tester, auth: auth);

      await tester.enterText(find.byKey(const Key('phone-field')), '70012345');
      await tester.tap(find.text('Recibir código'));
      await tester.pumpAndSettle();
      expect(auth.requested, ['+59170012345']);
      expect(find.textContaining('+591 70012345'), findsOneWidget);

      // Temporizador de reenvío.
      expect(find.text('Puedes pedir otro código en 0:03'), findsOneWidget);
      expect(find.text('Reenviar código'), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Puedes pedir otro código en 0:02'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      await tester.tap(find.text('Reenviar código'));
      await tester.pumpAndSettle();
      expect(auth.requested, hasLength(2));
      expect(find.text('Te enviamos un código nuevo.'), findsOneWidget);
      expect(find.text('Puedes pedir otro código en 0:03'), findsOneWidget);

      // Código incorrecto: mensaje de la API.
      await tester.enterText(find.byKey(const Key('otp-field')), '000000');
      await tester.pumpAndSettle();
      expect(find.text('Código incorrecto o vencido.'), findsOneWidget);

      // Código correcto: entra al inicio con el interruptor.
      await tester.enterText(find.byKey(const Key('otp-field')), '123456');
      await tester.pumpAndSettle();
      expect(find.byType(ModeSwitch), findsOneWidget);
      expect(find.text('Hola, María'), findsOneWidget);

      // Deja que termine el temporizador pendiente.
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets('con tokens guardados entra directo al inicio', (tester) async {
    await pumpSisiApp(tester, storedTokens: testTokens);
    expect(find.byType(ModeSwitch), findsOneWidget);
  });
}

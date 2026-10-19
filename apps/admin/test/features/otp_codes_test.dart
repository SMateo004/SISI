import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';

OtpCodeDto _code({
  required String phone,
  required String code,
  bool accountExists = true,
  String? name,
  OtpCodeDtoActiveModeEnum? mode = OtpCodeDtoActiveModeEnum.employer,
  DateTime? usedAt,
}) {
  final now = DateTime.now();
  return OtpCodeDto(
    phone: phone,
    code: code,
    sentAt: now.subtract(const Duration(seconds: 20)),
    expiresAt: now.add(const Duration(minutes: 4)),
    usedAt: usedAt,
    accountExists: accountExists,
    name: name,
    activeMode: accountExists ? mode : null,
  );
}

void main() {
  testWidgets(
    'muestra el código por usuario (nuevo, empleador, trabajador) y se actualiza solo',
    (tester) async {
      var items = [
        _code(phone: '+59170000001', code: '111111', accountExists: false),
        _code(
          phone: '+59170000002',
          code: '222222',
          name: 'María Pérez',
          mode: OtpCodeDtoActiveModeEnum.worker,
        ),
      ];
      final api = FakeApi()
        ..on(
          #adminOtpCodesControllerList,
          (_) async => ok(OtpCodesDto(enabled: true, items: items)),
        );
      await pumpAdmin(tester, api: api, location: '/codigos');
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Códigos de ingreso'), findsOneWidget);
      expect(find.text('111111'), findsOneWidget);
      expect(find.text('Registro nuevo'), findsOneWidget);
      expect(find.text('222222'), findsOneWidget);
      expect(find.text('María Pérez · Trabajador'), findsOneWidget);
      expect(find.textContaining('Vence en'), findsNWidgets(2));

      // Alguien más pide un código: aparece sin recargar.
      items = [
        _code(phone: '+59170000003', code: '333333', name: 'Juan'),
        ...items,
      ];
      await tester.pump(otpCodesRefreshForTest);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('333333'), findsOneWidget);
      expect(find.text('Juan · Empleador'), findsOneWidget);
      expect(
        api.callsTo(#adminOtpCodesControllerList).length,
        greaterThanOrEqualTo(2),
      );
    },
  );

  testWidgets('con SMS real (o en producción) avisa que no se muestran', (
    tester,
  ) async {
    final api = FakeApi()
      ..on(
        #adminOtpCodesControllerList,
        (_) async => ok(OtpCodesDto(enabled: false, items: [])),
      );
    await pumpAdmin(tester, api: api, location: '/codigos');
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('otp-codes-disabled')), findsOneWidget);
  });
}

/// El intervalo de la pantalla (3 s) más un margen.
const otpCodesRefreshForTest = Duration(seconds: 3, milliseconds: 50);

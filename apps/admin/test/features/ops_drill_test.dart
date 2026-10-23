import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_admin/features/settings/ops_drill.dart';

import '../helpers/fakes.dart';

DioException _status(int code) {
  final options = RequestOptions(path: '/admin/ops/drill-500');
  return DioException(
    requestOptions: options,
    response: Response<void>(requestOptions: options, statusCode: code),
    type: DioExceptionType.badResponse,
  );
}

void main() {
  testWidgets(
    'el simulacro provoca el 5xx de prueba y avisa que se revise Sentry',
    (tester) async {
      var calls = 0;
      await pumpAdmin(
        tester,
        api: FakeApi(),
        location: '/configuracion/simulacro',
        overrides: [
          opsDrillProvider.overrideWithValue(() async {
            calls++;
            throw _status(500);
          }),
        ],
      );
      expect(find.text('Simulacro de alertas'), findsOneWidget);
      await tester.tap(find.byKey(const Key('ops-drill-500')));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.textContaining('Revisa Sentry'), findsOneWidget);
    },
  );

  testWidgets('si la API no devuelve el 5xx, lo dice', (tester) async {
    await pumpAdmin(
      tester,
      api: FakeApi(),
      location: '/configuracion/simulacro',
      overrides: [opsDrillProvider.overrideWithValue(() async {})],
    );
    await tester.tap(find.byKey(const Key('ops-drill-500')));
    await tester.pumpAndSettle();
    expect(find.text('La API no devolvió el error esperado.'), findsOneWidget);
  });
}

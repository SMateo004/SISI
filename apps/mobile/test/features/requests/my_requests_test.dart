import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/features/requests/domain/service_request.dart';
import 'package:sisi_mobile/shared/money.dart';

import '../../helpers/fakes.dart';

Future<void> _openList(
  WidgetTester tester,
  FakeRequestsRepository requests,
) async {
  await pumpSisiApp(tester, storedTokens: testTokens, requests: requests);
  await tester.tap(find.text('Mis solicitudes'));
  await tester.pumpAndSettle();
}

void main() {
  test('montos en Bs con coma decimal y en centavos', () {
    expect(formatBs('150.00'), 'Bs 150,00');
    expect(formatBs('19.5'), 'Bs 19,50');
    expect(parseBsCents('150'), 15000);
    expect(parseBsCents('150,5'), 15050);
    expect(parseBsCents('1.234'), isNull);
    expect(parseBsCents('-5'), isNull);
    expect(centsToApi(15050), '150.50');
  });

  testWidgets('lista vacía', (tester) async {
    await _openList(tester, FakeRequestsRepository());
    expect(find.text('Todavía no pediste ningún servicio.'), findsOneWidget);
  });

  testWidgets('lista con estado, precio y categoría', (tester) async {
    await _openList(
      tester,
      FakeRequestsRepository(
        mine: [
          testRequest(id: 'a'),
          testRequest(
            id: 'b',
            status: RequestStatus.retenida,
            statusMessage: 'Recibimos tu solicitud.',
          ),
          testRequest(id: 'c', status: RequestStatus.cancelada),
        ],
      ),
    );
    expect(find.text('Buscando trabajador'), findsOneWidget);
    expect(find.text('En revisión'), findsOneWidget);
    expect(find.text('Cancelada'), findsOneWidget);
    expect(find.textContaining('Bs 150,00'), findsNWidgets(3));
    expect(find.byIcon(Icons.plumbing), findsNWidgets(3));
  });

  testWidgets('cancela desde el detalle con confirmación', (tester) async {
    final requests = FakeRequestsRepository(mine: [testRequest(id: 'a')]);
    await _openList(tester, requests);

    await tester.tap(find.byKey(const Key('request-a')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cancel-request')), findsOneWidget);

    await tester.tap(find.byKey(const Key('cancel-request')));
    await tester.pumpAndSettle();
    expect(find.text('¿Cancelar la solicitud?'), findsOneWidget);
    await tester.tap(find.text('Sí, cancelar'));
    await tester.pumpAndSettle();

    expect(requests.cancelled, ['a']);
    expect(find.text('Cancelaste esta solicitud.'), findsOneWidget);
    // Ya no se puede cancelar de nuevo.
    expect(find.byKey(const Key('cancel-request')), findsNothing);
  });

  testWidgets('una asignada no muestra la opción de cancelar (R3.4)', (
    tester,
  ) async {
    final requests = FakeRequestsRepository(
      mine: [testRequest(id: 'a', status: RequestStatus.asignada)],
    );
    await _openList(tester, requests);
    await tester.tap(find.byKey(const Key('request-a')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cancel-request')), findsNothing);
  });
}

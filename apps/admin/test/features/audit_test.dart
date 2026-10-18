import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  testWidgets('la auditoría filtra por acción y muestra antes y después', (
    tester,
  ) async {
    final api = FakeApi()
      ..on(
        #adminAuditControllerList,
        (_) async => ok(AuditPageDto(items: [auditEntry()], nextCursor: null)),
      );
    await pumpAdmin(tester, api: api, location: '/auditoria');
    await tester.enterText(find.byKey(const Key('audit-action')), 'billing.');
    await tester.tap(find.byKey(const Key('audit-apply')));
    await tester.pumpAndSettle();
    expect(api.callsTo(#adminAuditControllerList).last[#action], 'billing.');
    await tester.tap(find.text('billing.payment'));
    await tester.pumpAndSettle();
    expect(find.textContaining('"balanceBs": "29.90"'), findsOneWidget);
    expect(find.textContaining('"balanceBs": "0.00"'), findsOneWidget);
  });
}

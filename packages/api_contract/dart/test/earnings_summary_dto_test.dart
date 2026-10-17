import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for EarningsSummaryDto
void main() {
  final EarningsSummaryDto? instance = /* EarningsSummaryDto(...) */ null;
  // TODO add properties to the entity

  group(EarningsSummaryDto, () {
    // CurrentPeriodDto currentPeriod
    test('to test the property `currentPeriod`', () async {
      // TODO
    });

    // Saldo pendiente total = suma del ledger, periodo abierto incluido. Negativo = saldo a favor. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String balanceBs
    test('to test the property `balanceBs`', () async {
      // TODO
    });

    // Periodos cerrados impagos (\"para ponerte al día\"). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String overdueOrPendingBs
    test('to test the property `overdueOrPendingBs`', () async {
      // TODO
    });

    // Próxima fecha límite con deuda
    // DateTime nextDueAt
    test('to test the property `nextDueAt`', () async {
      // TODO
    });

    // Tiene algún periodo vencido
    // bool overdue
    test('to test the property `overdue`', () async {
      // TODO
    });

    // Modo trabajador bloqueado por deuda (R7.7)
    // bool blocked
    test('to test the property `blocked`', () async {
      // TODO
    });

    // DebtCapStateDto debtCap
    test('to test the property `debtCap`', () async {
      // TODO
    });

  });
}

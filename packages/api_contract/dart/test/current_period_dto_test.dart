import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for CurrentPeriodDto
void main() {
  final CurrentPeriodDto? instance = /* CurrentPeriodDto(...) */ null;
  // TODO add properties to the entity

  group(CurrentPeriodDto, () {
    // null si todavía no hay trabajos esta semana
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // DateTime startAt
    test('to test the property `startAt`', () async {
      // TODO
    });

    // DateTime endAt
    test('to test the property `endAt`', () async {
      // TODO
    });

    // Vencimiento de este periodo (miércoles 23:59 siguiente)
    // DateTime dueAt
    test('to test the property `dueAt`', () async {
      // TODO
    });

    // Ganado en el periodo (bruto, R8.1). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String grossBs
    test('to test the property `grossBs`', () async {
      // TODO
    });

    // Comisión del periodo. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String commissionBs
    test('to test the property `commissionBs`', () async {
      // TODO
    });

    // Neto del periodo: bruto − comisión. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String netBs
    test('to test the property `netBs`', () async {
      // TODO
    });

    // String paymentReference
    test('to test the property `paymentReference`', () async {
      // TODO
    });

  });
}

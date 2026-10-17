import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for DebtCapStateDto
void main() {
  final DebtCapStateDto? instance = /* DebtCapStateDto(...) */ null;
  // TODO add properties to the entity

  group(DebtCapStateDto, () {
    // Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String capBs
    test('to test the property `capBs`', () async {
      // TODO
    });

    // El saldo supera el tope: no recibe solicitudes nuevas (R7.5)
    // bool reached
    test('to test the property `reached`', () async {
      // TODO
    });

    // Lo que hay que pagar para volver a recibir solicitudes (0 si no está sobre el tope). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String amountToUnlockBs
    test('to test the property `amountToUnlockBs`', () async {
      // TODO
    });

  });
}

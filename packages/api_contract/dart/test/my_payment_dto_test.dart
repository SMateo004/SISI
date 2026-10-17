import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for MyPaymentDto
void main() {
  final MyPaymentDto? instance = /* MyPaymentDto(...) */ null;
  // TODO add properties to the entity

  group(MyPaymentDto, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String amountBs
    test('to test the property `amountBs`', () async {
      // TODO
    });

    // DateTime paidAt
    test('to test the property `paidAt`', () async {
      // TODO
    });

    // String method
    test('to test the property `method`', () async {
      // TODO
    });

    // Un pago del historial ya está registrado; los comprobantes en revisión están en /me/billing/submissions
    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // String reference
    test('to test the property `reference`', () async {
      // TODO
    });

    // Periodos que cubrió
    // List<PaymentAllocationDto> periods
    test('to test the property `periods`', () async {
      // TODO
    });

    // Enlace temporal al comprobante (R8.2)
    // String receiptUrl
    test('to test the property `receiptUrl`', () async {
      // TODO
    });

  });
}

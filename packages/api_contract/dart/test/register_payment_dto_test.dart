import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for RegisterPaymentDto
void main() {
  final RegisterPaymentDto? instance = /* RegisterPaymentDto(...) */ null;
  // TODO add properties to the entity

  group(RegisterPaymentDto, () {
    // String workerId
    test('to test the property `workerId`', () async {
      // TODO
    });

    // Monto pagado en Bs (texto, 2 decimales)
    // String amountBs
    test('to test the property `amountBs`', () async {
      // TODO
    });

    // String method
    test('to test the property `method`', () async {
      // TODO
    });

    // Cuándo pagó (no futuro)
    // DateTime paidAt
    test('to test the property `paidAt`', () async {
      // TODO
    });

    // String reference
    test('to test the property `reference`', () async {
      // TODO
    });

    // Clave del comprobante subido (receipts/{worker}/…)
    // String receiptKey
    test('to test the property `receiptKey`', () async {
      // TODO
    });

    // Comprobante enviado por el trabajador que se está registrando
    // String submissionId
    test('to test the property `submissionId`', () async {
      // TODO
    });

    // Número de factura (sin uso hasta la revisión tributaria)
    // String invoiceNumber
    test('to test the property `invoiceNumber`', () async {
      // TODO
    });

  });
}

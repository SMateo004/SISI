import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for PayInfoDto
void main() {
  final PayInfoDto? instance = /* PayInfoDto(...) */ null;
  // TODO add properties to the entity

  group(PayInfoDto, () {
    // URL temporal del QR de la empresa (null si no está cargado)
    // String qrUrl
    test('to test the property `qrUrl`', () async {
      // TODO
    });

    // \"Para ponerte al día\": periodos cerrados impagos. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String catchUpAmountBs
    test('to test the property `catchUpAmountBs`', () async {
      // TODO
    });

    // \"Para volver a recibir solicitudes\": lo que deja el saldo en el tope (0 si no está sobre el tope). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String unlockAmountBs
    test('to test the property `unlockAmountBs`', () async {
      // TODO
    });

    // Saldo total, periodo abierto incluido (pago anticipado). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
    // String totalBalanceBs
    test('to test the property `totalBalanceBs`', () async {
      // TODO
    });

    // Para la glosa: la del periodo más antiguo con deuda
    // String paymentReference
    test('to test the property `paymentReference`', () async {
      // TODO
    });

    // DateTime dueAt
    test('to test the property `dueAt`', () async {
      // TODO
    });

    // Pasos en español
    // List<String> instructions
    test('to test the property `instructions`', () async {
      // TODO
    });

    // Pago en línea (pasarela) disponible; hoy siempre false
    // bool gatewayEnabled
    test('to test the property `gatewayEnabled`', () async {
      // TODO
    });

  });
}

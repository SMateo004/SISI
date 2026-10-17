import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for GananciasApi
void main() {
  final instance = SisiApi().getGananciasApi();

  group(GananciasApi, () {
    // URL para subir la foto de mi comprobante de pago
    //
    //Future<PresignedUploadDto> billingMeControllerSubmissionUploadUrl(FileUploadDto fileUploadDto) async
    test('test billingMeControllerSubmissionUploadUrl', () async {
      // TODO
    });

    // Mis comprobantes enviados y su estado
    //
    //Future<List<PaymentSubmissionDto>> billingMeControllerSubmissions() async
    test('test billingMeControllerSubmissions', () async {
      // TODO
    });

    // Enviar mi comprobante de pago (propuesta)
    //
    // Queda \"enviado, pendiente de verificación\". No cambia la deuda hasta que SISI registra el pago.
    //
    //Future<PaymentSubmissionDto> billingMeControllerSubmit(CreateSubmissionDto createSubmissionDto) async
    test('test billingMeControllerSubmit', () async {
      // TODO
    });

    // Datos para pagar la comisión (R7.4)
    //
    // QR de la empresa, monto para ponerte al día, monto para volver a recibir solicitudes (si el tope está alcanzado), referencia para la glosa e instrucciones.
    //
    //Future<PayInfoDto> earningsControllerPayInfo() async
    test('test earningsControllerPayInfo', () async {
      // TODO
    });

    // Historial de pagos (R8.2)
    //
    // Periodos cubiertos, monto, fecha, estado y enlace temporal al comprobante.
    //
    //Future<PaymentPageDto> earningsControllerPayments({ String cursor }) async
    test('test earningsControllerPayments', () async {
      // TODO
    });

    // Historial de periodos (cortes semanales)
    //
    //Future<PeriodPageDto> earningsControllerPeriods({ String cursor }) async
    test('test earningsControllerPeriods', () async {
      // TODO
    });

    // Resumen de ganancias (R8.1)
    //
    // Periodo actual (bruto, comisión, neto), saldo pendiente total, próxima fecha límite y estado del tope.
    //
    //Future<EarningsSummaryDto> earningsControllerSummary() async
    test('test earningsControllerSummary', () async {
      // TODO
    });

  });
}

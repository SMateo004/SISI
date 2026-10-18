import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for LegalApi
void main() {
  final instance = SisiApi().getLegalApi();

  group(LegalApi, () {
    // Aceptar las versiones vigentes y declarar la mayoría de edad
    //
    // Queda registrado con versión y fecha. Una versión nueva vuelve a pedirlo.
    //
    //Future<LegalPendingDto> legalControllerAccept(AcceptLegalDto acceptLegalDto) async
    test('test legalControllerAccept', () async {
      // TODO
    });

    // Términos de uso y política de privacidad vigentes (ADR-0051)
    //
    //Future<List<LegalDocumentDto>> legalControllerCurrent() async
    test('test legalControllerCurrent', () async {
      // TODO
    });

  });
}

import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for AdminApi
void main() {
  final instance = SisiApi().getAdminApi();

  group(AdminApi, () {
    // Enlace temporal a un documento de identidad (R9.5)
    //
    // Válido 5 minutos. Solo administradores.
    //
    //Future<DocumentUrlDto> adminWorkersControllerDocumentUrl(String userId, String documentId) async
    test('test adminWorkersControllerDocumentUrl', () async {
      // TODO
    });

  });
}

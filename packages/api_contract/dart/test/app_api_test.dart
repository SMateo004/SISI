import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for AppApi
void main() {
  final instance = SisiApi().getAppApi();

  group(AppApi, () {
    // Configuración de la app al abrirla
    //
    // Versión mínima por plataforma (si la instalada es menor, upgradeRequired y la tienda), WhatsApp de soporte y versiones legales vigentes.
    //
    //Future<AppConfigDto> clientAppControllerConfig(String platform, { String version }) async
    test('test clientAppControllerConfig', () async {
      // TODO
    });

  });
}

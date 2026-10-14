import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for MapsApi
void main() {
  final instance = SisiApi().getMapsApi();

  group(MapsApi, () {
    // Dirección sugerida para unas coordenadas
    //
    // La geocodificación se hace en el backend: la llave de Maps nunca llega a la app.
    //
    //Future<ReverseGeocodeDto> geocodingControllerReverse(num lat, num lng) async
    test('test geocodingControllerReverse', () async {
      // TODO
    });

  });
}

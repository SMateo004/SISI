import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for HealthApi
void main() {
  final instance = SisiApi().getHealthApi();

  group(HealthApi, () {
    // Estado de la API, la base de datos (con PostGIS) y Redis
    //
    //Future<HealthResponseDto> healthControllerCheck() async
    test('test healthControllerCheck', () async {
      // TODO
    });

  });
}

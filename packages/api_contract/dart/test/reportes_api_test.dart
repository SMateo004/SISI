import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for ReportesApi
void main() {
  final instance = SisiApi().getReportesApi();

  group(ReportesApi, () {
    // Reportar una solicitud, un perfil, un mensaje o un trabajo
    //
    // Solo algo con lo que tuviste relación. Un reporte por objetivo. Un mensaje reportado deja de mostrarse para quien lo reportó.
    //
    //Future<ReportDto> reportsControllerCreate(CreateReportDto createReportDto) async
    test('test reportsControllerCreate', () async {
      // TODO
    });

    // Mis reportes y su estado
    //
    //Future<List<ReportDto>> reportsControllerMine() async
    test('test reportsControllerMine', () async {
      // TODO
    });

  });
}

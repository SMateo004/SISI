import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for PilotApi
void main() {
  final instance = SisiApi().getPilotApi();

  group(PilotApi, () {
    // \"Pronto en tu zona\": dejar el interés (ADR-0052)
    //
    // Para quien todavía no puede crear su cuenta en el piloto. Mide la demanda.
    //
    //Future pilotControllerInterest(PilotInterestDto pilotInterestDto) async
    test('test pilotControllerInterest', () async {
      // TODO
    });

  });
}

import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for AvailabilityDto
void main() {
  final AvailabilityDto? instance = /* AvailabilityDto(...) */ null;
  // TODO add properties to the entity

  group(AvailabilityDto, () {
    // bool available
    test('to test the property `available`', () async {
      // TODO
    });

    // DateTime availableSince
    test('to test the property `availableSince`', () async {
      // TODO
    });

    // Última ubicación recibida por la API
    // DateTime locatedAt
    test('to test the property `locatedAt`', () async {
      // TODO
    });

    // Cada cuántos segundos debe la app enviar la ubicación mientras está disponible (en primer plano)
    // num sendEverySec
    test('to test the property `sendEverySec`', () async {
      // TODO
    });

    // Sin ubicación en este tiempo, deja de estar disponible
    // num staleAfterSec
    test('to test the property `staleAfterSec`', () async {
      // TODO
    });

  });
}

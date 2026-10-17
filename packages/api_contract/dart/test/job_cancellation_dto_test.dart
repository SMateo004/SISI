import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';

// tests for JobCancellationDto
void main() {
  final JobCancellationDto? instance = /* JobCancellationDto(...) */ null;
  // TODO add properties to the entity

  group(JobCancellationDto, () {
    // Quién canceló
    // String by
    test('to test the property `by`', () async {
      // TODO
    });

    // String reason
    test('to test the property `reason`', () async {
      // TODO
    });

    // Nota de quien canceló. Si la moderación la retuvo, solo la ve quien la escribió.
    // String note
    test('to test the property `note`', () async {
      // TODO
    });

    // La nota quedó retenida por moderación (solo para quien la escribió)
    // bool noteHeld
    test('to test the property `noteHeld`', () async {
      // TODO
    });

  });
}

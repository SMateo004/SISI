import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_admin/features/health/data/health_repository.dart';

void main() {
  test('HealthStatus.fromJson interpreta la respuesta de /health', () {
    final status = HealthStatus.fromJson({
      'status': 'error',
      'checks': {
        'database': {'status': 'up'},
        'postgis': {'status': 'up', 'version': '3.5.2'},
        'redis': {'status': 'down'},
      },
    });

    expect(status.ok, isFalse);
    expect(status.database, isTrue);
    expect(status.postgis, isTrue);
    expect(status.postgisVersion, '3.5.2');
    expect(status.redis, isFalse);
  });

  test('HealthStatus.fromJson tolera respuestas incompletas', () {
    final status = HealthStatus.fromJson({});
    expect(status.ok, isFalse);
    expect(status.database, isFalse);
  });
}

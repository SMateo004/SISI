import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/features/health/data/health_repository.dart';
import 'package:sisi_mobile/features/health/presentation/health_screen.dart';

class _FakeHealthRepository implements HealthRepository {
  _FakeHealthRepository(this._result);

  final Future<HealthStatus> Function() _result;

  @override
  Future<HealthStatus> fetch() => _result();
}

Future<void> _pump(WidgetTester tester, HealthRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [healthRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: HealthScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('muestra "Conectado" cuando la API responde ok', (tester) async {
    await _pump(
      tester,
      _FakeHealthRepository(
        () async => const HealthStatus(
          ok: true,
          database: true,
          postgis: true,
          redis: true,
          postgisVersion: '3.5.2',
        ),
      ),
    );
    expect(find.text('Conectado'), findsOneWidget);
    expect(find.text('PostGIS 3.5.2'), findsOneWidget);
    expect(find.text('Operativo'), findsNWidgets(3));
  });

  testWidgets('muestra "Servicio con problemas" si un componente cae', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeHealthRepository(
        () async => const HealthStatus(
          ok: false,
          database: true,
          postgis: true,
          redis: false,
        ),
      ),
    );
    expect(find.text('Servicio con problemas'), findsOneWidget);
    expect(find.text('Caído'), findsOneWidget);
  });

  testWidgets('muestra "Sin conexión" y permite reintentar', (tester) async {
    var calls = 0;
    await _pump(
      tester,
      _FakeHealthRepository(() async {
        calls++;
        throw DioException(requestOptions: RequestOptions(path: '/health'));
      }),
    );
    expect(find.text('Sin conexión'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(calls, 2);
  });
}

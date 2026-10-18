import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/features/worker_onboarding/application/onboarding_draft.dart';
import 'package:sisi_mobile/features/worker_onboarding/domain/worker_models.dart';
import 'package:sisi_mobile/shared/money.dart';

import '../../helpers/fakes.dart';

const plomeria = Category(
  id: 'c1',
  name: 'Plomería',
  priceMinBs: '80.00',
  priceMaxBs: '250.00',
);

Finder get _next => find.byKey(const Key('onboarding-next'));

bool _enabled(WidgetTester tester) =>
    tester.widget<FilledButton>(_next).onPressed != null;

Future<void> _openFlow(WidgetTester tester, FakeWorkerRepository worker) async {
  await pumpSisiApp(tester, storedTokens: testTokens, worker: worker);
  await tester.tap(find.text('¿Quieres trabajar en SISI?'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Completa tu verificación'));
  await tester.pumpAndSettle();
}

Future<void> _pickBirthDate(WidgetTester tester, String typed) async {
  await tester.tap(find.byKey(const Key('birth-date-button')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).last, typed);
  await tester.tap(find.text('ACEPTAR'));
  await tester.pumpAndSettle();
}

Future<void> _uploadAllDocuments(WidgetTester tester) async {
  for (final type in DocumentType.values) {
    await tester.tap(find.byKey(Key('document-${type.apiValue}')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elegir de la galería'));
    await tester.pumpAndSettle();
  }
}

void main() {
  test('formatBs usa coma decimal', () {
    expect(formatBs('80.00'), 'Bs 80,00');
    expect(formatBs('19.50'), 'Bs 19,50');
  });

  test('ageOn respeta el día del cumpleaños', () {
    final birth = DateTime(2008, 10, 15);
    expect(ageOn(birth, DateTime(2026, 10, 14)), 17);
    expect(ageOn(birth, DateTime(2026, 10, 15)), 18);
  });

  testWidgets('recorre los 5 pasos, envía y muestra el estado de revisión', (
    tester,
  ) async {
    final worker = FakeWorkerRepository(categories: [plomeria]);
    await _openFlow(tester, worker);

    // Paso 1: fecha de nacimiento.
    expect(find.text('Tus datos'), findsOneWidget);
    expect(find.text('Paso 1 de 5'), findsOneWidget);
    expect(_enabled(tester), isFalse);
    await _pickBirthDate(tester, '21/04/1995');
    expect(find.text('Nací el 21/04/1995'), findsOneWidget);
    expect(_enabled(tester), isTrue);
    await tester.tap(_next);
    await tester.pumpAndSettle();

    // Paso 2: documentos (cámara o galería).
    expect(find.text('Carnet y selfie'), findsOneWidget);
    expect(_enabled(tester), isFalse);
    await _uploadAllDocuments(tester);
    expect(find.text('Foto subida'), findsNWidgets(3));
    expect(_enabled(tester), isTrue);
    await tester.tap(_next);
    await tester.pumpAndSettle();

    // Paso 3: categorías.
    expect(find.text('Categorías'), findsOneWidget);
    expect(_enabled(tester), isFalse);
    await tester.tap(find.text('Plomería'));
    await tester.pumpAndSettle();
    expect(_enabled(tester), isTrue);
    await tester.tap(_next);
    await tester.pumpAndSettle();

    // Paso 4: transporte y radio.
    expect(find.text('Transporte y radio'), findsOneWidget);
    expect(_enabled(tester), isFalse);
    await tester.tap(find.text('Moto'));
    await tester.pumpAndSettle();
    expect(find.textContaining('5 km'), findsOneWidget);
    await tester.tap(_next);
    await tester.pumpAndSettle();

    // Paso 5: resumen y envío.
    expect(find.text('Resumen'), findsOneWidget);
    expect(find.text('21/04/1995'), findsOneWidget);
    expect(find.text('Plomería'), findsOneWidget);
    await tester.tap(find.text('Enviar solicitud'));
    await tester.pumpAndSettle();

    expect(worker.submitted, {
      'birthDate': '1995-04-21',
      'categoryIds': ['c1'],
      'transport': TransportMode.moto,
      'maxRadiusKm': 5,
    });
    expect(find.text('Tu solicitud está en revisión'), findsOneWidget);
    // Se llegó con go(): hay un botón para volver al inicio.
    await tester.tap(find.byTooltip('Ir al inicio'));
    await tester.pumpAndSettle();
    expect(find.text('¿Quieres trabajar en SISI?'), findsOneWidget);
  });

  testWidgets('Atrás vuelve al paso anterior conservando los datos', (
    tester,
  ) async {
    await _openFlow(tester, FakeWorkerRepository());
    await _pickBirthDate(tester, '21/04/1995');
    await tester.tap(_next);
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 5'), findsOneWidget);
    await tester.tap(find.text('Atrás'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 5'), findsOneWidget);
    expect(find.text('Nací el 21/04/1995'), findsOneWidget);
  });

  testWidgets('menor de 18 años no puede avanzar', (tester) async {
    await _openFlow(tester, FakeWorkerRepository());
    final year = DateTime.now().year - 17;
    await _pickBirthDate(tester, '01/01/$year');
    expect(
      find.text('Debes tener al menos 18 años para trabajar en SISI.'),
      findsOneWidget,
    );
    expect(_enabled(tester), isFalse);
  });

  testWidgets('sin categorías muestra un estado vacío claro', (tester) async {
    await _openFlow(tester, FakeWorkerRepository());
    await _pickBirthDate(tester, '21/04/1995');
    await tester.tap(_next);
    await tester.pumpAndSettle();
    await _uploadAllDocuments(tester);
    await tester.tap(_next);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('categories-empty')), findsOneWidget);
    expect(find.text('Todavía no hay categorías disponibles'), findsOneWidget);
    expect(_enabled(tester), isFalse);
  });

  testWidgets('rechazado: muestra el motivo y permite reenviar', (
    tester,
  ) async {
    final worker = FakeWorkerRepository(
      profile: const WorkerProfile(
        status: WorkerStatus.rechazado,
        rejectionReason: 'La foto del carnet está borrosa',
        documents: [],
        missingDocuments: DocumentType.values,
        editable: true,
      ),
    );
    await pumpSisiApp(tester, storedTokens: testTokens, worker: worker);
    await tester.tap(find.text('¿Quieres trabajar en SISI?'));
    await tester.pumpAndSettle();
    expect(find.text('Tu solicitud fue rechazada'), findsOneWidget);
    expect(
      find.text('Motivo: La foto del carnet está borrosa'),
      findsOneWidget,
    );
    await tester.tap(find.text('Corregir y reenviar'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 5'), findsOneWidget);
  });

  testWidgets(
    'sin nombre pide completar el perfil antes de la solicitud (R1.3)',
    (tester) async {
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        me: FakeMeRepository(user: testUser(name: null)),
        worker: FakeWorkerRepository(),
      );
      await tester.tap(find.text('¿Quieres trabajar en SISI?'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Completa tu verificación'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('onboarding-name-required')), findsOneWidget);
      await tester.tap(find.text('Completar mi perfil'));
      await tester.pumpAndSettle();
      expect(find.text('Mi perfil'), findsOneWidget);
    },
  );
}

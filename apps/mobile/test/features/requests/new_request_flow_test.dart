import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';

import '../../helpers/fakes.dart';

Finder get _next => find.byKey(const Key('request-next'));

bool _enabled(WidgetTester tester) =>
    tester.widget<FilledButton>(_next).onPressed != null;

Future<void> _tapNext(WidgetTester tester) async {
  await tester.tap(_next);
  await tester.pumpAndSettle();
}

Future<void> _fillUntilPrice(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('new-request')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('category-plomeria')));
  await tester.pumpAndSettle();
  await _tapNext(tester);
  await tester.enterText(
    find.byKey(const Key('description-field')),
    'Tengo una fuga debajo del lavaplatos de la cocina.',
  );
  await tester.pumpAndSettle();
  await _tapNext(tester);
  // Espera la dirección sugerida (debounce + geocodificación falsa).
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
  await _tapNext(tester);
}

void main() {
  testWidgets('"Pedir un servicio" aparece en modo empleador', (tester) async {
    await pumpSisiApp(tester, storedTokens: testTokens);
    expect(find.byKey(const Key('new-request')), findsOneWidget);
    expect(find.text('Mis solicitudes'), findsOneWidget);
  });

  testWidgets('en modo trabajador no se puede pedir un servicio', (
    tester,
  ) async {
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      me: FakeMeRepository(user: testUser(mode: ActiveMode.worker)),
    );
    expect(find.byKey(const Key('new-request')), findsNothing);
    expect(find.text('Mis solicitudes'), findsNothing);
  });

  testWidgets(
    'publica: categoría, descripción con foto, mapa, precio, resumen',
    (tester) async {
      final requests = FakeRequestsRepository();
      await pumpSisiApp(tester, storedTokens: testTokens, requests: requests);

      await tester.tap(find.byKey(const Key('new-request')));
      await tester.pumpAndSettle();

      // 1. Categoría: solo las de la API, con ícono.
      expect(find.text('Plomería'), findsOneWidget);
      expect(find.text('Electricidad'), findsOneWidget);
      expect(find.byIcon(Icons.plumbing), findsOneWidget);
      expect(_enabled(tester), isFalse);
      await tester.tap(find.byKey(const Key('category-plomeria')));
      await tester.pumpAndSettle();
      await _tapNext(tester);

      // 2. Descripción (mínimo 20 caracteres) y foto.
      await tester.enterText(
        find.byKey(const Key('description-field')),
        'Fuga',
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('te faltan 16'), findsOneWidget);
      expect(_enabled(tester), isFalse);
      await tester.enterText(
        find.byKey(const Key('description-field')),
        'Tengo una fuga debajo del lavaplatos de la cocina.',
      );
      await tester.tap(find.byKey(const Key('add-photo')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Elegir de la galería'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Quitar foto'), findsOneWidget);
      await _tapNext(tester);

      // 3. Mapa con la dirección sugerida (editable).
      expect(find.byKey(const Key('placeholder-map')), findsOneWidget);
      // El mapa ocupa todo el ancho (no solo el del pin).
      expect(
        tester.getSize(find.byKey(const Key('placeholder-map'))).width,
        greaterThan(300),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(
        find.text('Calle sugerida 123, Santa Cruz de la Sierra'),
        findsOneWidget,
      );
      await tester.enterText(
        find.byKey(const Key('address-field')),
        'Calle Junín 150, portón verde',
      );
      await tester.pumpAndSettle();
      await _tapNext(tester);

      // 4. Precio.
      expect(find.text('Bs 80,00 a Bs 300,00'), findsOneWidget);
      expect(find.byKey(const Key('transport-notice')), findsOneWidget);
      await tester.enterText(find.byKey(const Key('price-field')), '150');
      await tester.pumpAndSettle();
      await _tapNext(tester);

      // 5. Resumen y publicar.
      expect(find.text('Bs 150,00'), findsOneWidget);
      expect(find.text('Calle Junín 150, portón verde'), findsOneWidget);
      await tester.tap(find.text('Publicar'));
      await tester.pumpAndSettle();

      expect(requests.created?.categoryId, 'c-plomeria');
      expect(requests.created?.proposedPriceBs, '150.00');
      expect(requests.created?.address, 'Calle Junín 150, portón verde');
      expect(requests.uploadedPhotos, 1);
      expect(
        find.text('¡Listo! Estamos buscando trabajadores cerca de ti.'),
        findsOneWidget,
      );
      expect(find.text('Buscando trabajador'), findsOneWidget);
    },
  );

  testWidgets('advierte si el precio está bajo el mínimo, pero deja seguir', (
    tester,
  ) async {
    await pumpSisiApp(tester, storedTokens: testTokens);
    await _fillUntilPrice(tester);

    await tester.enterText(find.byKey(const Key('price-field')), '50');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('price-warning')), findsOneWidget);
    expect(find.textContaining('(Bs 80,00)'), findsOneWidget);
    expect(_enabled(tester), isTrue);

    await tester.enterText(find.byKey(const Key('price-field')), '80,00');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('price-warning')), findsNothing);

    await tester.enterText(find.byKey(const Key('price-field')), '0');
    await tester.pumpAndSettle();
    expect(_enabled(tester), isFalse);
  });

  testWidgets('si queda en revisión muestra un mensaje neutral', (
    tester,
  ) async {
    final requests = FakeRequestsRepository(held: true);
    await pumpSisiApp(tester, storedTokens: testTokens, requests: requests);
    await _fillUntilPrice(tester);
    await tester.enterText(find.byKey(const Key('price-field')), '150');
    await tester.pumpAndSettle();
    await _tapNext(tester);
    await tester.tap(find.text('Publicar'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Recibimos tu solicitud. La estamos revisando y te avisaremos cuando se publique.',
      ),
      findsWidgets,
    );
    expect(find.text('En revisión'), findsOneWidget);
  });
}

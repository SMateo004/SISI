import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/realtime/realtime_client.dart';
import 'package:sisi_mobile/features/offers/domain/offer_models.dart';
import 'package:sisi_mobile/features/requests/domain/service_request.dart';

import '../../helpers/fake_jobs.dart';
import '../../helpers/fake_matching.dart';
import '../../helpers/fake_realtime.dart';
import '../../helpers/fakes.dart';

/// Abre el detalle de la solicitud desde "Mis solicitudes".
Future<void> _openDetail(
  WidgetTester tester, {
  required ServiceRequest request,
  FakeOffersRepository? offers,
  FakeRealtimeClient? realtime,
  FakeRequestsRepository? requests,
}) async {
  await pumpSisiApp(
    tester,
    storedTokens: testTokens,
    requests: requests ?? FakeRequestsRepository(mine: [request]),
    offers: offers,
    realtime: realtime,
    jobs: FakeJobsRepository(jobs: [testJob(myRole: 'employer')]),
  );
  await tester.tap(find.text('Mis solicitudes'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('request-${request.id}')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    '"Buscando trabajador": muestra el anillo y las ofertas llegan en vivo',
    (tester) async {
      final offers = FakeOffersRepository();
      final realtime = FakeRealtimeClient();
      await _openDetail(
        tester,
        request: testRequest(id: 'a', ring: 1),
        offers: offers,
        realtime: realtime,
      );
      expect(
        find.text('Avisamos a trabajadores cercanos · anillo 1 de 3'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('offers-empty')), findsOneWidget);

      offers.offers = [
        testEmployerOffer(
          name: 'Ana R.',
          amountBs: '180.00',
          type: OfferType.counter,
        ),
      ];
      realtime.emit(RealtimeEvents.offerNew, {
        'requestId': 'a',
        'offerId': 'o1',
      });
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('offer-o1')), findsOneWidget);
      expect(find.text('Ana R.'), findsOneWidget);
      expect(find.text('Bs 180,00'), findsOneWidget);
      expect(find.text('★ 4,8 (25) · llega en ~12 min'), findsOneWidget);
      expect(find.text('Contraoferta'), findsOneWidget);
    },
  );

  testWidgets('un aviso de otra solicitud no recarga las ofertas', (
    tester,
  ) async {
    final offers = FakeOffersRepository();
    final realtime = FakeRealtimeClient();
    await _openDetail(
      tester,
      request: testRequest(id: 'a', ring: 1),
      offers: offers,
      realtime: realtime,
    );
    final before = offers.listOffersCalls;
    realtime.emit(RealtimeEvents.offerNew, {'requestId': 'otra'});
    await tester.pumpAndSettle();
    expect(offers.listOffersCalls, before);
  });

  testWidgets('"Elegir" pide confirmación y luego muestra el contacto', (
    tester,
  ) async {
    final offers = FakeOffersRepository(offers: [testEmployerOffer()]);
    await _openDetail(
      tester,
      request: testRequest(id: 'a', status: RequestStatus.conOfertas, ring: 2),
      offers: offers,
    );

    await tester.ensureVisible(find.byKey(const Key('choose-o1')));
    await tester.tap(find.byKey(const Key('choose-o1')));
    await tester.pumpAndSettle();
    expect(find.text('¿Elegir a Ana R.?'), findsOneWidget);
    expect(find.textContaining('Por Bs 150,00'), findsOneWidget);

    // Volver no elige.
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(offers.accepted, isEmpty);

    await tester.tap(find.byKey(const Key('choose-o1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-choose')));
    await tester.pumpAndSettle();

    expect(offers.accepted.single, ('a', 'o1'));
    // Lleva a la pantalla del trabajo, con el contacto del trabajador.
    expect(find.byKey(const Key('job-status')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('contact-phone')),
      200,
    );
    expect(find.text('+59171234567'), findsOneWidget);
  });

  testWidgets('asignada: acceso al contacto del trabajador', (tester) async {
    await _openDetail(
      tester,
      request: testRequest(
        id: 'a',
        status: RequestStatus.asignada,
        jobId: 'job-1',
      ),
    );
    await tester.ensureVisible(find.byKey(const Key('see-contact')));
    await tester.tap(find.byKey(const Key('see-contact')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('contact-phone')),
      200,
    );
    expect(find.text('Ana Rojas'), findsOneWidget);
  });

  testWidgets('expirada: "Volver a publicar" precarga los datos (sin fotos)', (
    tester,
  ) async {
    await _openDetail(
      tester,
      request: testRequest(
        id: 'a',
        status: RequestStatus.expirada,
        statusMessage: 'Nadie ofertó a tiempo. Puedes publicarla de nuevo.',
      ),
    );
    expect(find.byKey(const Key('expired-panel')), findsOneWidget);
    expect(find.byKey(const Key('searching-panel')), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('republish')));
    await tester.tap(find.byKey(const Key('republish')));
    await tester.pumpAndSettle();

    // Categoría ya elegida: se puede seguir.
    expect(find.text('Pedir un servicio'), findsOneWidget);
    await tester.tap(find.byKey(const Key('request-next')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(
      find.byKey(const Key('description-field')),
    );
    expect(
      field.controller?.text,
      'Tengo una fuga debajo del lavaplatos de la cocina.',
    );
  });
}

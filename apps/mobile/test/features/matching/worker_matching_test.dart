import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/realtime/realtime_client.dart';
import 'package:sisi_mobile/core/realtime/realtime_providers.dart';
import 'package:sisi_mobile/features/matching/data/location_service.dart';
import 'package:sisi_mobile/features/matching/presentation/incoming_request_card.dart';
import 'package:sisi_mobile/features/offers/data/offers_repository.dart';
import 'package:sisi_mobile/features/offers/domain/offer_models.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';

import 'package:sisi_mobile/features/reports/data/reports_repository.dart';

import '../../helpers/fake_jobs.dart';
import '../../helpers/fake_matching.dart';
import '../../helpers/fake_realtime.dart';
import '../../helpers/fakes.dart';

/// Monta solo la tarjeta (sin pumpAndSettle: la cuenta regresiva se actualiza cada segundo).
Future<FakeOffersRepository> _pumpCard(
  WidgetTester tester,
  IncomingRequest request,
) async {
  final offers = FakeOffersRepository(incoming: [request]);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        offersRepositoryProvider.overrideWithValue(offers),
        realtimeClientFactoryProvider.overrideWithValue(FakeRealtimeClient.new),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: IncomingRequestCard(request: request),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return offers;
}

Future<void> _pumpWorker(
  WidgetTester tester, {
  FakeOffersRepository? offers,
  FakeAvailabilityRepository? availability,
  FakeLocationService? location,
  FakeRealtimeClient? realtime,
  FakeJobsRepository? jobs,
}) => pumpSisiApp(
  tester,
  storedTokens: testTokens,
  me: FakeMeRepository(user: testUser(mode: ActiveMode.worker)),
  offers: offers,
  availability: availability,
  location: location,
  realtime: realtime,
  jobs: jobs,
);

void main() {
  group('Tarjeta de solicitud entrante (R5.1, R5.2)', () {
    testWidgets('muestra distancia, descripción, precio y cuenta regresiva', (
      tester,
    ) async {
      await _pumpCard(tester, testIncoming());
      expect(find.text('Plomería'), findsOneWidget);
      expect(find.text('a 850 m'), findsOneWidget);
      expect(find.textContaining('fuga debajo del lavaplatos'), findsOneWidget);
      expect(find.text('Bs 150,00'), findsOneWidget);
      expect(find.textContaining('Bs 80,00 a Bs 300,00'), findsOneWidget);
      expect(find.text('Responde en 0:45'), findsOneWidget);

      await tester.pump(const Duration(seconds: 10));
      expect(find.text('Responde en 0:35'), findsOneWidget);
      await tester.pump(const Duration(seconds: 40));
      expect(find.textContaining('Responde pronto'), findsOneWidget);
    });

    testWidgets('"Aceptar precio" envía la oferta y muestra "tu oferta"', (
      tester,
    ) async {
      final offers = await _pumpCard(tester, testIncoming());
      await tester.tap(find.byKey(const Key('accept-price')));
      await tester.pump();
      await tester.pump();
      expect(offers.sentOffers.single, ('r1', OfferType.accept, null));
      expect(find.textContaining('Aceptaste el precio'), findsOneWidget);
    });

    testWidgets('"Contraofertar" valida el monto y el tope antes de enviar', (
      tester,
    ) async {
      final offers = await _pumpCard(tester, testIncoming());
      await tester.tap(find.byKey(const Key('counter-offer')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('El cliente propone Bs 150,00.'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('counter-amount')), '1000');
      await tester.tap(find.byKey(const Key('counter-submit')));
      await tester.pump();
      expect(find.text('El máximo es Bs 900,00.'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('counter-amount')), '0');
      await tester.tap(find.byKey(const Key('counter-submit')));
      await tester.pump();
      expect(find.textContaining('mayor a 0'), findsOneWidget);
      expect(offers.sentOffers, isEmpty);

      await tester.enterText(find.byKey(const Key('counter-amount')), '180,50');
      await tester.tap(find.byKey(const Key('counter-submit')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(offers.sentOffers.single, ('r1', OfferType.counter, '180.50'));
    });

    testWidgets('con oferta enviada muestra su estado y se puede reemplazar', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        testIncoming(
          myOffer: const MyOffer(
            id: 'mine',
            type: OfferType.counter,
            amountBs: '180.00',
            etaMin: 12,
            status: 'activa',
            revision: 1,
          ),
        ),
      );
      expect(find.byKey(const Key('my-offer')), findsOneWidget);
      expect(find.textContaining('Tu oferta: Bs 180,00'), findsOneWidget);
      expect(find.textContaining('llegarías en 12 min'), findsOneWidget);
      expect(find.byKey(const Key('counter-offer')), findsOneWidget);
    });

    testWidgets('si eligieron a otro, lo avisa y ya no muestra acciones', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        testIncoming(outcome: IncomingOutcome.elegidaOtra),
      );
      expect(find.text('El cliente eligió a otro trabajador.'), findsOneWidget);
      expect(find.byKey(const Key('accept-price')), findsNothing);
      expect(find.byKey(const Key('countdown')), findsNothing);
    });
  });

  group('Modo trabajador', () {
    testWidgets('"Disponible" explica el uso de la ubicación y luego la pide', (
      tester,
    ) async {
      final availability = FakeAvailabilityRepository();
      final location = FakeLocationService();
      await _pumpWorker(tester, availability: availability, location: location);

      await tester.tap(find.byKey(const Key('availability-switch')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Solo la usamos mientras estás disponible'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('location-rationale-continue')));
      await tester.pumpAndSettle();

      expect(location.requests, 1);
      expect(availability.available, isTrue);
      expect(find.text('Disponible'), findsOneWidget);
    });

    testWidgets('sin permiso de ubicación no se activa y dice por qué', (
      tester,
    ) async {
      final availability = FakeAvailabilityRepository();
      await _pumpWorker(
        tester,
        availability: availability,
        location: FakeLocationService(access: LocationAccess.denied),
      );
      await tester.tap(find.byKey(const Key('availability-switch')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('location-rationale-continue')));
      await tester.pumpAndSettle();

      expect(availability.available, isFalse);
      expect(find.textContaining('Sin permiso de ubicación'), findsOneWidget);
    });

    testWidgets('una solicitud que llega en vivo aparece sin recargar', (
      tester,
    ) async {
      final offers = FakeOffersRepository();
      final realtime = FakeRealtimeClient();
      await _pumpWorker(tester, offers: offers, realtime: realtime);
      expect(find.byKey(const Key('incoming-empty')), findsOneWidget);

      offers.incoming = [testIncoming(id: 'r-nueva', respondIn: Duration.zero)];
      realtime.emit(RealtimeEvents.requestNew, {'requestId': 'r-nueva'});
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('incoming-r-nueva')), findsOneWidget);
    });

    testWidgets('al reconectar vuelve a pedir el estado por REST', (
      tester,
    ) async {
      final offers = FakeOffersRepository();
      final realtime = FakeRealtimeClient();
      await _pumpWorker(tester, offers: offers, realtime: realtime);
      final before = offers.listIncomingCalls;

      realtime.reconnect();
      await tester.pumpAndSettle();
      expect(offers.listIncomingCalls, greaterThan(before));
    });

    testWidgets('"Retirar oferta" pide confirmación y la retira', (
      tester,
    ) async {
      final offers = FakeOffersRepository(
        incoming: [
          testIncoming(
            myOffer: const MyOffer(
              id: 'mine',
              type: OfferType.accept,
              amountBs: '150.00',
              etaMin: 12,
              status: 'activa',
              revision: 1,
            ),
          ),
        ],
      );
      await _pumpWorker(tester, offers: offers);
      await tester.ensureVisible(find.byKey(const Key('withdraw-offer')));
      await tester.tap(find.byKey(const Key('withdraw-offer')));
      await tester.pumpAndSettle();
      expect(find.text('¿Retirar tu oferta?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('withdraw-confirm')));
      await tester.pumpAndSettle();
      expect(offers.withdrawn, ['r1']);
      expect(find.text('Retiraste tu oferta.'), findsOneWidget);
      expect(find.byKey(const Key('withdraw-offer')), findsNothing);
      expect(find.byKey(const Key('accept-price')), findsOneWidget);
    });

    testWidgets('el detalle permite reportar la solicitud', (tester) async {
      final reports = FakeReportsRepository();
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        me: FakeMeRepository(user: testUser(mode: ActiveMode.worker)),
        offers: FakeOffersRepository(incoming: [testIncoming()]),
        reports: reports,
      );
      await tester.ensureVisible(find.byKey(const Key('incoming-r1')));
      await tester.tap(find.byKey(const Key('incoming-r1')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('report-request')));
      await tester.tap(find.byKey(const Key('report-request')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report-reason-venta_productos')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('report-send')));
      await tester.pumpAndSettle();
      expect(reports.created.single.$1, ReportTarget.request);
      expect(reports.created.single.$2, 'r1');
    });

    testWidgets(
      '"¡Te eligieron!" lleva al trabajo con el contacto del cliente',
      (tester) async {
        final offers = FakeOffersRepository(
          incoming: [
            testIncoming(outcome: IncomingOutcome.elegido, jobId: 'job-1'),
          ],
        );
        // En el inicio aparece el trabajo activo; se entra desde la tarjeta.
        await _pumpWorker(
          tester,
          offers: offers,
          jobs: FakeJobsRepository(jobs: [testJob()]),
        );
        await tester.ensureVisible(find.byKey(const Key('see-contact')));
        expect(find.byKey(const Key('outcome-chosen')), findsOneWidget);

        await tester.tap(find.byKey(const Key('see-contact')));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.byKey(const Key('contact-phone')),
          200,
        );
        expect(find.text('+59171234567'), findsOneWidget);
        expect(find.text('Ana Rojas'), findsOneWidget);
      },
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/realtime/realtime_client.dart';
import 'package:sisi_mobile/features/earnings/domain/earnings_models.dart';
import 'package:sisi_mobile/features/earnings/presentation/earnings_banners.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';

import '../../helpers/fake_earnings.dart';
import '../../helpers/fake_realtime.dart';
import '../../helpers/fakes.dart';

Future<void> _pumpWorker(
  WidgetTester tester, {
  required FakeEarningsRepository earnings,
  ActiveMode mode = ActiveMode.worker,
  FakeRealtimeClient? realtime,
  List<Uri>? openedUrls,
}) => pumpSisiApp(
  tester,
  storedTokens: testTokens,
  me: FakeMeRepository(user: testUser(mode: mode)),
  earnings: earnings,
  realtime: realtime,
  openedUrls: openedUrls,
);

Future<void> _tap(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

void main() {
  group('Mis ganancias (R8)', () {
    testWidgets('resumen del periodo, saldo, fecha límite e historiales', (
      tester,
    ) async {
      final opened = <Uri>[];
      final earnings = FakeEarningsRepository(
        summary: testSummary(
          balanceBs: '29.90',
          overdueOrPendingBs: '19.50',
          nextDueAt: DateTime(2026, 10, 22),
        ),
        periods: [
          BillingPeriodSummary(
            id: 'p1',
            startAt: DateTime(2026, 10, 5),
            endAt: DateTime(2026, 10, 12),
            dueAt: DateTime(2026, 10, 15),
            status: PeriodStatus.pagado,
            grossBs: '80.00',
            commissionBs: '10.40',
            netBs: '69.60',
            balanceBs: '0.00',
            paymentReference: 'SISI-2641-K7M2QX',
          ),
        ],
        payments: [
          MyPayment(
            id: 'pay1',
            amountBs: '10.40',
            paidAt: DateTime(2026, 10, 14),
            method: 'qr_transferencia',
            periodReferences: const ['SISI-2641-K7M2QX'],
            receiptUrl: 'https://storage.test/receipts/1.jpg',
          ),
        ],
      );
      await _pumpWorker(tester, earnings: earnings, openedUrls: opened);
      await _tap(tester, 'my-earnings');

      Finder inPeriod(String text) => find.descendant(
        of: find.byKey(const Key('current-period')),
        matching: find.text(text),
      );
      expect(inPeriod('Bs 150,00'), findsOneWidget);
      expect(inPeriod('− Bs 19,50'), findsOneWidget);
      expect(inPeriod('Bs 130,50'), findsOneWidget);
      expect(find.text('Bs 29,90'), findsOneWidget);
      expect(find.text('miércoles 21/10 a las 23:59'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(const Key('payment-pay1')),
        200,
      );
      expect(find.textContaining('SISI-2641-K7M2QX'), findsWidgets);
      await _tap(tester, 'receipt-pay1');
      expect(opened.single.toString(), 'https://storage.test/receipts/1.jpg');
    });

    testWidgets('con saldo a favor lo muestra como a favor y no ofrece pagar', (
      tester,
    ) async {
      await _pumpWorker(
        tester,
        earnings: FakeEarningsRepository(
          summary: testSummary(balanceBs: '-30.50'),
        ),
      );
      await _tap(tester, 'my-earnings');
      expect(find.text('Bs 30,50 a favor'), findsOneWidget);
      expect(find.byKey(const Key('go-pay')), findsNothing);
    });
  });

  group('Pagar comisión (R7.4)', () {
    testWidgets('QR, los dos montos, referencia para copiar e instrucciones', (
      tester,
    ) async {
      final earnings = FakeEarningsRepository(
        summary: testSummary(
          balanceBs: '159.50',
          overdueOrPendingBs: '19.50',
          capReached: true,
          amountToUnlockBs: '9.50',
        ),
        payInfo: testPayInfo(
          catchUpAmountBs: '19.50',
          unlockAmountBs: '9.50',
          totalBalanceBs: '159.50',
        ),
      );
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await _pumpWorker(tester, earnings: earnings);
      await _tap(tester, 'banner-pay');

      expect(find.text('Para ponerte al día'), findsOneWidget);
      expect(find.text('Para volver a recibir solicitudes'), findsOneWidget);
      expect(find.text('Bs 19,50'), findsOneWidget);
      expect(find.text('Bs 9,50'), findsOneWidget);
      expect(find.text('SISI-2642-K7M2QX'), findsOneWidget);
      expect(
        find.text('Escribe la referencia en la glosa de la transferencia.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('pay-qr')), findsOneWidget);

      await _tap(tester, 'copy-reference');
      expect(copied, 'SISI-2642-K7M2QX');
      expect(find.text('Referencia copiada.'), findsOneWidget);
    });

    testWidgets('sube el comprobante y queda pendiente de verificación', (
      tester,
    ) async {
      final earnings = FakeEarningsRepository(
        summary: testSummary(overdueOrPendingBs: '19.50', overdue: true),
        payInfo: testPayInfo(),
      );
      await _pumpWorker(tester, earnings: earnings);
      await _tap(tester, 'my-earnings');
      await _tap(tester, 'go-pay');
      await _tap(tester, 'send-receipt');
      // Hoja de origen de la foto: galería.
      await tester.tap(find.text('Elegir de la galería'));
      await tester.pumpAndSettle();
      expect(earnings.submitted.single.declaredAmountBs, '19.50');
      expect(
        find.text(
          'Enviamos tu comprobante. Te avisamos cuando lo verifiquemos.',
        ),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('submissions')),
        200,
      );
      expect(find.text('Enviado, pendiente de verificación'), findsOneWidget);
    });

    testWidgets('al día: sin montos para pagar', (tester) async {
      final earnings = FakeEarningsRepository(
        summary: testSummary(balanceBs: '19.50'),
        payInfo: testPayInfo(catchUpAmountBs: '0.00', totalBalanceBs: '0.00'),
      );
      await _pumpWorker(tester, earnings: earnings);
      await _tap(tester, 'my-earnings');
      await _tap(tester, 'go-pay');
      expect(find.text('Estás al día'), findsOneWidget);
      expect(find.byKey(const Key('amount-catch-up')), findsNothing);
      expect(find.byKey(const Key('amount-unlock')), findsNothing);
    });
  });

  group('Banners por estado', () {
    Future<void> pumpBanner(WidgetTester tester, EarningsSummary summary) =>
        tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EarningsBanners(
                summary: summary,
                now: DateTime(2026, 10, 20, 9),
              ),
            ),
          ),
        );

    testWidgets('bloqueo por deuda', (tester) async {
      await pumpBanner(tester, testSummary(blocked: true, overdue: true));
      expect(find.byKey(const Key('banner-blocked')), findsOneWidget);
      expect(
        find.text(
          'Tu modo trabajador está bloqueado por deuda. Puedes seguir pidiendo servicios como empleador.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tope alcanzado', (tester) async {
      await pumpBanner(
        tester,
        testSummary(capReached: true, amountToUnlockBs: '9.50'),
      );
      expect(find.byKey(const Key('banner-cap')), findsOneWidget);
      expect(
        find.textContaining('Paga para seguir recibiendo solicitudes'),
        findsOneWidget,
      );
    });

    testWidgets('fecha límite próxima (48 h)', (tester) async {
      await pumpBanner(
        tester,
        testSummary(
          overdueOrPendingBs: '19.50',
          nextDueAt: DateTime(2026, 10, 22),
        ),
      );
      expect(find.byKey(const Key('banner-due')), findsOneWidget);
      expect(
        find.text('Paga Bs 19,50 hasta el miércoles 21/10 a las 23:59.'),
        findsOneWidget,
      );
    });

    testWidgets('sin deuda ni bloqueo: nada', (tester) async {
      await pumpBanner(tester, testSummary(balanceBs: '0.00'));
      expect(find.byType(Material), findsWidgets);
      expect(find.textContaining('Paga'), findsNothing);
    });

    testWidgets(
      'en modo empleador el bloqueo se ve en el inicio y lleva a pagar',
      (tester) async {
        final realtime = FakeRealtimeClient();
        final earnings = FakeEarningsRepository(
          summary: testSummary(balanceBs: '19.50'),
          payInfo: testPayInfo(),
        );
        await _pumpWorker(
          tester,
          earnings: earnings,
          mode: ActiveMode.employer,
          realtime: realtime,
        );
        expect(find.byKey(const Key('banner-blocked')), findsNothing);
        // Llega el bloqueo en vivo.
        earnings.summaryValue = testSummary(
          blocked: true,
          overdue: true,
          overdueOrPendingBs: '19.50',
        );
        realtime.emit(RealtimeEvents.accountBlocked, {
          'reason': 'deuda',
          'status': 'bloqueado_deuda',
        });
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('banner-blocked')), findsOneWidget);
        await _tap(tester, 'banner-pay');
        expect(find.text('Pagar comisión'), findsWidgets);
        expect(find.text('Para ponerte al día'), findsOneWidget);
      },
    );
  });
}

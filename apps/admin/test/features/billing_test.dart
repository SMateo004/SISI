import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  group('cobros', () {
    FakeApi billingApi() => FakeApi()
      ..on(#adminBillingControllerLedger, (_) async => ok(ledger()))
      ..on(#adminBillingControllerPreviewPayment, (_) async => ok(preview()));

    testWidgets('el ledger muestra el saldo acumulado', (tester) async {
      await pumpAdmin(
        tester,
        api: billingApi(),
        location: '/cobros/trabajador/w1',
      );
      expect(find.text('Saldo: Bs 29,90'), findsOneWidget);
      expect(find.text('Bs 19,50'), findsNWidgets(2));
      expect(find.text('Bs 29,90'), findsOneWidget);
    });

    testWidgets(
      'registrar pago: vista previa con desbloqueo e Idempotency-Key reutilizada al reintentar',
      (tester) async {
        var attempts = 0;
        final api = billingApi()
          ..on<Response<PaymentResultDto>>(
            #adminBillingControllerRegisterPayment,
            (_) async {
              attempts++;
              if (attempts == 1) {
                throw apiError(
                  503,
                  'TIMEOUT',
                  'El servidor tardó demasiado. Intenta de nuevo.',
                );
              }
              return ok(paymentResult());
            },
          );
        await pumpAdmin(tester, api: api, location: '/cobros/trabajador/w1');
        await tester.tap(find.byKey(const Key('worker-pay')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('payment-amount')),
          '29,90',
        );
        await tester.pump();
        await tester.tap(find.byKey(const Key('payment-next')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('balance-preview')), findsOneWidget);
        expect(find.text('Saldo: Bs 29,90 → Bs 0,00'), findsOneWidget);
        expect(
          find.text('Se desbloquea: no queda ningún periodo vencido.'),
          findsOneWidget,
        );
        final previewDto =
            api
                    .callsTo(#adminBillingControllerPreviewPayment)
                    .single[#paymentPreviewDto]
                as PaymentPreviewDto;
        expect(previewDto.amountBs, '29.90');

        await confirmWithReason(tester, 'SISI-2642-R6DXF2');
        expect(
          find.text('El servidor tardó demasiado. Intenta de nuevo.'),
          findsOneWidget,
        );
        await tester.tap(find.byKey(const Key('confirm-submit')));
        await tester.pumpAndSettle();

        final calls = api.callsTo(#adminBillingControllerRegisterPayment);
        expect(calls, hasLength(2));
        expect(calls[0][#idempotencyKey], calls[1][#idempotencyKey]);
        expect(calls[0][#idempotencyKey], startsWith('pago-'));
        final dto = calls[1][#registerPaymentDto] as RegisterPaymentDto;
        expect(dto.amountBs, '29.90');
        expect(dto.reference, 'SISI-2642-R6DXF2');
        expect(find.text('Pago registrado. Saldo: Bs 0,00.'), findsOneWidget);
      },
    );

    testWidgets(
      'un comprobante muestra quién lo envió y el pago se registra desde él',
      (tester) async {
        final submission = AdminPaymentSubmissionDto(
          id: 's1',
          workerId: 'w1',
          status: AdminPaymentSubmissionDtoStatusEnum.pendiente,
          declaredAmountBs: '29.90',
          note: 'Pagué por QR',
          reviewNote: null,
          paymentId: null,
          receiptUrl: 'https://bucket.test/receipts/w1/c.jpg',
          createdAt: DateTime.utc(2026, 10, 22, 14),
          workerName: 'Juan Pérez',
          workerPhone: '+59171111111',
        );
        final api = billingApi()
          ..on(
            #adminBillingControllerSubmissions,
            (_) async => ok([submission]),
          )
          ..on(
            #adminBillingControllerRegisterPayment,
            (_) async => ok(paymentResult()),
          );
        await pumpAdmin(tester, api: api, location: '/cobros/comprobantes');
        expect(find.text('Juan Pérez · +59171111111'), findsOneWidget);
        await tester.tap(find.byKey(const Key('submission-register-s1')));
        await tester.pumpAndSettle();
        // El monto declarado viene precargado.
        expect(
          tester
              .widget<TextField>(find.byKey(const Key('payment-amount')))
              .controller
              ?.text,
          '29,90',
        );
        await tester.tap(find.byKey(const Key('payment-next')));
        await tester.pumpAndSettle();
        await confirmWithReason(tester, 'SISI-2643-K7M2QX');
        final dto =
            api
                    .callsTo(#adminBillingControllerRegisterPayment)
                    .single[#registerPaymentDto]
                as RegisterPaymentDto;
        expect(dto.submissionId, 's1');
        expect(dto.amountBs, '29.90');
      },
    );
  });
}

import 'package:sisi_mobile/core/files/picked_image.dart';
import 'package:sisi_mobile/features/earnings/data/earnings_repository.dart';
import 'package:sisi_mobile/features/earnings/domain/earnings_models.dart';

/// Resumen de prueba: semana con un trabajo de 150 Bs y su comisión de 19,50.
EarningsSummary testSummary({
  String balanceBs = '19.50',
  String overdueOrPendingBs = '0.00',
  bool blocked = false,
  bool overdue = false,
  bool capReached = false,
  String amountToUnlockBs = '0.00',
  DateTime? nextDueAt,
}) => EarningsSummary(
  currentPeriod: CurrentPeriod(
    id: 'p-actual',
    startAt: DateTime(2026, 10, 12),
    endAt: DateTime(2026, 10, 19),
    dueAt: DateTime(2026, 10, 22),
    grossBs: '150.00',
    commissionBs: '19.50',
    netBs: '130.50',
    paymentReference: 'SISI-2642-K7M2QX',
  ),
  balanceBs: balanceBs,
  overdueOrPendingBs: overdueOrPendingBs,
  nextDueAt: nextDueAt,
  overdue: overdue,
  blocked: blocked,
  debtCap: DebtCapState(
    capBs: '150.00',
    reached: capReached,
    amountToUnlockBs: amountToUnlockBs,
  ),
);

PayInfo testPayInfo({
  String catchUpAmountBs = '19.50',
  String unlockAmountBs = '0.00',
  String totalBalanceBs = '19.50',
  String? qrUrl = 'https://storage.test/qr.png',
}) => PayInfo(
  qrUrl: qrUrl,
  catchUpAmountBs: catchUpAmountBs,
  unlockAmountBs: unlockAmountBs,
  totalBalanceBs: totalBalanceBs,
  paymentReference: 'SISI-2642-K7M2QX',
  dueAt: DateTime(2026, 10, 22),
  instructions: const [
    'Abre la app de tu banco y escanea el QR de SISI.',
    'Paga el monto exacto que ves aquí.',
    'Escribe la referencia SISI-2642-K7M2QX en la glosa de la transferencia.',
    'Sube la foto de tu comprobante: lo verificamos y te avisamos.',
  ],
);

class FakeEarningsRepository implements EarningsRepository {
  FakeEarningsRepository({
    EarningsSummary? summary,
    PayInfo? payInfo,
    List<BillingPeriodSummary>? periods,
    List<MyPayment>? payments,
  }) : summaryValue = summary ?? testSummary(balanceBs: '0.00'),
       payInfoValue =
           payInfo ??
           testPayInfo(catchUpAmountBs: '0.00', totalBalanceBs: '0.00'),
       periodsValue = periods ?? [],
       paymentsValue = payments ?? [];

  EarningsSummary summaryValue;
  PayInfo payInfoValue;
  List<BillingPeriodSummary> periodsValue;
  List<MyPayment> paymentsValue;
  final submitted = <PaymentSubmission>[];

  @override
  Future<EarningsSummary> summary() async => summaryValue;

  @override
  Future<PayInfo> payInfo() async => payInfoValue;

  @override
  Future<List<BillingPeriodSummary>> periods() async => periodsValue;

  @override
  Future<List<MyPayment>> payments() async => paymentsValue;

  @override
  Future<List<PaymentSubmission>> submissions() async =>
      List.of(submitted.reversed);

  @override
  Future<PaymentSubmission> submitReceipt(
    PickedImage image, {
    String? declaredAmountBs,
  }) async {
    final s = PaymentSubmission(
      id: 's${submitted.length + 1}',
      status: SubmissionStatus.pendiente,
      declaredAmountBs: declaredAmountBs,
      createdAt: DateTime(2026, 10, 20, 10),
    );
    submitted.add(s);
    return s;
  }
}

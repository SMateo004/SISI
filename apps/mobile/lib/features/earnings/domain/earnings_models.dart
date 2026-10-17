/// Ganancias y cobros (R7, R8). Montos como texto "19.50" (la API nunca envía números).
library;

DateTime? _date(Object? v) => v is String ? DateTime.parse(v).toLocal() : null;

class CurrentPeriod {
  const CurrentPeriod({
    required this.startAt,
    required this.endAt,
    required this.dueAt,
    required this.grossBs,
    required this.commissionBs,
    required this.netBs,
    this.id,
    this.paymentReference,
  });

  factory CurrentPeriod.fromJson(Map<String, dynamic> j) => CurrentPeriod(
    id: j['id'] as String?,
    startAt: _date(j['startAt'])!,
    endAt: _date(j['endAt'])!,
    dueAt: _date(j['dueAt'])!,
    grossBs: j['grossBs'] as String,
    commissionBs: j['commissionBs'] as String,
    netBs: j['netBs'] as String,
    paymentReference: j['paymentReference'] as String?,
  );

  final String? id;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime dueAt;
  final String grossBs;
  final String commissionBs;
  final String netBs;
  final String? paymentReference;
}

class DebtCapState {
  const DebtCapState({
    required this.capBs,
    required this.reached,
    required this.amountToUnlockBs,
  });

  factory DebtCapState.fromJson(Map<String, dynamic> j) => DebtCapState(
    capBs: j['capBs'] as String,
    reached: j['reached'] as bool? ?? false,
    amountToUnlockBs: j['amountToUnlockBs'] as String,
  );

  final String capBs;
  final bool reached;
  final String amountToUnlockBs;
}

class EarningsSummary {
  const EarningsSummary({
    required this.currentPeriod,
    required this.balanceBs,
    required this.overdueOrPendingBs,
    required this.debtCap,
    this.nextDueAt,
    this.overdue = false,
    this.blocked = false,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> j) => EarningsSummary(
    currentPeriod: CurrentPeriod.fromJson(
      (j['currentPeriod'] as Map).cast<String, dynamic>(),
    ),
    balanceBs: j['balanceBs'] as String,
    overdueOrPendingBs: j['overdueOrPendingBs'] as String,
    nextDueAt: _date(j['nextDueAt']),
    overdue: j['overdue'] as bool? ?? false,
    blocked: j['blocked'] as bool? ?? false,
    debtCap: DebtCapState.fromJson(
      (j['debtCap'] as Map).cast<String, dynamic>(),
    ),
  );

  final CurrentPeriod currentPeriod;

  /// Saldo total (positivo = debe; negativo = a favor).
  final String balanceBs;

  /// Periodos cerrados impagos.
  final String overdueOrPendingBs;
  final DateTime? nextDueAt;
  final bool overdue;
  final bool blocked;
  final DebtCapState debtCap;

  bool get owes => !balanceBs.startsWith('-') && balanceBs != '0.00';
}

enum PeriodStatus {
  abierto('En curso'),
  cerradoPendiente('Por pagar'),
  pagado('Pagado'),
  vencido('Vencido');

  const PeriodStatus(this.label);

  final String label;

  static PeriodStatus parse(String v) => switch (v) {
    'cerrado_pendiente' => cerradoPendiente,
    'pagado' => pagado,
    'vencido' => vencido,
    _ => abierto,
  };
}

class BillingPeriodSummary {
  const BillingPeriodSummary({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.dueAt,
    required this.status,
    required this.grossBs,
    required this.commissionBs,
    required this.netBs,
    required this.balanceBs,
    required this.paymentReference,
  });

  factory BillingPeriodSummary.fromJson(Map<String, dynamic> j) =>
      BillingPeriodSummary(
        id: j['id'] as String,
        startAt: _date(j['startAt'])!,
        endAt: _date(j['endAt'])!,
        dueAt: _date(j['dueAt'])!,
        status: PeriodStatus.parse(j['status'] as String),
        grossBs: j['grossBs'] as String,
        commissionBs: j['commissionBs'] as String,
        netBs: j['netBs'] as String,
        balanceBs: j['balanceBs'] as String,
        paymentReference: j['paymentReference'] as String,
      );

  final String id;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime dueAt;
  final PeriodStatus status;
  final String grossBs;
  final String commissionBs;
  final String netBs;
  final String balanceBs;
  final String paymentReference;
}

class MyPayment {
  const MyPayment({
    required this.id,
    required this.amountBs,
    required this.paidAt,
    required this.method,
    required this.periodReferences,
    this.reference,
    this.receiptUrl,
  });

  factory MyPayment.fromJson(Map<String, dynamic> j) => MyPayment(
    id: j['id'] as String,
    amountBs: j['amountBs'] as String,
    paidAt: _date(j['paidAt'])!,
    method: j['method'] as String,
    reference: j['reference'] as String?,
    periodReferences: [
      for (final p in (j['periods'] as List? ?? const []))
        (p as Map)['paymentReference'] as String,
    ],
    receiptUrl: j['receiptUrl'] as String?,
  );

  final String id;
  final String amountBs;
  final DateTime paidAt;
  final String method;
  final String? reference;
  final List<String> periodReferences;
  final String? receiptUrl;
}

class PayInfo {
  const PayInfo({
    required this.catchUpAmountBs,
    required this.unlockAmountBs,
    required this.totalBalanceBs,
    required this.instructions,
    this.qrUrl,
    this.paymentReference,
    this.dueAt,
  });

  factory PayInfo.fromJson(Map<String, dynamic> j) => PayInfo(
    qrUrl: j['qrUrl'] as String?,
    catchUpAmountBs: j['catchUpAmountBs'] as String,
    unlockAmountBs: j['unlockAmountBs'] as String,
    totalBalanceBs: j['totalBalanceBs'] as String,
    paymentReference: j['paymentReference'] as String?,
    dueAt: _date(j['dueAt']),
    instructions: (j['instructions'] as List? ?? const []).cast<String>(),
  );

  final String? qrUrl;

  /// "Para ponerte al día": periodos cerrados impagos.
  final String catchUpAmountBs;

  /// "Para volver a recibir solicitudes": 0.00 si no está sobre el tope.
  final String unlockAmountBs;
  final String totalBalanceBs;
  final String? paymentReference;
  final DateTime? dueAt;
  final List<String> instructions;
}

enum SubmissionStatus {
  pendiente('Enviado, pendiente de verificación'),
  registrado('Pago registrado'),
  rechazado('Rechazado');

  const SubmissionStatus(this.label);

  final String label;

  static SubmissionStatus parse(String v) => switch (v) {
    'registrado' => registrado,
    'rechazado' => rechazado,
    _ => pendiente,
  };
}

class PaymentSubmission {
  const PaymentSubmission({
    required this.id,
    required this.status,
    required this.createdAt,
    this.declaredAmountBs,
    this.reviewNote,
  });

  factory PaymentSubmission.fromJson(Map<String, dynamic> j) =>
      PaymentSubmission(
        id: j['id'] as String,
        status: SubmissionStatus.parse(j['status'] as String),
        declaredAmountBs: j['declaredAmountBs'] as String?,
        reviewNote: j['reviewNote'] as String?,
        createdAt: _date(j['createdAt'])!,
      );

  final String id;
  final SubmissionStatus status;
  final String? declaredAmountBs;
  final String? reviewNote;
  final DateTime createdAt;
}

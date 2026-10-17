import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_providers.dart';
import '../../profile/application/current_user.dart';
import '../data/earnings_repository.dart';
import '../domain/earnings_models.dart';

/// Avisos que cambian lo que ve el trabajador en ganancias y pagos.
const _billingEvents = {
  RealtimeEvents.billingDue,
  RealtimeEvents.accountBlocked,
  RealtimeEvents.accountUnblocked,
  RealtimeEvents.jobStatus,
};

/// Escucha los avisos de cobro y de cuenta, y vuelve a pedir al reconectar.
void _refreshOnBilling(Ref ref) {
  ref.watch(realtimeResyncProvider);
  ref.listen(realtimeEventsProvider, (_, next) {
    final name = next.value?.name;
    if (name != null && _billingEvents.contains(name)) ref.invalidateSelf();
  });
}

final earningsSummaryProvider = FutureProvider.autoDispose<EarningsSummary>((
  ref,
) async {
  _refreshOnBilling(ref);
  return ref.watch(earningsRepositoryProvider).summary();
}, retry: (retryCount, error) => null);

final payInfoProvider = FutureProvider.autoDispose<PayInfo>((ref) async {
  _refreshOnBilling(ref);
  return ref.watch(earningsRepositoryProvider).payInfo();
}, retry: (retryCount, error) => null);

final billingPeriodsProvider =
    FutureProvider.autoDispose<List<BillingPeriodSummary>>((ref) async {
      _refreshOnBilling(ref);
      return ref.watch(earningsRepositoryProvider).periods();
    }, retry: (retryCount, error) => null);

final myPaymentsProvider = FutureProvider.autoDispose<List<MyPayment>>((
  ref,
) async {
  _refreshOnBilling(ref);
  return ref.watch(earningsRepositoryProvider).payments();
}, retry: (retryCount, error) => null);

final submissionsProvider = FutureProvider.autoDispose<List<PaymentSubmission>>(
  (ref) async {
    _refreshOnBilling(ref);
    return ref.watch(earningsRepositoryProvider).submissions();
  },
  retry: (retryCount, error) => null,
);

/// Con account:blocked / account:unblocked cambia el modo o el estado: se vuelve a pedir
/// el usuario (el bloqueo pasa la cuenta a modo empleador, R1.6).
final accountEventsListenerProvider = Provider<void>((ref) {
  ref.listen(realtimeEventsProvider, (_, next) {
    final name = next.value?.name;
    if (name == RealtimeEvents.accountBlocked ||
        name == RealtimeEvents.accountUnblocked) {
      ref.invalidate(currentUserProvider);
    }
  });
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_providers.dart';
import '../data/offers_repository.dart';
import '../domain/offer_models.dart';

/// Cada cuánto se refresca la solicitud mientras busca (anillo actual): la sección 6 del
/// doc 02 no tiene un evento de cambio de anillo (ADR-0023). null = sin refresco (tests).
final searchRefreshIntervalProvider = Provider<Duration?>(
  (ref) => const Duration(seconds: 15),
);

/// Ofertas en vivo de una solicitud (R5.3): se vuelven a pedir con `offer:new` y al
/// reconectar el socket.
final requestOffersProvider = FutureProvider.autoDispose
    .family<List<EmployerOffer>, String>((ref, requestId) async {
      ref.watch(realtimeResyncProvider);
      ref.listen(realtimeEventsProvider, (_, next) {
        final event = next.value;
        if (event != null &&
            event.requestId == requestId &&
            (event.name == RealtimeEvents.offerNew ||
                event.name == RealtimeEvents.requestExpired)) {
          ref.invalidateSelf();
        }
      });
      return ref.watch(offersRepositoryProvider).listOffers(requestId);
    }, retry: (retryCount, error) => null);

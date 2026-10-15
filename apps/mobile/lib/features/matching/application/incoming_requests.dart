import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_providers.dart';
import '../../offers/data/offers_repository.dart';
import '../../offers/domain/offer_models.dart';

/// Avisos que cambian lo que ve el trabajador.
const _workerEvents = {
  RealtimeEvents.requestNew,
  RealtimeEvents.offerClosed,
  RealtimeEvents.requestAssigned,
  RealtimeEvents.requestExpired,
};

/// Solicitudes que le llegaron al trabajador (abiertas primero). Se vuelven a pedir por
/// REST con cada aviso relevante y al reconectar el socket (ADR-0023).
final incomingRequestsProvider =
    FutureProvider.autoDispose<List<IncomingRequest>>((ref) async {
      ref.watch(realtimeResyncProvider);
      ref.listen(realtimeEventsProvider, (_, next) {
        final event = next.value;
        if (event != null && _workerEvents.contains(event.name)) {
          ref.invalidateSelf();
        }
      });
      final list = await ref.watch(offersRepositoryProvider).listIncoming();
      return [...list.where((r) => r.isOpen), ...list.where((r) => !r.isOpen)];
    });

/// Una solicitud entrante (detalle).
final incomingRequestProvider = FutureProvider.autoDispose
    .family<IncomingRequest, String>((ref, requestId) async {
      ref.watch(realtimeResyncProvider);
      ref.listen(realtimeEventsProvider, (_, next) {
        final event = next.value;
        if (event != null &&
            event.requestId == requestId &&
            _workerEvents.contains(event.name)) {
          ref.invalidateSelf();
        }
      });
      return ref.watch(offersRepositoryProvider).getIncoming(requestId);
    });

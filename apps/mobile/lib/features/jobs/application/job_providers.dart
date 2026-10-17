import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_providers.dart';
import '../data/jobs_repository.dart';
import '../domain/job_models.dart';

/// Un trabajo: se vuelve a pedir con `job:status` de ese trabajo y al reconectar.
final jobProvider = FutureProvider.autoDispose.family<Job, String>((
  ref,
  jobId,
) async {
  ref.watch(realtimeResyncProvider);
  ref.listen(realtimeEventsProvider, (_, next) {
    final event = next.value;
    if (event?.name == RealtimeEvents.jobStatus && event?.jobId == jobId) {
      ref.invalidateSelf();
    }
  });
  return ref.watch(jobsRepositoryProvider).get(jobId);
}, retry: (retryCount, error) => null);

/// Historial (primera página) como trabajador o como empleador.
final jobHistoryProvider = FutureProvider.autoDispose.family<JobPage, String>((
  ref,
  role,
) async {
  ref.watch(realtimeResyncProvider);
  ref.listen(realtimeEventsProvider, (_, next) {
    // Un trabajo nuevo llega con request:assigned; los cambios, con job:status.
    final name = next.value?.name;
    if (name == RealtimeEvents.jobStatus ||
        name == RealtimeEvents.requestAssigned) {
      ref.invalidateSelf();
    }
  });
  return ref.watch(jobsRepositoryProvider).list(role: role);
}, retry: (retryCount, error) => null);

/// Trabajo activo (asignado, en camino o en curso) en ese rol, para el inicio.
final activeJobProvider = FutureProvider.autoDispose.family<Job?, String>((
  ref,
  role,
) async {
  final page = await ref.watch(jobHistoryProvider(role).future);
  for (final job in page.items) {
    if (job.status.isActive) return job;
  }
  return null;
});

/// Cada cuánto el trabajador en camino envía su ubicación (primer plano). null = no
/// envía (tests).
final tripLocationIntervalProvider = Provider<Duration?>(
  (ref) => const Duration(seconds: 10),
);

/// Ubicación del trabajador en camino para el empleador: la última conocida por REST y
/// luego en vivo con `job:location`.
class TrackingController extends AsyncNotifier<TrackedPoint?> {
  TrackingController(this.jobId);

  final String jobId;

  @override
  Future<TrackedPoint?> build() async {
    ref.watch(realtimeResyncProvider);
    ref.listen(realtimeEventsProvider, (_, next) {
      final event = next.value;
      if (event?.name == RealtimeEvents.jobLocation && event?.jobId == jobId) {
        try {
          state = AsyncData(TrackedPoint.fromJson(event!.data));
        } on Object {
          // Un aviso mal formado no rompe el mapa: queda el punto anterior.
        }
      }
    });
    try {
      return await ref.watch(jobsRepositoryProvider).location(jobId);
    } on ApiException catch (e) {
      // Fuera de "en camino" no hay ubicación para mostrar.
      if (e.code == 'JOB_LOCATION_UNAVAILABLE') return null;
      rethrow;
    }
  }
}

final trackingProvider = AsyncNotifierProvider.autoDispose
    .family<TrackingController, TrackedPoint?, String>(TrackingController.new);

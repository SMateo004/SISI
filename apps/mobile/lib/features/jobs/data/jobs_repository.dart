import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../domain/job_models.dart';

/// Ciclo del trabajo (R6, ADR-0029).
class JobsRepository {
  JobsRepository(this._api);

  final Dio _api;

  Future<Job> get(String jobId) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/jobs/$jobId');
    return Job.fromJson(res.data!);
  });

  /// Historial como trabajador o como empleador (R8.3).
  Future<JobPage> list({required String role, String? cursor}) =>
      _guard(() async {
        final res = await _api.get<Map<String, dynamic>>(
          '/jobs',
          queryParameters: {'role': role, 'cursor': ?cursor},
        );
        final data = res.data!;
        return JobPage(
          items: (data['items'] as List)
              .cast<Map<String, dynamic>>()
              .map(Job.fromJson)
              .toList(),
          nextCursor: data['nextCursor'] as String?,
        );
      });

  /// Avanzar el trabajo: en camino, empezar, terminé o confirmar.
  Future<Job> act(String jobId, JobAction action) => _guard(() async {
    final path = switch (action) {
      JobAction.startTrip => 'on-the-way',
      JobAction.startWork => 'start',
      JobAction.finish => 'finish',
      JobAction.confirm => 'confirm',
      JobAction.dispute => 'dispute',
      JobAction.cancel => 'cancel',
    };
    final res = await _api.post<Map<String, dynamic>>('/jobs/$jobId/$path');
    return Job.fromJson(res.data!);
  });

  Future<Job> dispute(String jobId, {String? note}) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/jobs/$jobId/dispute',
      data: {'note': ?note},
    );
    return Job.fromJson(res.data!);
  });

  Future<Job> cancel(String jobId, CancelReason reason, {String? note}) =>
      _guard(() async {
        final res = await _api.post<Map<String, dynamic>>(
          '/jobs/$jobId/cancel',
          data: {'reason': reason.api, 'note': ?note},
        );
        return Job.fromJson(res.data!);
      });

  /// Ubicación del trabajador en camino (solo el empleador). null si todavía no hay.
  Future<TrackedPoint?> location(String jobId) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/jobs/$jobId/location');
    final point = res.data!['location'];
    return point is Map
        ? TrackedPoint.fromJson(point.cast<String, dynamic>())
        : null;
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final jobsRepositoryProvider = Provider<JobsRepository>(
  (ref) => JobsRepository(ref.watch(dioProvider)),
);

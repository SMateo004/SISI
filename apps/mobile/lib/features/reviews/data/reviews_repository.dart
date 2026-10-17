import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../../jobs/domain/job_models.dart';

/// Calificaciones (R6.2, ADR-0032).
class ReviewsRepository {
  ReviewsRepository(this._api);

  final Dio _api;

  Future<JobReviews> submit(String jobId, int stars, {String? comment}) =>
      _guard(() async {
        final res = await _api.post<Map<String, dynamic>>(
          '/jobs/$jobId/review',
          data: {'stars': stars, 'comment': ?comment},
        );
        return JobReviews.fromJson(res.data!);
      });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final reviewsRepositoryProvider = Provider<ReviewsRepository>(
  (ref) => ReviewsRepository(ref.watch(dioProvider)),
);

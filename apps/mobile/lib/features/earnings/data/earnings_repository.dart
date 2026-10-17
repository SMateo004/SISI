import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/picked_image.dart';
import '../../../core/files/presigned_upload.dart';
import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../domain/earnings_models.dart';

/// Ganancias y cobros del trabajador (R7, R8).
class EarningsRepository {
  EarningsRepository(this._api, this._storage);

  final Dio _api;
  final Dio _storage;

  Future<EarningsSummary> summary() => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/me/earnings/summary');
    return EarningsSummary.fromJson(res.data!);
  });

  Future<List<BillingPeriodSummary>> periods() => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/me/earnings/periods');
    return (res.data!['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(BillingPeriodSummary.fromJson)
        .toList();
  });

  Future<List<MyPayment>> payments() => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/me/payments');
    return (res.data!['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(MyPayment.fromJson)
        .toList();
  });

  Future<PayInfo> payInfo() => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/me/billing/pay-info');
    return PayInfo.fromJson(res.data!);
  });

  Future<List<PaymentSubmission>> submissions() => _guard(() async {
    final res = await _api.get<List<dynamic>>('/me/billing/submissions');
    return (res.data ?? const [])
        .cast<Map<String, dynamic>>()
        .map(PaymentSubmission.fromJson)
        .toList();
  });

  /// Sube la foto del comprobante y lo envía: queda pendiente de verificación.
  Future<PaymentSubmission> submitReceipt(
    PickedImage image, {
    String? declaredAmountBs,
  }) async {
    final key = await uploadWithPresignedUrl(
      api: _api,
      storage: _storage,
      requestPath: '/me/billing/submissions/upload-url',
      requestBody: const {},
      image: image,
    );
    return _guard(() async {
      final res = await _api.post<Map<String, dynamic>>(
        '/me/billing/submissions',
        data: {'receiptKey': key, 'declaredAmountBs': ?declaredAmountBs},
      );
      return PaymentSubmission.fromJson(res.data!);
    });
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final earningsRepositoryProvider = Provider<EarningsRepository>(
  (ref) =>
      EarningsRepository(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../domain/offer_models.dart';

/// Ofertas, elección y contacto (R5, ADR-0026).
class OffersRepository {
  OffersRepository(this._api);

  final Dio _api;

  // ---- Trabajador ----

  Future<List<IncomingRequest>> listIncoming() => _guard(() async {
    final res = await _api.get<List<dynamic>>('/worker/requests');
    return (res.data ?? const [])
        .cast<Map<String, dynamic>>()
        .map(IncomingRequest.fromJson)
        .toList();
  });

  Future<IncomingRequest> getIncoming(String requestId) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/worker/requests/$requestId',
    );
    return IncomingRequest.fromJson(res.data!);
  });

  /// Aceptar el precio o contraofertar (R5.2). Reemplaza la oferta anterior.
  Future<MyOffer> offer(
    String requestId, {
    required OfferType type,
    String? amountBs,
  }) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/requests/$requestId/offers',
      data: {'type': type.name, 'amountBs': ?amountBs},
    );
    return MyOffer.fromJson(res.data!);
  });

  // ---- Empleador ----

  Future<List<EmployerOffer>> listOffers(String requestId) => _guard(() async {
    final res = await _api.get<List<dynamic>>('/requests/$requestId/offers');
    return (res.data ?? const [])
        .cast<Map<String, dynamic>>()
        .map(EmployerOffer.fromJson)
        .toList();
  });

  /// Elegir una oferta (R5.4). Devuelve el id del trabajo.
  Future<String> accept(String requestId, String offerId) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/requests/$requestId/offers/$offerId/accept',
    );
    return res.data!['jobId'] as String;
  });

  // ---- Contacto ----

  Future<JobContact> contact(String jobId) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/jobs/$jobId/contact');
    return JobContact.fromJson(res.data!);
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final offersRepositoryProvider = Provider<OffersRepository>(
  (ref) => OffersRepository(ref.watch(dioProvider)),
);

final jobContactProvider = FutureProvider.autoDispose
    .family<JobContact, String>(
      (ref, jobId) => ref.watch(offersRepositoryProvider).contact(jobId),
    );

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/picked_image.dart';
import '../../../core/files/presigned_upload.dart';
import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/maps/geo_point.dart';
import '../../../shared/categories/category.dart';
import '../domain/service_request.dart';

/// Datos de la nueva solicitud antes de crear el borrador.
class NewRequestInput {
  const NewRequestInput({
    required this.categoryId,
    required this.description,
    required this.location,
    required this.address,
    required this.proposedPriceBs,
  });

  final String categoryId;
  final String description;
  final GeoPoint location;
  final String address;

  /// Formato de la API: "150.00".
  final String proposedPriceBs;
}

/// Solicitudes de servicio (R3).
class RequestsRepository {
  RequestsRepository(this._api, this._storage);

  final Dio _api;
  final Dio _storage;

  Future<List<Category>> listCategories() => _guard(() async {
    final res = await _api.get<List<dynamic>>('/categories');
    return (res.data ?? const [])
        .cast<Map<String, dynamic>>()
        .map(Category.fromJson)
        .toList();
  });

  /// Dirección sugerida (la geocodificación ocurre en el backend; la app no ve esa llave).
  Future<String?> reverseGeocode(GeoPoint point) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/geocoding/reverse',
      queryParameters: {'lat': point.lat, 'lng': point.lng},
    );
    return res.data?['address'] as String?;
  });

  Future<ServiceRequest> createDraft(NewRequestInput input) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/requests',
      data: {
        'categoryId': input.categoryId,
        'description': input.description,
        'latitude': input.location.lat,
        'longitude': input.location.lng,
        'address': input.address,
        'proposedPriceBs': input.proposedPriceBs,
      },
    );
    return ServiceRequest.fromJson(
      (res.data!['request'] as Map).cast<String, dynamic>(),
    );
  });

  Future<void> uploadPhoto(String requestId, PickedImage image) async {
    final key = await uploadWithPresignedUrl(
      api: _api,
      storage: _storage,
      requestPath: '/requests/$requestId/photos/upload-url',
      requestBody: const {},
      image: image,
    );
    await _guard(
      () => _api.put<void>('/requests/$requestId/photos', data: {'key': key}),
    );
  }

  Future<PublishResult> publish(String requestId) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/requests/$requestId/publish',
    );
    final data = res.data!;
    return PublishResult(
      request: ServiceRequest.fromJson(
        (data['request'] as Map).cast<String, dynamic>(),
      ),
      held: data['held'] == true,
      message: data['message'] as String,
      warnings: ((data['warnings'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(RequestWarning.fromJson)
          .toList(),
    );
  });

  Future<ServiceRequest> cancel(String requestId) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/requests/$requestId/cancel',
    );
    return ServiceRequest.fromJson(res.data!);
  });

  Future<RequestPage> listMine({String? cursor}) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/requests/mine',
      queryParameters: {'cursor': ?cursor},
    );
    final data = res.data!;
    return RequestPage(
      items: (data['items'] as List)
          .cast<Map<String, dynamic>>()
          .map(ServiceRequest.fromJson)
          .toList(),
      nextCursor: data['nextCursor'] as String?,
    );
  });

  Future<ServiceRequest> get(String requestId) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/requests/$requestId');
    return ServiceRequest.fromJson(res.data!);
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) =>
      RequestsRepository(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);

final requestCategoriesProvider = FutureProvider.autoDispose<List<Category>>(
  (ref) => ref.watch(requestsRepositoryProvider).listCategories(),
  retry: (retryCount, error) => null,
);

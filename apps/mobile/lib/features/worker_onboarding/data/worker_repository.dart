import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/picked_image.dart';
import '../../../core/files/presigned_upload.dart';
import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../domain/worker_models.dart';

/// Upgrade a trabajador (R1.3): perfil, categorías, documentos y envío.
class WorkerRepository {
  WorkerRepository(this._api, this._storage);

  final Dio _api;
  final Dio _storage;

  Future<WorkerProfile> getProfile() =>
      _profile(() => _api.get<Map<String, dynamic>>('/me/worker'));

  Future<List<Category>> listCategories() async {
    try {
      final res = await _api.get<List<dynamic>>('/categories');
      return (res.data ?? const [])
          .cast<Map<String, dynamic>>()
          .map(Category.fromJson)
          .toList();
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<WorkerProfile> uploadDocument(
    DocumentType type,
    PickedImage image,
  ) async {
    final key = await uploadWithPresignedUrl(
      api: _api,
      storage: _storage,
      requestPath: '/me/worker/documents/upload-url',
      requestBody: {'type': type.apiValue},
      image: image,
    );
    return _profile(
      () => _api.put<Map<String, dynamic>>(
        '/me/worker/documents/${type.apiValue}',
        data: {'key': key},
      ),
    );
  }

  Future<WorkerProfile> submit({
    required String birthDate,
    required List<String> categoryIds,
    required TransportMode transport,
    required int maxRadiusKm,
  }) => _profile(
    () => _api.post<Map<String, dynamic>>(
      '/me/worker/upgrade',
      data: {
        'birthDate': birthDate,
        'categoryIds': categoryIds,
        'transport': transport.apiValue,
        'maxRadiusKm': maxRadiusKm,
      },
    ),
  );

  Future<WorkerProfile> _profile(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      return WorkerProfile.fromJson((await request()).data ?? const {});
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final workerRepositoryProvider = Provider<WorkerRepository>(
  (ref) =>
      WorkerRepository(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);

/// Perfil de trabajador del usuario actual.
final workerProfileProvider = FutureProvider.autoDispose<WorkerProfile>(
  (ref) => ref.watch(workerRepositoryProvider).getProfile(),
  retry: (retryCount, error) => null,
);

final categoriesProvider = FutureProvider.autoDispose<List<Category>>(
  (ref) => ref.watch(workerRepositoryProvider).listCategories(),
  retry: (retryCount, error) => null,
);

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/files/picked_image.dart';
import '../../../core/files/presigned_upload.dart';
import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../../mode_switch/domain/mode_denial.dart';
import '../domain/app_user.dart';

/// Cuenta, perfil e interruptor de modo.
class MeRepository {
  MeRepository(this._api, this._storage);

  final Dio _api;
  final Dio _storage;

  Future<AppUser> getMe() => _call(() => _api.get<Map<String, dynamic>>('/me'));

  Future<AppUser> updateName(String name) => _call(
    () => _api.patch<Map<String, dynamic>>('/me', data: {'name': name}),
  );

  Future<AppUser> uploadPhoto(PickedImage image) async {
    final key = await uploadWithPresignedUrl(
      api: _api,
      storage: _storage,
      requestPath: '/me/photo/upload-url',
      requestBody: const {},
      image: image,
    );
    return _call(
      () => _api.put<Map<String, dynamic>>('/me/photo', data: {'key': key}),
    );
  }

  /// Lanza [ModeDeniedException] si la API no permite el cambio (R1.5).
  Future<AppUser> switchMode(ActiveMode mode) async {
    try {
      final res = await _api.patch<Map<String, dynamic>>(
        '/me/mode',
        data: {'mode': mode.apiValue},
      );
      return AppUser.fromJson(res.data ?? const {});
    } catch (e) {
      final error = ApiException.from(e);
      if (error.statusCode == 409 && error.extra.containsKey('nextAction')) {
        throw ModeDeniedException.fromApi(error);
      }
      throw error;
    }
  }

  Future<AppUser> _call(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      return AppUser.fromJson((await request()).data ?? const {});
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final meRepositoryProvider = Provider<MeRepository>(
  (ref) => MeRepository(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);

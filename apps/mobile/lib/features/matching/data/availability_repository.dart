import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../../../core/maps/geo_point.dart';
import '../domain/availability.dart';

/// Toggle "Disponible" y ubicación en vivo (ADR-0024).
class AvailabilityRepository {
  AvailabilityRepository(this._api);

  final Dio _api;

  Future<Availability> get() => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>('/worker/availability');
    return Availability.fromJson(res.data!);
  });

  Future<Availability> set({required bool available, GeoPoint? at}) =>
      _guard(() async {
        final res = await _api.put<Map<String, dynamic>>(
          '/worker/availability',
          data: {
            'available': available,
            if (at != null) 'latitude': at.lat,
            if (at != null) 'longitude': at.lng,
          },
        );
        return Availability.fromJson(res.data!);
      });

  Future<void> sendLocation(GeoPoint at) => _guard(() async {
    await _api.post<Map<String, dynamic>>(
      '/worker/location',
      data: {'latitude': at.lat, 'longitude': at.lng},
    );
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final availabilityRepositoryProvider = Provider<AvailabilityRepository>(
  (ref) => AvailabilityRepository(ref.watch(dioProvider)),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/maps/geo_point.dart';

enum LocationAccess { granted, denied, deniedForever, serviceDisabled }

/// Ubicación del dispositivo. Solo en primer plano (ADR-0024): no se pide permiso de
/// ubicación en segundo plano.
abstract class LocationService {
  Future<LocationAccess> requestAccess();
  Future<GeoPoint> current();
}

class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationAccess> requestAccess() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return switch (permission) {
      LocationPermission.whileInUse ||
      LocationPermission.always => LocationAccess.granted,
      LocationPermission.deniedForever => LocationAccess.deniedForever,
      _ => LocationAccess.denied,
    };
  }

  @override
  Future<GeoPoint> current() async {
    final p = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return GeoPoint(p.latitude, p.longitude);
  }
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => GeolocatorLocationService(),
);

/// Mensaje en español cuando no hay acceso a la ubicación.
String locationAccessMessage(LocationAccess access) => switch (access) {
  LocationAccess.serviceDisabled =>
    'Activa la ubicación de tu teléfono para recibir solicitudes cercanas.',
  LocationAccess.deniedForever =>
    'Diste permiso de ubicación como "No permitir". Cámbialo en los ajustes del teléfono para estar disponible.',
  _ => 'Sin permiso de ubicación no podemos mostrarte solicitudes cercanas.',
};

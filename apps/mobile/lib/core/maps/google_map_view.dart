import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

import '../config/env.dart';
import 'geo_point.dart';
import 'maps_loader.dart';

/// Implementación con Google Maps (único archivo que conoce google_maps_flutter).
class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    super.key,
    required this.initialCenter,
    required this.onCenterChanged,
  });

  final GeoPoint initialCenter;
  final ValueChanged<GeoPoint> onCenterChanged;

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  late final Future<void> _ready = ensureGoogleMapsLoaded(Env.mapsApiKey);
  late gm.LatLng _center = gm.LatLng(
    widget.initialCenter.lat,
    widget.initialCenter.lng,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('No se pudo cargar el mapa.'));
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return gm.GoogleMap(
          initialCameraPosition: gm.CameraPosition(target: _center, zoom: 16),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          onCameraMove: (position) => _center = position.target,
          onCameraIdle: () => widget.onCenterChanged(
            GeoPoint(_center.latitude, _center.longitude),
          ),
        );
      },
    );
  }
}

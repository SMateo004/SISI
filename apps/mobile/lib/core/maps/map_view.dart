import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import 'geo_point.dart';
import 'google_map_view.dart';
import 'placeholder_map_view.dart';

/// Mapa para fijar una ubicación con un pin fijo al centro (ADR-0021).
///
/// Las pantallas solo usan [MapView]; el proveedor (Google Maps hoy) se elige en
/// [mapViewBuilderProvider], así que cambiarlo no toca la UI.
typedef MapViewBuilder =
    Widget Function({
      required GeoPoint initialCenter,
      required ValueChanged<GeoPoint> onCenterChanged,
    });

final mapViewBuilderProvider = Provider<MapViewBuilder>((ref) {
  if (Env.mapsApiKey.isEmpty) {
    return ({required initialCenter, required onCenterChanged}) =>
        PlaceholderMapView(
          initialCenter: initialCenter,
          onCenterChanged: onCenterChanged,
        );
  }
  return ({required initialCenter, required onCenterChanged}) => GoogleMapView(
    initialCenter: initialCenter,
    onCenterChanged: onCenterChanged,
  );
});

class MapView extends ConsumerWidget {
  const MapView({
    super.key,
    required this.initialCenter,
    required this.onCenterChanged,
  });

  final GeoPoint initialCenter;

  /// Se llama cuando el mapa se detiene con un nuevo centro (bajo el pin).
  final ValueChanged<GeoPoint> onCenterChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final builder = ref.watch(mapViewBuilderProvider);
    // SizedBox.expand: sin esto el Stack toma el tamaño del pin (su único hijo no
    // posicionado) y el mapa queda como una columna angosta.
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: builder(
              initialCenter: initialCenter,
              onCenterChanged: onCenterChanged,
            ),
          ),
          // Pin fijo: la ubicación elegida es el centro del mapa.
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Icon(
                Icons.location_on,
                size: 44,
                color: Theme.of(context).colorScheme.error,
                semanticLabel: 'Ubicación del trabajo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

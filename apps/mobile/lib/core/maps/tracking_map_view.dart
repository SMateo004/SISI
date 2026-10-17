import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

import '../config/env.dart';
import 'geo_point.dart';
import 'maps_loader.dart';

/// Mapa de seguimiento: un marcador que se mueve (trabajador en camino, ADR-0029).
/// Como [MapView], el proveedor se elige en un provider para no tocar las pantallas.
typedef TrackingMapBuilder = Widget Function({required GeoPoint position});

final trackingMapBuilderProvider = Provider<TrackingMapBuilder>((ref) {
  if (Env.mapsApiKey.isEmpty) {
    return ({required position}) => _PlaceholderTrackingMap(position: position);
  }
  return ({required position}) => _GoogleTrackingMap(position: position);
});

class TrackingMapView extends ConsumerWidget {
  const TrackingMapView({super.key, required this.position});

  final GeoPoint position;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(trackingMapBuilderProvider)(position: position);
}

class _GoogleTrackingMap extends StatefulWidget {
  const _GoogleTrackingMap({required this.position});

  final GeoPoint position;

  @override
  State<_GoogleTrackingMap> createState() => _GoogleTrackingMapState();
}

class _GoogleTrackingMapState extends State<_GoogleTrackingMap> {
  late final Future<void> _ready = ensureGoogleMapsLoaded(Env.mapsApiKey);
  gm.GoogleMapController? _controller;

  gm.LatLng get _target => gm.LatLng(widget.position.lat, widget.position.lng);

  @override
  void didUpdateWidget(covariant _GoogleTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _controller?.animateCamera(gm.CameraUpdate.newLatLng(_target));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: _ready,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text('No se pudo cargar el mapa.'));
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      return gm.GoogleMap(
        initialCameraPosition: gm.CameraPosition(target: _target, zoom: 15),
        onMapCreated: (c) => _controller = c,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        markers: {
          gm.Marker(
            markerId: const gm.MarkerId('trabajador'),
            position: _target,
            infoWindow: const gm.InfoWindow(title: 'Trabajador'),
          ),
        },
      );
    },
  );
}

/// Sin llave de Maps (desarrollo local y tests): muestra el punto como texto.
class _PlaceholderTrackingMap extends StatelessWidget {
  const _PlaceholderTrackingMap({required this.position});

  final GeoPoint position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const Key('tracking-map'),
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.two_wheeler, size: 40, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text('Trabajador en $position', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

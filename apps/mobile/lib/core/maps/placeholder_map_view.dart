import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'geo_point.dart';

/// Mapa sin proveedor (sin llave de Maps: desarrollo local y tests). Un lienzo con
/// cuadrícula que se arrastra; el centro bajo el pin cambia como en un mapa real
/// (escala fija aproximada a zoom 16).
class PlaceholderMapView extends StatefulWidget {
  const PlaceholderMapView({
    super.key,
    required this.initialCenter,
    required this.onCenterChanged,
  });

  final GeoPoint initialCenter;
  final ValueChanged<GeoPoint> onCenterChanged;

  /// Metros por píxel lógico (~zoom 16 a latitudes de Bolivia).
  static const metersPerPixel = 2.2;

  @override
  State<PlaceholderMapView> createState() => _PlaceholderMapViewState();
}

class _PlaceholderMapViewState extends State<PlaceholderMapView> {
  late GeoPoint _center = widget.initialCenter;
  Offset _offset = Offset.zero;

  void _pan(Offset delta) {
    const metersPerDegree = 111320.0;
    final dLat = delta.dy * PlaceholderMapView.metersPerPixel / metersPerDegree;
    final dLng =
        -delta.dx *
        PlaceholderMapView.metersPerPixel /
        (metersPerDegree * math.cos(_center.lat * math.pi / 180));
    setState(() {
      _center = GeoPoint(_center.lat + dLat, _center.lng + dLng);
      _offset += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      key: const Key('placeholder-map'),
      onPanUpdate: (details) => _pan(details.delta),
      onPanEnd: (_) => widget.onCenterChanged(_center),
      child: ClipRect(
        child: CustomPaint(
          painter: _GridPainter(offset: _offset, color: scheme.outlineVariant),
          child: Container(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(8),
            child: Text(
              'Mapa de prueba (sin llave de Maps): arrastra para mover el punto\n$_center',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.offset, required this.color});

  final Offset offset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 40.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final dx = offset.dx % step;
    final dy = offset.dy % step;
    for (var x = dx; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = dy; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.offset != offset;
}

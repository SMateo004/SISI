import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/http/api_client.dart';
import '../../core/http/api_error.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';

/// Puntos [lng, lat] del contorno de un GeoJSON Polygon, o null si no se puede leer.
List<Offset>? polygonPoints(String text) {
  try {
    final json = jsonDecode(text);
    if (json is! Map || json['type'] != 'Polygon') return null;
    final ring = (json['coordinates'] as List).first as List;
    return [
      for (final p in ring)
        Offset(((p as List)[0] as num).toDouble(), (p[1] as num).toDouble()),
    ];
  } catch (_) {
    return null;
  }
}

/// Vista previa del contorno, sin mapa (ADR-0052): sirve para ver que la forma es la esperada.
class PolygonPreview extends StatelessWidget {
  const PolygonPreview({super.key, required this.points, this.center});

  final List<Offset> points;
  final Offset? center;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 180,
    child: CustomPaint(
      painter: _PolygonPainter(
        points,
        center,
        Theme.of(context).colorScheme.primary,
      ),
      child: const SizedBox.expand(),
    ),
  );
}

class _PolygonPainter extends CustomPainter {
  _PolygonPainter(this.points, this.center, this.color);

  final List<Offset> points;
  final Offset? center;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 3) return;
    final all = [...points, ?center];
    final minX = all.map((p) => p.dx).reduce((a, b) => a < b ? a : b);
    final maxX = all.map((p) => p.dx).reduce((a, b) => a > b ? a : b);
    final minY = all.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
    final maxY = all.map((p) => p.dy).reduce((a, b) => a > b ? a : b);
    final scale =
        0.9 *
        [
          size.width / (maxX - minX == 0 ? 1 : maxX - minX),
          size.height / (maxY - minY == 0 ? 1 : maxY - minY),
        ].reduce((a, b) => a < b ? a : b);
    // Latitud hacia arriba: se invierte el eje y.
    Offset map(Offset p) => Offset(
      size.width / 2 + (p.dx - (minX + maxX) / 2) * scale,
      size.height / 2 - (p.dy - (minY + maxY) / 2) * scale,
    );
    final path = Path()..addPolygon(points.map(map).toList(), true);
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    if (center != null) {
      canvas.drawCircle(map(center!), 5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_PolygonPainter old) =>
      old.points != points || old.center != center;
}

/// Zona de servicio de una ciudad: polígono GeoJSON (o radio), probar un punto y guardar con
/// motivo (ADR-0052). Vale para las solicitudes nuevas.
class CityAreaDialog extends ConsumerStatefulWidget {
  const CityAreaDialog({super.key, required this.city});

  final AdminCityDto city;

  @override
  ConsumerState<CityAreaDialog> createState() => _CityAreaDialogState();
}

class _CityAreaDialogState extends ConsumerState<CityAreaDialog> {
  final _geojson = TextEditingController();
  final _radius = TextEditingController();
  final _lat = TextEditingController();
  final _lng = TextEditingController();
  CityAreaDto? _area;
  String? _testResult;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ref
          .read(adminApiProvider)
          .adminCityAreaControllerGet(id: widget.city.id);
      final area = res.data!;
      setState(() {
        _area = area;
        _geojson.text = area.geojson ?? '';
        _radius.text = area.radiusKm?.toString() ?? '';
        _lat.text = area.centerLat?.toString() ?? '';
        _lng.text = area.centerLng?.toString() ?? '';
      });
    } catch (e) {
      setState(() => _error = ApiError.from(e).message);
    }
  }

  @override
  void dispose() {
    for (final c in [_geojson, _radius, _lat, _lng]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _test() async {
    final lat = double.tryParse(_lat.text.replaceAll(',', '.'));
    final lng = double.tryParse(_lng.text.replaceAll(',', '.'));
    if (lat == null || lng == null) return;
    try {
      final res = await ref
          .read(adminApiProvider)
          .adminCityAreaControllerTest(
            id: widget.city.id,
            testPointDto: TestPointDto(lat: lat, lng: lng),
          );
      final r = res.data!;
      setState(
        () => _testResult = r.inside
            ? 'Dentro de la zona (${r.by.name == 'polygon' ? 'polígono' : 'radio'}).'
            : 'Fuera de la zona.',
      );
    } catch (e) {
      setState(() => _testResult = ApiError.from(e).message);
    }
  }

  Future<void> _save() async {
    final geojson = _geojson.text.trim();
    final radius = num.tryParse(_radius.text.replaceAll(',', '.'));
    final saved = await confirmAction<CityAreaDto>(
      context,
      title: 'Guardar la zona de ${widget.city.name}',
      message: geojson.isEmpty
          ? 'Sin polígono: vale el radio desde el centro.'
          : 'Las solicitudes nuevas fuera del polígono no se aceptan.',
      confirmLabel: 'Guardar',
      onConfirm: (input) async {
        final res = await ref
            .read(adminApiProvider)
            .adminCityAreaControllerSet(
              id: widget.city.id,
              setCityAreaDto: SetCityAreaDto(
                geojson: geojson.isEmpty ? null : geojson,
                radiusKm: radius,
                reason: input.note,
              ),
            );
        return res.data!;
      },
    );
    if (saved != null && mounted) Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    final points = polygonPoints(_geojson.text);
    final center = _area?.centerLng == null
        ? null
        : Offset(_area!.centerLng!.toDouble(), _area!.centerLat!.toDouble());
    return AlertDialog(
      title: Text('Zona de ${widget.city.name}'),
      content: SizedBox(
        width: 560,
        child: _area == null
            ? (_error == null
                  ? const Center(child: CircularProgressIndicator())
                  : Text(_error!))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Pega un GeoJSON Polygon ([longitud, latitud]); por ejemplo, exportado de geojson.io. Vacío: se usa el radio.',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      key: const Key('area-geojson'),
                      controller: _geojson,
                      minLines: 4,
                      maxLines: 8,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontFamily: 'monospace'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (points != null) ...[
                      const SizedBox(height: 8),
                      PolygonPreview(points: points, center: center),
                    ],
                    TextField(
                      key: const Key('area-radius'),
                      controller: _radius,
                      decoration: const InputDecoration(
                        labelText:
                            'Radio desde el centro (km, si no hay polígono)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Probar un punto',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            key: const Key('area-lat'),
                            controller: _lat,
                            decoration: const InputDecoration(
                              labelText: 'Latitud',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            key: const Key('area-lng'),
                            controller: _lng,
                            decoration: const InputDecoration(
                              labelText: 'Longitud',
                            ),
                          ),
                        ),
                        TextButton(
                          key: const Key('area-test'),
                          onPressed: _test,
                          child: const Text('Probar'),
                        ),
                      ],
                    ),
                    if (_testResult != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _testResult!,
                          key: const Key('area-test-result'),
                        ),
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('area-save'),
          onPressed: _area == null ? null : _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

/// Abre la zona de la ciudad y avisa si se guardó.
Future<void> editCityArea(BuildContext context, AdminCityDto city) async {
  final saved = await showDialog<CityAreaDto>(
    context: context,
    builder: (_) => CityAreaDialog(city: city),
  );
  if (saved != null && context.mounted) {
    showDone(context, 'Zona de ${city.name} guardada.');
  }
}

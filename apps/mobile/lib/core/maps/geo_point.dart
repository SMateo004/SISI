/// Coordenadas propias de la app: ninguna pantalla depende del tipo del proveedor de mapas.
class GeoPoint {
  const GeoPoint(this.lat, this.lng);

  final double lat;
  final double lng;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);

  @override
  String toString() => '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
}

/// Centro de Santa Cruz de la Sierra (Plaza 24 de Septiembre). Punto inicial del mapa;
/// la API valida la zona de servicio real (ADR-0019).
const santaCruzCenter = GeoPoint(-17.7834, -63.1821);

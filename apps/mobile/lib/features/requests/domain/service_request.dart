import '../../../core/maps/geo_point.dart';

/// Estados de R3.4 con su etiqueta para el empleador.
enum RequestStatus {
  borrador('borrador', 'Sin publicar'),
  retenida('retenida', 'En revisión'),
  buscando('buscando', 'Buscando trabajador'),
  conOfertas('con_ofertas', 'Con ofertas'),
  asignada('asignada', 'Asignada'),
  cancelada('cancelada', 'Cancelada'),
  expirada('expirada', 'Expirada');

  const RequestStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  /// R3.4: se puede cancelar mientras no esté asignada ni terminada.
  bool get cancelable =>
      this == borrador ||
      this == retenida ||
      this == buscando ||
      this == conOfertas;

  static RequestStatus fromApi(String? value) =>
      values.firstWhere((s) => s.apiValue == value, orElse: () => borrador);
}

class RequestCategory {
  const RequestCategory({
    required this.id,
    required this.slug,
    required this.name,
  });

  final String id;
  final String slug;
  final String name;
}

class RequestPhoto {
  const RequestPhoto({
    required this.id,
    required this.position,
    required this.url,
  });

  final String id;
  final int position;
  final String url;
}

class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.status,
    required this.category,
    required this.description,
    required this.location,
    required this.address,
    required this.proposedPriceBs,
    required this.createdAt,
    this.statusMessage,
    this.photos = const [],
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    final category = (json['category'] as Map).cast<String, dynamic>();
    return ServiceRequest(
      id: json['id'] as String,
      status: RequestStatus.fromApi(json['status'] as String?),
      statusMessage: json['statusMessage'] as String?,
      category: RequestCategory(
        id: category['id'] as String,
        slug: category['slug'] as String,
        name: category['name'] as String,
      ),
      description: json['description'] as String,
      location: GeoPoint(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      address: json['address'] as String,
      proposedPriceBs: json['proposedPriceBs'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      photos: ((json['photos'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(
            (p) => RequestPhoto(
              id: p['id'] as String,
              position: (p['position'] as num).toInt(),
              url: p['url'] as String,
            ),
          )
          .toList(),
    );
  }

  final String id;
  final RequestStatus status;
  final String? statusMessage;
  final RequestCategory category;
  final String description;
  final GeoPoint location;
  final String address;
  final String proposedPriceBs;
  final DateTime createdAt;
  final List<RequestPhoto> photos;
}

/// Advertencia de la API (R3.2): el precio está bajo el mínimo de referencia.
class RequestWarning {
  const RequestWarning({required this.code, required this.message});

  factory RequestWarning.fromJson(Map<String, dynamic> json) => RequestWarning(
    code: json['code'] as String,
    message: json['message'] as String,
  );

  final String code;
  final String message;
}

class PublishResult {
  const PublishResult({
    required this.request,
    required this.held,
    required this.message,
    this.warnings = const [],
  });

  final ServiceRequest request;

  /// Quedó retenida por moderación: se muestra un mensaje neutral (R3.3).
  final bool held;
  final String message;
  final List<RequestWarning> warnings;
}

class RequestPage {
  const RequestPage({required this.items, this.nextCursor});

  final List<ServiceRequest> items;
  final String? nextCursor;
}

/// Modelos de ofertas (R5, ADR-0026). Montos como texto "180.00" (formato de la API).
library;

enum OfferType {
  accept,
  counter;

  static OfferType parse(String value) =>
      value == 'counter' ? OfferType.counter : OfferType.accept;

  String get label =>
      this == OfferType.counter ? 'Contraoferta' : 'Acepta tu precio';
}

/// La oferta propia del trabajador.
class MyOffer {
  const MyOffer({
    required this.id,
    required this.type,
    required this.amountBs,
    required this.etaMin,
    required this.status,
    required this.revision,
  });

  factory MyOffer.fromJson(Map<String, dynamic> json) => MyOffer(
    id: json['id'] as String,
    type: OfferType.parse(json['type'] as String),
    amountBs: json['amountBs'] as String,
    etaMin: json['etaMin'] as int,
    status: json['status'] as String,
    revision: (json['revision'] as int?) ?? 1,
  );

  final String id;
  final OfferType type;
  final String amountBs;
  final int etaMin;

  /// activa, aceptada o cerrada.
  final String status;
  final int revision;
}

/// Resultado de una solicitud que le llegó al trabajador.
enum IncomingOutcome {
  abierta,
  elegido,
  elegidaOtra,
  cancelada,
  expirada;

  static IncomingOutcome parse(String value) => switch (value) {
    'elegido' => IncomingOutcome.elegido,
    'elegida_otra' => IncomingOutcome.elegidaOtra,
    'cancelada' => IncomingOutcome.cancelada,
    'expirada' => IncomingOutcome.expirada,
    _ => IncomingOutcome.abierta,
  };
}

/// Solicitud entrante (R5.1): distancia, descripción, fotos y precio. Sin datos de contacto.
class IncomingRequest {
  const IncomingRequest({
    required this.requestId,
    required this.outcome,
    required this.categorySlug,
    required this.categoryName,
    required this.description,
    required this.distanceM,
    required this.proposedPriceBs,
    required this.referenceMinBs,
    required this.referenceMaxBs,
    required this.maxCounterBs,
    required this.photoUrls,
    required this.ring,
    required this.respondBy,
    this.myOffer,
    this.jobId,
  });

  factory IncomingRequest.fromJson(Map<String, dynamic> json) {
    final category = (json['category'] as Map).cast<String, dynamic>();
    final range = (json['referenceRange'] as Map).cast<String, dynamic>();
    final photos = (json['photos'] as List? ?? const [])
        .cast<Map<String, dynamic>>()
        .map((p) => p['url'] as String)
        .toList();
    final offer = json['myOffer'];
    return IncomingRequest(
      requestId: json['requestId'] as String,
      outcome: IncomingOutcome.parse(json['outcome'] as String),
      categorySlug: category['slug'] as String,
      categoryName: category['name'] as String,
      description: json['description'] as String,
      distanceM: json['distanceM'] as int,
      proposedPriceBs: json['proposedPriceBs'] as String,
      referenceMinBs: range['minBs'] as String,
      referenceMaxBs: range['maxBs'] as String,
      maxCounterBs: json['maxCounterBs'] as String,
      photoUrls: photos,
      ring: json['ring'] as int,
      respondBy: DateTime.parse(json['respondBy'] as String),
      myOffer: offer is Map
          ? MyOffer.fromJson(offer.cast<String, dynamic>())
          : null,
      jobId: json['jobId'] as String?,
    );
  }

  final String requestId;
  final IncomingOutcome outcome;
  final String categorySlug;
  final String categoryName;
  final String description;
  final int distanceM;
  final String proposedPriceBs;
  final String referenceMinBs;
  final String referenceMaxBs;
  final String maxCounterBs;
  final List<String> photoUrls;
  final int ring;
  final DateTime respondBy;
  final MyOffer? myOffer;
  final String? jobId;

  bool get isOpen => outcome == IncomingOutcome.abierta;
}

/// Oferta como la ve el empleador (R5.3).
class EmployerOffer {
  const EmployerOffer({
    required this.id,
    required this.type,
    required this.amountBs,
    required this.etaMin,
    required this.distanceM,
    required this.workerShortName,
    required this.ratingAvg,
    required this.ratingCount,
  });

  factory EmployerOffer.fromJson(Map<String, dynamic> json) {
    final worker = (json['worker'] as Map).cast<String, dynamic>();
    return EmployerOffer(
      id: json['id'] as String,
      type: OfferType.parse(json['type'] as String),
      amountBs: json['amountBs'] as String,
      etaMin: json['etaMin'] as int,
      distanceM: json['distanceM'] as int,
      workerShortName: worker['shortName'] as String,
      ratingAvg: worker['ratingAvg'] as String,
      ratingCount: worker['ratingCount'] as int,
    );
  }

  final String id;
  final OfferType type;
  final String amountBs;
  final int etaMin;
  final int distanceM;
  final String workerShortName;
  final String ratingAvg;
  final int ratingCount;
}

/// Contacto de la contraparte, solo con el trabajo asignado (R5.4, R9.4).
class JobContact {
  const JobContact({
    required this.jobId,
    required this.role,
    required this.phone,
    required this.finalPriceBs,
    this.name,
    this.address,
  });

  factory JobContact.fromJson(Map<String, dynamic> json) => JobContact(
    jobId: json['jobId'] as String,
    role: json['role'] as String,
    name: json['name'] as String?,
    phone: json['phone'] as String,
    address: json['address'] as String?,
    finalPriceBs: json['finalPriceBs'] as String,
  );

  final String jobId;

  /// Rol de la contraparte: employer o worker.
  final String role;
  final String? name;
  final String phone;
  final String? address;
  final String finalPriceBs;
}

/// "a 850 m" / "a 2,3 km".
String formatDistance(int meters) => meters < 1000
    ? 'a ${(meters / 10).round() * 10} m'
    : 'a ${(meters / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';

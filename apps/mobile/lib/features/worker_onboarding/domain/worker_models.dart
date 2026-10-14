export '../../../shared/categories/category.dart';

/// Estados del perfil de trabajador (R1.4).
enum WorkerStatus {
  sinSolicitar('sin_solicitar'),
  pendienteRevision('pendiente_revision'),
  aprobado('aprobado'),
  rechazado('rechazado'),
  bloqueadoDeuda('bloqueado_deuda'),
  suspendidoModeracion('suspendido_moderacion');

  const WorkerStatus(this.apiValue);

  final String apiValue;

  static WorkerStatus fromApi(String? value) =>
      values.firstWhere((s) => s.apiValue == value, orElse: () => sinSolicitar);
}

/// Documentos que pide R1.3.
enum DocumentType {
  ciFront(
    'ci_front',
    'Carnet de identidad (anverso)',
    'Foto del frente de tu carnet',
  ),
  ciBack(
    'ci_back',
    'Carnet de identidad (reverso)',
    'Foto del reverso de tu carnet',
  ),
  selfie('selfie', 'Selfie', 'Una foto de tu cara, bien iluminada');

  const DocumentType(this.apiValue, this.label, this.hint);

  final String apiValue;
  final String label;
  final String hint;

  static DocumentType? fromApi(String value) {
    for (final type in values) {
      if (type.apiValue == value) return type;
    }
    return null;
  }
}

/// Medio de transporte (propuesta aprobada para el MVP).
enum TransportMode {
  aPie('a_pie', 'A pie'),
  bicicleta('bicicleta', 'Bicicleta'),
  moto('moto', 'Moto'),
  auto('auto', 'Auto'),
  transportePublico('transporte_publico', 'Transporte público');

  const TransportMode(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static TransportMode? fromApi(String? value) {
    for (final mode in values) {
      if (mode.apiValue == value) return mode;
    }
    return null;
  }
}

/// Radio permitido (propuesta: 1 a 10 km, alineado con el anillo máximo de R4.2).
const minRadiusKm = 1;
const maxRadiusKm = 10;

class DocumentStatus {
  const DocumentStatus({required this.type, required this.reviewStatus});

  final DocumentType type;
  final String reviewStatus;
}

class WorkerProfile {
  const WorkerProfile({
    required this.status,
    required this.documents,
    required this.missingDocuments,
    required this.editable,
    this.rejectionReason,
    this.birthDate,
    this.transport,
    this.maxRadiusKm,
    this.categoryIds = const [],
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) => WorkerProfile(
    status: WorkerStatus.fromApi(json['status'] as String?),
    rejectionReason: json['rejectionReason'] as String?,
    birthDate: json['birthDate'] as String?,
    transport: TransportMode.fromApi(json['transport'] as String?),
    maxRadiusKm: (json['maxRadiusKm'] as num?)?.toInt(),
    categoryIds: ((json['categoryIds'] as List?) ?? const []).cast<String>(),
    editable: json['editable'] == true,
    documents: ((json['documents'] as List?) ?? const [])
        .cast<Map<String, dynamic>>()
        .map(
          (d) => (
            DocumentType.fromApi(d['type'] as String),
            d['reviewStatus'] as String,
          ),
        )
        .where((d) => d.$1 != null)
        .map((d) => DocumentStatus(type: d.$1!, reviewStatus: d.$2))
        .toList(),
    missingDocuments: ((json['missingDocuments'] as List?) ?? const [])
        .map((t) => DocumentType.fromApi(t as String))
        .whereType<DocumentType>()
        .toList(),
  );

  static const empty = WorkerProfile(
    status: WorkerStatus.sinSolicitar,
    documents: [],
    missingDocuments: DocumentType.values,
    editable: true,
  );

  final WorkerStatus status;
  final String? rejectionReason;
  final String? birthDate;
  final TransportMode? transport;
  final int? maxRadiusKm;
  final List<String> categoryIds;
  final List<DocumentStatus> documents;
  final List<DocumentType> missingDocuments;
  final bool editable;

  bool hasDocument(DocumentType type) => documents.any((d) => d.type == type);
}

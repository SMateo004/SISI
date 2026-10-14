//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/worker_document_status_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'worker_profile_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkerProfileDto {
  /// Returns a new [WorkerProfileDto] instance.
  WorkerProfileDto({

    required  this.status,

     this.rejectionReason,

     this.birthDate,

     this.transport,

     this.maxRadiusKm,

    required  this.categoryIds,

    required  this.documents,

     this.submittedAt,

    required  this.editable,

    required  this.missingDocuments,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final WorkerProfileDtoStatusEnum status;



  @JsonKey(
    
    name: r'rejectionReason',
    required: false,
    includeIfNull: false,
  )


  final String? rejectionReason;



  @JsonKey(
    
    name: r'birthDate',
    required: false,
    includeIfNull: false,
  )


  final String? birthDate;



  @JsonKey(
    
    name: r'transport',
    required: false,
    includeIfNull: false,
  )


  final WorkerProfileDtoTransportEnum? transport;



  @JsonKey(
    
    name: r'maxRadiusKm',
    required: false,
    includeIfNull: false,
  )


  final num? maxRadiusKm;



  @JsonKey(
    
    name: r'categoryIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> categoryIds;



      /// Estado de cada documento. Nunca incluye la imagen (R9.5).
  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<WorkerDocumentStatusDto> documents;



  @JsonKey(
    
    name: r'submittedAt',
    required: false,
    includeIfNull: false,
  )


  final String? submittedAt;



      /// Puede editar documentos y enviar la solicitud
  @JsonKey(
    
    name: r'editable',
    required: true,
    includeIfNull: false,
  )


  final bool editable;



      /// Documentos que faltan subir
  @JsonKey(
    
    name: r'missingDocuments',
    required: true,
    includeIfNull: false,
  )


  final List<String> missingDocuments;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WorkerProfileDto &&
      other.status == status &&
      other.rejectionReason == rejectionReason &&
      other.birthDate == birthDate &&
      other.transport == transport &&
      other.maxRadiusKm == maxRadiusKm &&
      other.categoryIds == categoryIds &&
      other.documents == documents &&
      other.submittedAt == submittedAt &&
      other.editable == editable &&
      other.missingDocuments == missingDocuments;

    @override
    int get hashCode =>
        status.hashCode +
        (rejectionReason == null ? 0 : rejectionReason.hashCode) +
        (birthDate == null ? 0 : birthDate.hashCode) +
        (transport == null ? 0 : transport.hashCode) +
        (maxRadiusKm == null ? 0 : maxRadiusKm.hashCode) +
        categoryIds.hashCode +
        documents.hashCode +
        (submittedAt == null ? 0 : submittedAt.hashCode) +
        editable.hashCode +
        missingDocuments.hashCode;

  factory WorkerProfileDto.fromJson(Map<String, dynamic> json) => _$WorkerProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerProfileDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum WorkerProfileDtoStatusEnum {
@JsonValue(r'sin_solicitar')
sinSolicitar(r'sin_solicitar'),
@JsonValue(r'pendiente_revision')
pendienteRevision(r'pendiente_revision'),
@JsonValue(r'aprobado')
aprobado(r'aprobado'),
@JsonValue(r'rechazado')
rechazado(r'rechazado'),
@JsonValue(r'bloqueado_deuda')
bloqueadoDeuda(r'bloqueado_deuda'),
@JsonValue(r'suspendido_moderacion')
suspendidoModeracion(r'suspendido_moderacion');

const WorkerProfileDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


enum WorkerProfileDtoTransportEnum {
@JsonValue(r'a_pie')
aPie(r'a_pie'),
@JsonValue(r'bicicleta')
bicicleta(r'bicicleta'),
@JsonValue(r'moto')
moto(r'moto'),
@JsonValue(r'auto')
auto(r'auto'),
@JsonValue(r'transporte_publico')
transportePublico(r'transporte_publico');

const WorkerProfileDtoTransportEnum(this.value);

final String value;

@override
String toString() => value;
}



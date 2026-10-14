//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'worker_document_status_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkerDocumentStatusDto {
  /// Returns a new [WorkerDocumentStatusDto] instance.
  WorkerDocumentStatusDto({

    required  this.type,

    required  this.reviewStatus,

    required  this.uploadedAt,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final WorkerDocumentStatusDtoTypeEnum type;



  @JsonKey(
    
    name: r'reviewStatus',
    required: true,
    includeIfNull: false,
  )


  final WorkerDocumentStatusDtoReviewStatusEnum reviewStatus;



  @JsonKey(
    
    name: r'uploadedAt',
    required: true,
    includeIfNull: false,
  )


  final String uploadedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WorkerDocumentStatusDto &&
      other.type == type &&
      other.reviewStatus == reviewStatus &&
      other.uploadedAt == uploadedAt;

    @override
    int get hashCode =>
        type.hashCode +
        reviewStatus.hashCode +
        uploadedAt.hashCode;

  factory WorkerDocumentStatusDto.fromJson(Map<String, dynamic> json) => _$WorkerDocumentStatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerDocumentStatusDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum WorkerDocumentStatusDtoTypeEnum {
@JsonValue(r'ci_front')
ciFront(r'ci_front'),
@JsonValue(r'ci_back')
ciBack(r'ci_back'),
@JsonValue(r'selfie')
selfie(r'selfie'),
@JsonValue(r'cert')
cert(r'cert');

const WorkerDocumentStatusDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum WorkerDocumentStatusDtoReviewStatusEnum {
@JsonValue(r'pendiente')
pendiente(r'pendiente'),
@JsonValue(r'aprobado')
aprobado(r'aprobado'),
@JsonValue(r'rechazado')
rechazado(r'rechazado');

const WorkerDocumentStatusDtoReviewStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_document_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationDocumentDto {
  /// Returns a new [VerificationDocumentDto] instance.
  VerificationDocumentDto({

    required  this.id,

    required  this.type,

    required  this.url,

    required  this.expiresAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final VerificationDocumentDtoTypeEnum type;



      /// URL temporal (5 minutos, sin caché). Nunca se guarda.
  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationDocumentDto &&
      other.id == id &&
      other.type == type &&
      other.url == url &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        url.hashCode +
        expiresAt.hashCode;

  factory VerificationDocumentDto.fromJson(Map<String, dynamic> json) => _$VerificationDocumentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDocumentDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VerificationDocumentDtoTypeEnum {
@JsonValue(r'ci_front')
ciFront(r'ci_front'),
@JsonValue(r'ci_back')
ciBack(r'ci_back'),
@JsonValue(r'selfie')
selfie(r'selfie'),
@JsonValue(r'cert')
cert(r'cert');

const VerificationDocumentDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



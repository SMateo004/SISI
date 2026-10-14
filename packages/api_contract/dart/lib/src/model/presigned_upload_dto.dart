//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'presigned_upload_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PresignedUploadDto {
  /// Returns a new [PresignedUploadDto] instance.
  PresignedUploadDto({

    required  this.key,

    required  this.uploadUrl,

    required  this.method,

    required  this.headers,

    required  this.expiresAt,
  });

      /// Clave para confirmar la subida
  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;



  @JsonKey(
    
    name: r'uploadUrl',
    required: true,
    includeIfNull: false,
  )


  final String uploadUrl;



  @JsonKey(
    
    name: r'method',
    required: true,
    includeIfNull: false,
  )


  final PresignedUploadDtoMethodEnum method;



      /// Headers a enviar tal cual en el PUT
  @JsonKey(
    
    name: r'headers',
    required: true,
    includeIfNull: false,
  )


  final Object headers;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final String expiresAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PresignedUploadDto &&
      other.key == key &&
      other.uploadUrl == uploadUrl &&
      other.method == method &&
      other.headers == headers &&
      other.expiresAt == expiresAt;

    @override
    int get hashCode =>
        key.hashCode +
        uploadUrl.hashCode +
        method.hashCode +
        headers.hashCode +
        expiresAt.hashCode;

  factory PresignedUploadDto.fromJson(Map<String, dynamic> json) => _$PresignedUploadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedUploadDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PresignedUploadDtoMethodEnum {
@JsonValue(r'PUT')
PUT(r'PUT');

const PresignedUploadDtoMethodEnum(this.value);

final String value;

@override
String toString() => value;
}



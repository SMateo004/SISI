//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_upload_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentUploadRequestDto {
  /// Returns a new [DocumentUploadRequestDto] instance.
  DocumentUploadRequestDto({

    required  this.type,

    required  this.contentType,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final DocumentUploadRequestDtoTypeEnum type;



  @JsonKey(
    
    name: r'contentType',
    required: true,
    includeIfNull: false,
  )


  final DocumentUploadRequestDtoContentTypeEnum contentType;



      /// Tamaño exacto en bytes (máx. 8 MB)
  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final num sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentUploadRequestDto &&
      other.type == type &&
      other.contentType == contentType &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        type.hashCode +
        contentType.hashCode +
        sizeBytes.hashCode;

  factory DocumentUploadRequestDto.fromJson(Map<String, dynamic> json) => _$DocumentUploadRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentUploadRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DocumentUploadRequestDtoTypeEnum {
@JsonValue(r'ci_front')
ciFront(r'ci_front'),
@JsonValue(r'ci_back')
ciBack(r'ci_back'),
@JsonValue(r'selfie')
selfie(r'selfie');

const DocumentUploadRequestDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum DocumentUploadRequestDtoContentTypeEnum {
@JsonValue(r'image/jpeg')
imageSlashJpeg(r'image/jpeg'),
@JsonValue(r'image/png')
imageSlashPng(r'image/png'),
@JsonValue(r'image/heic')
imageSlashHeic(r'image/heic');

const DocumentUploadRequestDtoContentTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadRequestDto {
  /// Returns a new [UploadRequestDto] instance.
  UploadRequestDto({

    required  this.contentType,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'contentType',
    required: true,
    includeIfNull: false,
  )


  final UploadRequestDtoContentTypeEnum contentType;



      /// Tamaño exacto del archivo en bytes (máx. 8 MB)
  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final num sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UploadRequestDto &&
      other.contentType == contentType &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        contentType.hashCode +
        sizeBytes.hashCode;

  factory UploadRequestDto.fromJson(Map<String, dynamic> json) => _$UploadRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UploadRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UploadRequestDtoContentTypeEnum {
@JsonValue(r'image/jpeg')
imageSlashJpeg(r'image/jpeg'),
@JsonValue(r'image/png')
imageSlashPng(r'image/png'),
@JsonValue(r'image/heic')
imageSlashHeic(r'image/heic');

const UploadRequestDtoContentTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_upload_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FileUploadDto {
  /// Returns a new [FileUploadDto] instance.
  FileUploadDto({

    required  this.contentType,

    required  this.sizeBytes,
  });

      /// JPEG, PNG o HEIC
  @JsonKey(
    
    name: r'contentType',
    required: true,
    includeIfNull: false,
  )


  final String contentType;



  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final num sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FileUploadDto &&
      other.contentType == contentType &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        contentType.hashCode +
        sizeBytes.hashCode;

  factory FileUploadDto.fromJson(Map<String, dynamic> json) => _$FileUploadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


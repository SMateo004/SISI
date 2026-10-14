//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'confirm_upload_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConfirmUploadDto {
  /// Returns a new [ConfirmUploadDto] instance.
  ConfirmUploadDto({

    required  this.key,
  });

  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConfirmUploadDto &&
      other.key == key;

    @override
    int get hashCode =>
        key.hashCode;

  factory ConfirmUploadDto.fromJson(Map<String, dynamic> json) => _$ConfirmUploadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmUploadDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


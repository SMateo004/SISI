//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'web_deletion_code_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WebDeletionCodeDto {
  /// Returns a new [WebDeletionCodeDto] instance.
  WebDeletionCodeDto({

    required  this.phone,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WebDeletionCodeDto &&
      other.phone == phone;

    @override
    int get hashCode =>
        phone.hashCode;

  factory WebDeletionCodeDto.fromJson(Map<String, dynamic> json) => _$WebDeletionCodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WebDeletionCodeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


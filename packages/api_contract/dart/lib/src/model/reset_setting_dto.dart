//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_setting_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ResetSettingDto {
  /// Returns a new [ResetSettingDto] instance.
  ResetSettingDto({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ResetSettingDto &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory ResetSettingDto.fromJson(Map<String, dynamic> json) => _$ResetSettingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetSettingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


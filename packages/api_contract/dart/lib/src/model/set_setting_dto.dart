//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_setting_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SetSettingDto {
  /// Returns a new [SetSettingDto] instance.
  SetSettingDto({

    required  this.value,

    required  this.reason,
  });

      /// Número en la unidad del parámetro (ms, días, Bs…) o los anillos, como texto
  @JsonKey(
    
    name: r'value',
    required: true,
    includeIfNull: false,
  )


  final String value;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SetSettingDto &&
      other.value == value &&
      other.reason == reason;

    @override
    int get hashCode =>
        value.hashCode +
        reason.hashCode;

  factory SetSettingDto.fromJson(Map<String, dynamic> json) => _$SetSettingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SetSettingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


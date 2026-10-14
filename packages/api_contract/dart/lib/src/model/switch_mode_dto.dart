//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'switch_mode_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SwitchModeDto {
  /// Returns a new [SwitchModeDto] instance.
  SwitchModeDto({

    required  this.mode,
  });

  @JsonKey(
    
    name: r'mode',
    required: true,
    includeIfNull: false,
  )


  final SwitchModeDtoModeEnum mode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SwitchModeDto &&
      other.mode == mode;

    @override
    int get hashCode =>
        mode.hashCode;

  factory SwitchModeDto.fromJson(Map<String, dynamic> json) => _$SwitchModeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SwitchModeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SwitchModeDtoModeEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const SwitchModeDtoModeEnum(this.value);

final String value;

@override
String toString() => value;
}



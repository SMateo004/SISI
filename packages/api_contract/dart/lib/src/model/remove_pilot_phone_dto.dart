//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remove_pilot_phone_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RemovePilotPhoneDto {
  /// Returns a new [RemovePilotPhoneDto] instance.
  RemovePilotPhoneDto({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RemovePilotPhoneDto &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory RemovePilotPhoneDto.fromJson(Map<String, dynamic> json) => _$RemovePilotPhoneDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RemovePilotPhoneDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


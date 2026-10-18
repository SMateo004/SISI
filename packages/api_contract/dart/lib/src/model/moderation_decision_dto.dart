//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moderation_decision_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModerationDecisionDto {
  /// Returns a new [ModerationDecisionDto] instance.
  ModerationDecisionDto({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ModerationDecisionDto &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory ModerationDecisionDto.fromJson(Map<String, dynamic> json) => _$ModerationDecisionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModerationDecisionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


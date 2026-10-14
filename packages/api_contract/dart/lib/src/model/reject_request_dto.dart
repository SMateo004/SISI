//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reject_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RejectRequestDto {
  /// Returns a new [RejectRequestDto] instance.
  RejectRequestDto({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RejectRequestDto &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory RejectRequestDto.fromJson(Map<String, dynamic> json) => _$RejectRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RejectRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


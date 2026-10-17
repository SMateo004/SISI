//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_counterpart_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobCounterpartDto {
  /// Returns a new [JobCounterpartDto] instance.
  JobCounterpartDto({

    required  this.userId,

    required  this.shortName,
  });

  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



  @JsonKey(
    
    name: r'shortName',
    required: true,
    includeIfNull: false,
  )


  final String shortName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobCounterpartDto &&
      other.userId == userId &&
      other.shortName == shortName;

    @override
    int get hashCode =>
        userId.hashCode +
        shortName.hashCode;

  factory JobCounterpartDto.fromJson(Map<String, dynamic> json) => _$JobCounterpartDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobCounterpartDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


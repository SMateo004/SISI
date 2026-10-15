//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_update_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LocationUpdateResultDto {
  /// Returns a new [LocationUpdateResultDto] instance.
  LocationUpdateResultDto({

    required  this.persisted,
  });

      /// false si se guardó solo la copia en vivo (throttling)
  @JsonKey(
    
    name: r'persisted',
    required: true,
    includeIfNull: false,
  )


  final bool persisted;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LocationUpdateResultDto &&
      other.persisted == persisted;

    @override
    int get hashCode =>
        persisted.hashCode;

  factory LocationUpdateResultDto.fromJson(Map<String, dynamic> json) => _$LocationUpdateResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationUpdateResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


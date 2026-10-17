//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracked_point_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrackedPointDto {
  /// Returns a new [TrackedPointDto] instance.
  TrackedPointDto({

    required  this.latitude,

    required  this.longitude,

    required  this.at,
  });

  @JsonKey(
    
    name: r'latitude',
    required: true,
    includeIfNull: false,
  )


  final num latitude;



  @JsonKey(
    
    name: r'longitude',
    required: true,
    includeIfNull: false,
  )


  final num longitude;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrackedPointDto &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.at == at;

    @override
    int get hashCode =>
        latitude.hashCode +
        longitude.hashCode +
        at.hashCode;

  factory TrackedPointDto.fromJson(Map<String, dynamic> json) => _$TrackedPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TrackedPointDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


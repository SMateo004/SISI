//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_update_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LocationUpdateDto {
  /// Returns a new [LocationUpdateDto] instance.
  LocationUpdateDto({

    required  this.latitude,

    required  this.longitude,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is LocationUpdateDto &&
      other.latitude == latitude &&
      other.longitude == longitude;

    @override
    int get hashCode =>
        latitude.hashCode +
        longitude.hashCode;

  factory LocationUpdateDto.fromJson(Map<String, dynamic> json) => _$LocationUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationUpdateDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


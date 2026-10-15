//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_availability_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SetAvailabilityDto {
  /// Returns a new [SetAvailabilityDto] instance.
  SetAvailabilityDto({

    required  this.available,

     this.latitude,

     this.longitude,
  });

      /// true = recibir solicitudes cercanas
  @JsonKey(
    
    name: r'available',
    required: true,
    includeIfNull: false,
  )


  final bool available;



      /// Obligatoria para activar
  @JsonKey(
    
    name: r'latitude',
    required: false,
    includeIfNull: false,
  )


  final num? latitude;



      /// Obligatoria para activar
  @JsonKey(
    
    name: r'longitude',
    required: false,
    includeIfNull: false,
  )


  final num? longitude;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SetAvailabilityDto &&
      other.available == available &&
      other.latitude == latitude &&
      other.longitude == longitude;

    @override
    int get hashCode =>
        available.hashCode +
        latitude.hashCode +
        longitude.hashCode;

  factory SetAvailabilityDto.fromJson(Map<String, dynamic> json) => _$SetAvailabilityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SetAvailabilityDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


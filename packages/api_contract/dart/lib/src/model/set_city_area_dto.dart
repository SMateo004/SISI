//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_city_area_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SetCityAreaDto {
  /// Returns a new [SetCityAreaDto] instance.
  SetCityAreaDto({

    required  this.geojson,

     this.radiusKm,

    required  this.reason,
  });

      /// GeoJSON Polygon ([longitud, latitud]); null para volver al radio
  @JsonKey(
    
    name: r'geojson',
    required: true,
    includeIfNull: true,
  )


  final String? geojson;



  @JsonKey(
    
    name: r'radiusKm',
    required: false,
    includeIfNull: false,
  )


  final num? radiusKm;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SetCityAreaDto &&
      other.geojson == geojson &&
      other.radiusKm == radiusKm &&
      other.reason == reason;

    @override
    int get hashCode =>
        (geojson == null ? 0 : geojson.hashCode) +
        radiusKm.hashCode +
        reason.hashCode;

  factory SetCityAreaDto.fromJson(Map<String, dynamic> json) => _$SetCityAreaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SetCityAreaDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


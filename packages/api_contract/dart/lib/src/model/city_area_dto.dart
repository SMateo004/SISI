//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_area_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CityAreaDto {
  /// Returns a new [CityAreaDto] instance.
  CityAreaDto({

    required  this.cityId,

    required  this.centerLat,

    required  this.centerLng,

    required  this.radiusKm,

    required  this.geojson,
  });

  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'centerLat',
    required: true,
    includeIfNull: true,
  )


  final num? centerLat;



  @JsonKey(
    
    name: r'centerLng',
    required: true,
    includeIfNull: true,
  )


  final num? centerLng;



      /// Radio si no hay polígono
  @JsonKey(
    
    name: r'radiusKm',
    required: true,
    includeIfNull: true,
  )


  final num? radiusKm;



      /// Polígono GeoJSON (texto); null = se usa el radio
  @JsonKey(
    
    name: r'geojson',
    required: true,
    includeIfNull: true,
  )


  final String? geojson;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CityAreaDto &&
      other.cityId == cityId &&
      other.centerLat == centerLat &&
      other.centerLng == centerLng &&
      other.radiusKm == radiusKm &&
      other.geojson == geojson;

    @override
    int get hashCode =>
        cityId.hashCode +
        (centerLat == null ? 0 : centerLat.hashCode) +
        (centerLng == null ? 0 : centerLng.hashCode) +
        (radiusKm == null ? 0 : radiusKm.hashCode) +
        (geojson == null ? 0 : geojson.hashCode);

  factory CityAreaDto.fromJson(Map<String, dynamic> json) => _$CityAreaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CityAreaDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_area_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CityAreaDtoCWProxy {
  CityAreaDto cityId(String cityId);

  CityAreaDto centerLat(num? centerLat);

  CityAreaDto centerLng(num? centerLng);

  CityAreaDto radiusKm(num? radiusKm);

  CityAreaDto geojson(String? geojson);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CityAreaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CityAreaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CityAreaDto call({
    String cityId,
    num? centerLat,
    num? centerLng,
    num? radiusKm,
    String? geojson,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCityAreaDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCityAreaDto.copyWith.fieldName(...)`
class _$CityAreaDtoCWProxyImpl implements _$CityAreaDtoCWProxy {
  const _$CityAreaDtoCWProxyImpl(this._value);

  final CityAreaDto _value;

  @override
  CityAreaDto cityId(String cityId) => this(cityId: cityId);

  @override
  CityAreaDto centerLat(num? centerLat) => this(centerLat: centerLat);

  @override
  CityAreaDto centerLng(num? centerLng) => this(centerLng: centerLng);

  @override
  CityAreaDto radiusKm(num? radiusKm) => this(radiusKm: radiusKm);

  @override
  CityAreaDto geojson(String? geojson) => this(geojson: geojson);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CityAreaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CityAreaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CityAreaDto call({
    Object? cityId = const $CopyWithPlaceholder(),
    Object? centerLat = const $CopyWithPlaceholder(),
    Object? centerLng = const $CopyWithPlaceholder(),
    Object? radiusKm = const $CopyWithPlaceholder(),
    Object? geojson = const $CopyWithPlaceholder(),
  }) {
    return CityAreaDto(
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      centerLat: centerLat == const $CopyWithPlaceholder()
          ? _value.centerLat
          // ignore: cast_nullable_to_non_nullable
          : centerLat as num?,
      centerLng: centerLng == const $CopyWithPlaceholder()
          ? _value.centerLng
          // ignore: cast_nullable_to_non_nullable
          : centerLng as num?,
      radiusKm: radiusKm == const $CopyWithPlaceholder()
          ? _value.radiusKm
          // ignore: cast_nullable_to_non_nullable
          : radiusKm as num?,
      geojson: geojson == const $CopyWithPlaceholder()
          ? _value.geojson
          // ignore: cast_nullable_to_non_nullable
          : geojson as String?,
    );
  }
}

extension $CityAreaDtoCopyWith on CityAreaDto {
  /// Returns a callable class that can be used as follows: `instanceOfCityAreaDto.copyWith(...)` or like so:`instanceOfCityAreaDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CityAreaDtoCWProxy get copyWith => _$CityAreaDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityAreaDto _$CityAreaDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CityAreaDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'cityId',
          'centerLat',
          'centerLng',
          'radiusKm',
          'geojson',
        ],
      );
      final val = CityAreaDto(
        cityId: $checkedConvert('cityId', (v) => v as String),
        centerLat: $checkedConvert('centerLat', (v) => v as num?),
        centerLng: $checkedConvert('centerLng', (v) => v as num?),
        radiusKm: $checkedConvert('radiusKm', (v) => v as num?),
        geojson: $checkedConvert('geojson', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CityAreaDtoToJson(CityAreaDto instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'centerLat': instance.centerLat,
      'centerLng': instance.centerLng,
      'radiusKm': instance.radiusKm,
      'geojson': instance.geojson,
    };

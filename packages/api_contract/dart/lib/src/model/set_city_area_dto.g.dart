// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_city_area_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SetCityAreaDtoCWProxy {
  SetCityAreaDto geojson(String? geojson);

  SetCityAreaDto radiusKm(num? radiusKm);

  SetCityAreaDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetCityAreaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetCityAreaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetCityAreaDto call({String? geojson, num? radiusKm, String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetCityAreaDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetCityAreaDto.copyWith.fieldName(...)`
class _$SetCityAreaDtoCWProxyImpl implements _$SetCityAreaDtoCWProxy {
  const _$SetCityAreaDtoCWProxyImpl(this._value);

  final SetCityAreaDto _value;

  @override
  SetCityAreaDto geojson(String? geojson) => this(geojson: geojson);

  @override
  SetCityAreaDto radiusKm(num? radiusKm) => this(radiusKm: radiusKm);

  @override
  SetCityAreaDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetCityAreaDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetCityAreaDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetCityAreaDto call({
    Object? geojson = const $CopyWithPlaceholder(),
    Object? radiusKm = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return SetCityAreaDto(
      geojson: geojson == const $CopyWithPlaceholder()
          ? _value.geojson
          // ignore: cast_nullable_to_non_nullable
          : geojson as String?,
      radiusKm: radiusKm == const $CopyWithPlaceholder()
          ? _value.radiusKm
          // ignore: cast_nullable_to_non_nullable
          : radiusKm as num?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $SetCityAreaDtoCopyWith on SetCityAreaDto {
  /// Returns a callable class that can be used as follows: `instanceOfSetCityAreaDto.copyWith(...)` or like so:`instanceOfSetCityAreaDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SetCityAreaDtoCWProxy get copyWith => _$SetCityAreaDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetCityAreaDto _$SetCityAreaDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetCityAreaDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['geojson', 'reason']);
      final val = SetCityAreaDto(
        geojson: $checkedConvert('geojson', (v) => v as String?),
        radiusKm: $checkedConvert('radiusKm', (v) => v as num?),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SetCityAreaDtoToJson(SetCityAreaDto instance) =>
    <String, dynamic>{
      'geojson': instance.geojson,
      'radiusKm': ?instance.radiusKm,
      'reason': instance.reason,
    };

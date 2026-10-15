// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocationUpdateDtoCWProxy {
  LocationUpdateDto latitude(num latitude);

  LocationUpdateDto longitude(num longitude);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationUpdateDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationUpdateDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationUpdateDto call({num latitude, num longitude});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocationUpdateDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocationUpdateDto.copyWith.fieldName(...)`
class _$LocationUpdateDtoCWProxyImpl implements _$LocationUpdateDtoCWProxy {
  const _$LocationUpdateDtoCWProxyImpl(this._value);

  final LocationUpdateDto _value;

  @override
  LocationUpdateDto latitude(num latitude) => this(latitude: latitude);

  @override
  LocationUpdateDto longitude(num longitude) => this(longitude: longitude);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationUpdateDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationUpdateDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationUpdateDto call({
    Object? latitude = const $CopyWithPlaceholder(),
    Object? longitude = const $CopyWithPlaceholder(),
  }) {
    return LocationUpdateDto(
      latitude: latitude == const $CopyWithPlaceholder()
          ? _value.latitude
          // ignore: cast_nullable_to_non_nullable
          : latitude as num,
      longitude: longitude == const $CopyWithPlaceholder()
          ? _value.longitude
          // ignore: cast_nullable_to_non_nullable
          : longitude as num,
    );
  }
}

extension $LocationUpdateDtoCopyWith on LocationUpdateDto {
  /// Returns a callable class that can be used as follows: `instanceOfLocationUpdateDto.copyWith(...)` or like so:`instanceOfLocationUpdateDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocationUpdateDtoCWProxy get copyWith =>
      _$LocationUpdateDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdateDto _$LocationUpdateDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LocationUpdateDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['latitude', 'longitude']);
      final val = LocationUpdateDto(
        latitude: $checkedConvert('latitude', (v) => v as num),
        longitude: $checkedConvert('longitude', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$LocationUpdateDtoToJson(LocationUpdateDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

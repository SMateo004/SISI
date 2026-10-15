// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_availability_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SetAvailabilityDtoCWProxy {
  SetAvailabilityDto available(bool available);

  SetAvailabilityDto latitude(num? latitude);

  SetAvailabilityDto longitude(num? longitude);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetAvailabilityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetAvailabilityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetAvailabilityDto call({bool available, num? latitude, num? longitude});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetAvailabilityDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetAvailabilityDto.copyWith.fieldName(...)`
class _$SetAvailabilityDtoCWProxyImpl implements _$SetAvailabilityDtoCWProxy {
  const _$SetAvailabilityDtoCWProxyImpl(this._value);

  final SetAvailabilityDto _value;

  @override
  SetAvailabilityDto available(bool available) => this(available: available);

  @override
  SetAvailabilityDto latitude(num? latitude) => this(latitude: latitude);

  @override
  SetAvailabilityDto longitude(num? longitude) => this(longitude: longitude);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetAvailabilityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetAvailabilityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetAvailabilityDto call({
    Object? available = const $CopyWithPlaceholder(),
    Object? latitude = const $CopyWithPlaceholder(),
    Object? longitude = const $CopyWithPlaceholder(),
  }) {
    return SetAvailabilityDto(
      available: available == const $CopyWithPlaceholder()
          ? _value.available
          // ignore: cast_nullable_to_non_nullable
          : available as bool,
      latitude: latitude == const $CopyWithPlaceholder()
          ? _value.latitude
          // ignore: cast_nullable_to_non_nullable
          : latitude as num?,
      longitude: longitude == const $CopyWithPlaceholder()
          ? _value.longitude
          // ignore: cast_nullable_to_non_nullable
          : longitude as num?,
    );
  }
}

extension $SetAvailabilityDtoCopyWith on SetAvailabilityDto {
  /// Returns a callable class that can be used as follows: `instanceOfSetAvailabilityDto.copyWith(...)` or like so:`instanceOfSetAvailabilityDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SetAvailabilityDtoCWProxy get copyWith =>
      _$SetAvailabilityDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetAvailabilityDto _$SetAvailabilityDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetAvailabilityDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['available']);
      final val = SetAvailabilityDto(
        available: $checkedConvert('available', (v) => v as bool),
        latitude: $checkedConvert('latitude', (v) => v as num?),
        longitude: $checkedConvert('longitude', (v) => v as num?),
      );
      return val;
    });

Map<String, dynamic> _$SetAvailabilityDtoToJson(SetAvailabilityDto instance) =>
    <String, dynamic>{
      'available': instance.available,
      'latitude': ?instance.latitude,
      'longitude': ?instance.longitude,
    };

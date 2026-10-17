// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracked_point_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrackedPointDtoCWProxy {
  TrackedPointDto latitude(num latitude);

  TrackedPointDto longitude(num longitude);

  TrackedPointDto at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackedPointDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackedPointDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackedPointDto call({num latitude, num longitude, DateTime at});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrackedPointDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrackedPointDto.copyWith.fieldName(...)`
class _$TrackedPointDtoCWProxyImpl implements _$TrackedPointDtoCWProxy {
  const _$TrackedPointDtoCWProxyImpl(this._value);

  final TrackedPointDto _value;

  @override
  TrackedPointDto latitude(num latitude) => this(latitude: latitude);

  @override
  TrackedPointDto longitude(num longitude) => this(longitude: longitude);

  @override
  TrackedPointDto at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackedPointDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackedPointDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackedPointDto call({
    Object? latitude = const $CopyWithPlaceholder(),
    Object? longitude = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return TrackedPointDto(
      latitude: latitude == const $CopyWithPlaceholder()
          ? _value.latitude
          // ignore: cast_nullable_to_non_nullable
          : latitude as num,
      longitude: longitude == const $CopyWithPlaceholder()
          ? _value.longitude
          // ignore: cast_nullable_to_non_nullable
          : longitude as num,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $TrackedPointDtoCopyWith on TrackedPointDto {
  /// Returns a callable class that can be used as follows: `instanceOfTrackedPointDto.copyWith(...)` or like so:`instanceOfTrackedPointDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrackedPointDtoCWProxy get copyWith => _$TrackedPointDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackedPointDto _$TrackedPointDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrackedPointDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['latitude', 'longitude', 'at']);
      final val = TrackedPointDto(
        latitude: $checkedConvert('latitude', (v) => v as num),
        longitude: $checkedConvert('longitude', (v) => v as num),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$TrackedPointDtoToJson(TrackedPointDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'at': instance.at.toIso8601String(),
    };

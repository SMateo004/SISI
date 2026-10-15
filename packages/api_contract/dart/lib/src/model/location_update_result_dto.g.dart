// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocationUpdateResultDtoCWProxy {
  LocationUpdateResultDto persisted(bool persisted);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationUpdateResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationUpdateResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationUpdateResultDto call({bool persisted});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocationUpdateResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocationUpdateResultDto.copyWith.fieldName(...)`
class _$LocationUpdateResultDtoCWProxyImpl
    implements _$LocationUpdateResultDtoCWProxy {
  const _$LocationUpdateResultDtoCWProxyImpl(this._value);

  final LocationUpdateResultDto _value;

  @override
  LocationUpdateResultDto persisted(bool persisted) =>
      this(persisted: persisted);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationUpdateResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationUpdateResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationUpdateResultDto call({
    Object? persisted = const $CopyWithPlaceholder(),
  }) {
    return LocationUpdateResultDto(
      persisted: persisted == const $CopyWithPlaceholder()
          ? _value.persisted
          // ignore: cast_nullable_to_non_nullable
          : persisted as bool,
    );
  }
}

extension $LocationUpdateResultDtoCopyWith on LocationUpdateResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfLocationUpdateResultDto.copyWith(...)` or like so:`instanceOfLocationUpdateResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocationUpdateResultDtoCWProxy get copyWith =>
      _$LocationUpdateResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdateResultDto _$LocationUpdateResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LocationUpdateResultDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['persisted']);
  final val = LocationUpdateResultDto(
    persisted: $checkedConvert('persisted', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$LocationUpdateResultDtoToJson(
  LocationUpdateResultDto instance,
) => <String, dynamic>{'persisted': instance.persisted};

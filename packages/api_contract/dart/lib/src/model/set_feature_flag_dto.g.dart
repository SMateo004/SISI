// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_feature_flag_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SetFeatureFlagDtoCWProxy {
  SetFeatureFlagDto enabled(bool enabled);

  SetFeatureFlagDto cityId(String? cityId);

  SetFeatureFlagDto description(String? description);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetFeatureFlagDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetFeatureFlagDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetFeatureFlagDto call({bool enabled, String? cityId, String? description});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetFeatureFlagDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetFeatureFlagDto.copyWith.fieldName(...)`
class _$SetFeatureFlagDtoCWProxyImpl implements _$SetFeatureFlagDtoCWProxy {
  const _$SetFeatureFlagDtoCWProxyImpl(this._value);

  final SetFeatureFlagDto _value;

  @override
  SetFeatureFlagDto enabled(bool enabled) => this(enabled: enabled);

  @override
  SetFeatureFlagDto cityId(String? cityId) => this(cityId: cityId);

  @override
  SetFeatureFlagDto description(String? description) =>
      this(description: description);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetFeatureFlagDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetFeatureFlagDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetFeatureFlagDto call({
    Object? enabled = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
  }) {
    return SetFeatureFlagDto(
      enabled: enabled == const $CopyWithPlaceholder()
          ? _value.enabled
          // ignore: cast_nullable_to_non_nullable
          : enabled as bool,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
    );
  }
}

extension $SetFeatureFlagDtoCopyWith on SetFeatureFlagDto {
  /// Returns a callable class that can be used as follows: `instanceOfSetFeatureFlagDto.copyWith(...)` or like so:`instanceOfSetFeatureFlagDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SetFeatureFlagDtoCWProxy get copyWith =>
      _$SetFeatureFlagDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetFeatureFlagDto _$SetFeatureFlagDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetFeatureFlagDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['enabled']);
      final val = SetFeatureFlagDto(
        enabled: $checkedConvert('enabled', (v) => v as bool),
        cityId: $checkedConvert('cityId', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SetFeatureFlagDtoToJson(SetFeatureFlagDto instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'cityId': ?instance.cityId,
      'description': ?instance.description,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flag_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeatureFlagDtoCWProxy {
  FeatureFlagDto key(String key);

  FeatureFlagDto cityId(String? cityId);

  FeatureFlagDto enabled(bool enabled);

  FeatureFlagDto description(String? description);

  FeatureFlagDto updatedAt(String updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeatureFlagDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeatureFlagDto(...).copyWith(id: 12, name: "My name")
  /// ````
  FeatureFlagDto call({
    String key,
    String? cityId,
    bool enabled,
    String? description,
    String updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeatureFlagDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeatureFlagDto.copyWith.fieldName(...)`
class _$FeatureFlagDtoCWProxyImpl implements _$FeatureFlagDtoCWProxy {
  const _$FeatureFlagDtoCWProxyImpl(this._value);

  final FeatureFlagDto _value;

  @override
  FeatureFlagDto key(String key) => this(key: key);

  @override
  FeatureFlagDto cityId(String? cityId) => this(cityId: cityId);

  @override
  FeatureFlagDto enabled(bool enabled) => this(enabled: enabled);

  @override
  FeatureFlagDto description(String? description) =>
      this(description: description);

  @override
  FeatureFlagDto updatedAt(String updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeatureFlagDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeatureFlagDto(...).copyWith(id: 12, name: "My name")
  /// ````
  FeatureFlagDto call({
    Object? key = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? enabled = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return FeatureFlagDto(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String?,
      enabled: enabled == const $CopyWithPlaceholder()
          ? _value.enabled
          // ignore: cast_nullable_to_non_nullable
          : enabled as bool,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as String,
    );
  }
}

extension $FeatureFlagDtoCopyWith on FeatureFlagDto {
  /// Returns a callable class that can be used as follows: `instanceOfFeatureFlagDto.copyWith(...)` or like so:`instanceOfFeatureFlagDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeatureFlagDtoCWProxy get copyWith => _$FeatureFlagDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureFlagDto _$FeatureFlagDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FeatureFlagDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'key',
          'cityId',
          'enabled',
          'description',
          'updatedAt',
        ],
      );
      final val = FeatureFlagDto(
        key: $checkedConvert('key', (v) => v as String),
        cityId: $checkedConvert('cityId', (v) => v as String?),
        enabled: $checkedConvert('enabled', (v) => v as bool),
        description: $checkedConvert('description', (v) => v as String?),
        updatedAt: $checkedConvert('updatedAt', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$FeatureFlagDtoToJson(FeatureFlagDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'cityId': instance.cityId,
      'enabled': instance.enabled,
      'description': instance.description,
      'updatedAt': instance.updatedAt,
    };

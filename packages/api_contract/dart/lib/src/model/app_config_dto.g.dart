// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigDtoCWProxy {
  AppConfigDto platform(AppConfigDtoPlatformEnum platform);

  AppConfigDto minVersion(String minVersion);

  AppConfigDto upgradeRequired(bool upgradeRequired);

  AppConfigDto storeUrl(String? storeUrl);

  AppConfigDto support(SupportDto? support);

  AppConfigDto legal(List<LegalVersionDto> legal);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigDto call({
    AppConfigDtoPlatformEnum platform,
    String minVersion,
    bool upgradeRequired,
    String? storeUrl,
    SupportDto? support,
    List<LegalVersionDto> legal,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppConfigDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppConfigDto.copyWith.fieldName(...)`
class _$AppConfigDtoCWProxyImpl implements _$AppConfigDtoCWProxy {
  const _$AppConfigDtoCWProxyImpl(this._value);

  final AppConfigDto _value;

  @override
  AppConfigDto platform(AppConfigDtoPlatformEnum platform) =>
      this(platform: platform);

  @override
  AppConfigDto minVersion(String minVersion) => this(minVersion: minVersion);

  @override
  AppConfigDto upgradeRequired(bool upgradeRequired) =>
      this(upgradeRequired: upgradeRequired);

  @override
  AppConfigDto storeUrl(String? storeUrl) => this(storeUrl: storeUrl);

  @override
  AppConfigDto support(SupportDto? support) => this(support: support);

  @override
  AppConfigDto legal(List<LegalVersionDto> legal) => this(legal: legal);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigDto call({
    Object? platform = const $CopyWithPlaceholder(),
    Object? minVersion = const $CopyWithPlaceholder(),
    Object? upgradeRequired = const $CopyWithPlaceholder(),
    Object? storeUrl = const $CopyWithPlaceholder(),
    Object? support = const $CopyWithPlaceholder(),
    Object? legal = const $CopyWithPlaceholder(),
  }) {
    return AppConfigDto(
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as AppConfigDtoPlatformEnum,
      minVersion: minVersion == const $CopyWithPlaceholder()
          ? _value.minVersion
          // ignore: cast_nullable_to_non_nullable
          : minVersion as String,
      upgradeRequired: upgradeRequired == const $CopyWithPlaceholder()
          ? _value.upgradeRequired
          // ignore: cast_nullable_to_non_nullable
          : upgradeRequired as bool,
      storeUrl: storeUrl == const $CopyWithPlaceholder()
          ? _value.storeUrl
          // ignore: cast_nullable_to_non_nullable
          : storeUrl as String?,
      support: support == const $CopyWithPlaceholder()
          ? _value.support
          // ignore: cast_nullable_to_non_nullable
          : support as SupportDto?,
      legal: legal == const $CopyWithPlaceholder()
          ? _value.legal
          // ignore: cast_nullable_to_non_nullable
          : legal as List<LegalVersionDto>,
    );
  }
}

extension $AppConfigDtoCopyWith on AppConfigDto {
  /// Returns a callable class that can be used as follows: `instanceOfAppConfigDto.copyWith(...)` or like so:`instanceOfAppConfigDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigDtoCWProxy get copyWith => _$AppConfigDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigDto _$AppConfigDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AppConfigDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'platform',
          'minVersion',
          'upgradeRequired',
          'storeUrl',
          'support',
          'legal',
        ],
      );
      final val = AppConfigDto(
        platform: $checkedConvert(
          'platform',
          (v) => $enumDecode(_$AppConfigDtoPlatformEnumEnumMap, v),
        ),
        minVersion: $checkedConvert('minVersion', (v) => v as String),
        upgradeRequired: $checkedConvert('upgradeRequired', (v) => v as bool),
        storeUrl: $checkedConvert('storeUrl', (v) => v as String?),
        support: $checkedConvert(
          'support',
          (v) =>
              v == null ? null : SupportDto.fromJson(v as Map<String, dynamic>),
        ),
        legal: $checkedConvert(
          'legal',
          (v) => (v as List<dynamic>)
              .map((e) => LegalVersionDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AppConfigDtoToJson(AppConfigDto instance) =>
    <String, dynamic>{
      'platform': _$AppConfigDtoPlatformEnumEnumMap[instance.platform]!,
      'minVersion': instance.minVersion,
      'upgradeRequired': instance.upgradeRequired,
      'storeUrl': instance.storeUrl,
      'support': instance.support?.toJson(),
      'legal': instance.legal.map((e) => e.toJson()).toList(),
    };

const _$AppConfigDtoPlatformEnumEnumMap = {
  AppConfigDtoPlatformEnum.android: 'android',
  AppConfigDtoPlatformEnum.ios: 'ios',
  AppConfigDtoPlatformEnum.web: 'web',
};

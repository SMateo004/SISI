// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_legal_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AcceptLegalDtoCWProxy {
  AcceptLegalDto termsVersion(num termsVersion);

  AcceptLegalDto privacyVersion(num privacyVersion);

  AcceptLegalDto adult(bool adult);

  AcceptLegalDto appVersion(String? appVersion);

  AcceptLegalDto platform(AcceptLegalDtoPlatformEnum? platform);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AcceptLegalDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AcceptLegalDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AcceptLegalDto call({
    num termsVersion,
    num privacyVersion,
    bool adult,
    String? appVersion,
    AcceptLegalDtoPlatformEnum? platform,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAcceptLegalDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAcceptLegalDto.copyWith.fieldName(...)`
class _$AcceptLegalDtoCWProxyImpl implements _$AcceptLegalDtoCWProxy {
  const _$AcceptLegalDtoCWProxyImpl(this._value);

  final AcceptLegalDto _value;

  @override
  AcceptLegalDto termsVersion(num termsVersion) =>
      this(termsVersion: termsVersion);

  @override
  AcceptLegalDto privacyVersion(num privacyVersion) =>
      this(privacyVersion: privacyVersion);

  @override
  AcceptLegalDto adult(bool adult) => this(adult: adult);

  @override
  AcceptLegalDto appVersion(String? appVersion) => this(appVersion: appVersion);

  @override
  AcceptLegalDto platform(AcceptLegalDtoPlatformEnum? platform) =>
      this(platform: platform);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AcceptLegalDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AcceptLegalDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AcceptLegalDto call({
    Object? termsVersion = const $CopyWithPlaceholder(),
    Object? privacyVersion = const $CopyWithPlaceholder(),
    Object? adult = const $CopyWithPlaceholder(),
    Object? appVersion = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
  }) {
    return AcceptLegalDto(
      termsVersion: termsVersion == const $CopyWithPlaceholder()
          ? _value.termsVersion
          // ignore: cast_nullable_to_non_nullable
          : termsVersion as num,
      privacyVersion: privacyVersion == const $CopyWithPlaceholder()
          ? _value.privacyVersion
          // ignore: cast_nullable_to_non_nullable
          : privacyVersion as num,
      adult: adult == const $CopyWithPlaceholder()
          ? _value.adult
          // ignore: cast_nullable_to_non_nullable
          : adult as bool,
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String?,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as AcceptLegalDtoPlatformEnum?,
    );
  }
}

extension $AcceptLegalDtoCopyWith on AcceptLegalDto {
  /// Returns a callable class that can be used as follows: `instanceOfAcceptLegalDto.copyWith(...)` or like so:`instanceOfAcceptLegalDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AcceptLegalDtoCWProxy get copyWith => _$AcceptLegalDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptLegalDto _$AcceptLegalDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AcceptLegalDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['termsVersion', 'privacyVersion', 'adult'],
      );
      final val = AcceptLegalDto(
        termsVersion: $checkedConvert('termsVersion', (v) => v as num),
        privacyVersion: $checkedConvert('privacyVersion', (v) => v as num),
        adult: $checkedConvert('adult', (v) => v as bool),
        appVersion: $checkedConvert('appVersion', (v) => v as String?),
        platform: $checkedConvert(
          'platform',
          (v) => $enumDecodeNullable(_$AcceptLegalDtoPlatformEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AcceptLegalDtoToJson(AcceptLegalDto instance) =>
    <String, dynamic>{
      'termsVersion': instance.termsVersion,
      'privacyVersion': instance.privacyVersion,
      'adult': instance.adult,
      'appVersion': ?instance.appVersion,
      'platform': ?_$AcceptLegalDtoPlatformEnumEnumMap[instance.platform],
    };

const _$AcceptLegalDtoPlatformEnumEnumMap = {
  AcceptLegalDtoPlatformEnum.android: 'android',
  AcceptLegalDtoPlatformEnum.ios: 'ios',
  AcceptLegalDtoPlatformEnum.web: 'web',
};

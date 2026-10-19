// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_code_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpCodeDtoCWProxy {
  OtpCodeDto phone(String phone);

  OtpCodeDto code(String code);

  OtpCodeDto sentAt(DateTime sentAt);

  OtpCodeDto expiresAt(DateTime expiresAt);

  OtpCodeDto usedAt(DateTime? usedAt);

  OtpCodeDto accountExists(bool accountExists);

  OtpCodeDto name(String? name);

  OtpCodeDto activeMode(OtpCodeDtoActiveModeEnum? activeMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpCodeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpCodeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpCodeDto call({
    String phone,
    String code,
    DateTime sentAt,
    DateTime expiresAt,
    DateTime? usedAt,
    bool accountExists,
    String? name,
    OtpCodeDtoActiveModeEnum? activeMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpCodeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpCodeDto.copyWith.fieldName(...)`
class _$OtpCodeDtoCWProxyImpl implements _$OtpCodeDtoCWProxy {
  const _$OtpCodeDtoCWProxyImpl(this._value);

  final OtpCodeDto _value;

  @override
  OtpCodeDto phone(String phone) => this(phone: phone);

  @override
  OtpCodeDto code(String code) => this(code: code);

  @override
  OtpCodeDto sentAt(DateTime sentAt) => this(sentAt: sentAt);

  @override
  OtpCodeDto expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  OtpCodeDto usedAt(DateTime? usedAt) => this(usedAt: usedAt);

  @override
  OtpCodeDto accountExists(bool accountExists) =>
      this(accountExists: accountExists);

  @override
  OtpCodeDto name(String? name) => this(name: name);

  @override
  OtpCodeDto activeMode(OtpCodeDtoActiveModeEnum? activeMode) =>
      this(activeMode: activeMode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpCodeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpCodeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpCodeDto call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? sentAt = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
    Object? usedAt = const $CopyWithPlaceholder(),
    Object? accountExists = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? activeMode = const $CopyWithPlaceholder(),
  }) {
    return OtpCodeDto(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      sentAt: sentAt == const $CopyWithPlaceholder()
          ? _value.sentAt
          // ignore: cast_nullable_to_non_nullable
          : sentAt as DateTime,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
      usedAt: usedAt == const $CopyWithPlaceholder()
          ? _value.usedAt
          // ignore: cast_nullable_to_non_nullable
          : usedAt as DateTime?,
      accountExists: accountExists == const $CopyWithPlaceholder()
          ? _value.accountExists
          // ignore: cast_nullable_to_non_nullable
          : accountExists as bool,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      activeMode: activeMode == const $CopyWithPlaceholder()
          ? _value.activeMode
          // ignore: cast_nullable_to_non_nullable
          : activeMode as OtpCodeDtoActiveModeEnum?,
    );
  }
}

extension $OtpCodeDtoCopyWith on OtpCodeDto {
  /// Returns a callable class that can be used as follows: `instanceOfOtpCodeDto.copyWith(...)` or like so:`instanceOfOtpCodeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpCodeDtoCWProxy get copyWith => _$OtpCodeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpCodeDto _$OtpCodeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpCodeDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'phone',
          'code',
          'sentAt',
          'expiresAt',
          'accountExists',
        ],
      );
      final val = OtpCodeDto(
        phone: $checkedConvert('phone', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
        sentAt: $checkedConvert('sentAt', (v) => DateTime.parse(v as String)),
        expiresAt: $checkedConvert(
          'expiresAt',
          (v) => DateTime.parse(v as String),
        ),
        usedAt: $checkedConvert(
          'usedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        accountExists: $checkedConvert('accountExists', (v) => v as bool),
        name: $checkedConvert('name', (v) => v as String?),
        activeMode: $checkedConvert(
          'activeMode',
          (v) => $enumDecodeNullable(_$OtpCodeDtoActiveModeEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OtpCodeDtoToJson(OtpCodeDto instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'code': instance.code,
      'sentAt': instance.sentAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'usedAt': ?instance.usedAt?.toIso8601String(),
      'accountExists': instance.accountExists,
      'name': ?instance.name,
      'activeMode': ?_$OtpCodeDtoActiveModeEnumEnumMap[instance.activeMode],
    };

const _$OtpCodeDtoActiveModeEnumEnumMap = {
  OtpCodeDtoActiveModeEnum.employer: 'employer',
  OtpCodeDtoActiveModeEnum.worker: 'worker',
};

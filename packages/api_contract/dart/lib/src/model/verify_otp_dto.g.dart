// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerifyOtpDtoCWProxy {
  VerifyOtpDto phone(String phone);

  VerifyOtpDto code(String code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerifyOtpDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerifyOtpDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerifyOtpDto call({String phone, String code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerifyOtpDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerifyOtpDto.copyWith.fieldName(...)`
class _$VerifyOtpDtoCWProxyImpl implements _$VerifyOtpDtoCWProxy {
  const _$VerifyOtpDtoCWProxyImpl(this._value);

  final VerifyOtpDto _value;

  @override
  VerifyOtpDto phone(String phone) => this(phone: phone);

  @override
  VerifyOtpDto code(String code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerifyOtpDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerifyOtpDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerifyOtpDto call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
  }) {
    return VerifyOtpDto(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
    );
  }
}

extension $VerifyOtpDtoCopyWith on VerifyOtpDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerifyOtpDto.copyWith(...)` or like so:`instanceOfVerifyOtpDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerifyOtpDtoCWProxy get copyWith => _$VerifyOtpDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpDto _$VerifyOtpDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VerifyOtpDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone', 'code']);
      final val = VerifyOtpDto(
        phone: $checkedConvert('phone', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$VerifyOtpDtoToJson(VerifyOtpDto instance) =>
    <String, dynamic>{'phone': instance.phone, 'code': instance.code};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_requested_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpRequestedDtoCWProxy {
  OtpRequestedDto expiresInSec(num expiresInSec);

  OtpRequestedDto resendInSec(num resendInSec);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpRequestedDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpRequestedDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpRequestedDto call({num expiresInSec, num resendInSec});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpRequestedDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpRequestedDto.copyWith.fieldName(...)`
class _$OtpRequestedDtoCWProxyImpl implements _$OtpRequestedDtoCWProxy {
  const _$OtpRequestedDtoCWProxyImpl(this._value);

  final OtpRequestedDto _value;

  @override
  OtpRequestedDto expiresInSec(num expiresInSec) =>
      this(expiresInSec: expiresInSec);

  @override
  OtpRequestedDto resendInSec(num resendInSec) =>
      this(resendInSec: resendInSec);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpRequestedDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpRequestedDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpRequestedDto call({
    Object? expiresInSec = const $CopyWithPlaceholder(),
    Object? resendInSec = const $CopyWithPlaceholder(),
  }) {
    return OtpRequestedDto(
      expiresInSec: expiresInSec == const $CopyWithPlaceholder()
          ? _value.expiresInSec
          // ignore: cast_nullable_to_non_nullable
          : expiresInSec as num,
      resendInSec: resendInSec == const $CopyWithPlaceholder()
          ? _value.resendInSec
          // ignore: cast_nullable_to_non_nullable
          : resendInSec as num,
    );
  }
}

extension $OtpRequestedDtoCopyWith on OtpRequestedDto {
  /// Returns a callable class that can be used as follows: `instanceOfOtpRequestedDto.copyWith(...)` or like so:`instanceOfOtpRequestedDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpRequestedDtoCWProxy get copyWith => _$OtpRequestedDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestedDto _$OtpRequestedDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpRequestedDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['expiresInSec', 'resendInSec']);
      final val = OtpRequestedDto(
        expiresInSec: $checkedConvert('expiresInSec', (v) => v as num),
        resendInSec: $checkedConvert('resendInSec', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$OtpRequestedDtoToJson(OtpRequestedDto instance) =>
    <String, dynamic>{
      'expiresInSec': instance.expiresInSec,
      'resendInSec': instance.resendInSec,
    };

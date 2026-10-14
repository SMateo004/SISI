// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_otp_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RequestOtpDtoCWProxy {
  RequestOtpDto phone(String phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestOtpDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestOtpDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestOtpDto call({String phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRequestOtpDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRequestOtpDto.copyWith.fieldName(...)`
class _$RequestOtpDtoCWProxyImpl implements _$RequestOtpDtoCWProxy {
  const _$RequestOtpDtoCWProxyImpl(this._value);

  final RequestOtpDto _value;

  @override
  RequestOtpDto phone(String phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestOtpDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestOtpDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestOtpDto call({Object? phone = const $CopyWithPlaceholder()}) {
    return RequestOtpDto(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
    );
  }
}

extension $RequestOtpDtoCopyWith on RequestOtpDto {
  /// Returns a callable class that can be used as follows: `instanceOfRequestOtpDto.copyWith(...)` or like so:`instanceOfRequestOtpDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RequestOtpDtoCWProxy get copyWith => _$RequestOtpDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestOtpDto _$RequestOtpDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RequestOtpDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone']);
      final val = RequestOtpDto(
        phone: $checkedConvert('phone', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RequestOtpDtoToJson(RequestOtpDto instance) =>
    <String, dynamic>{'phone': instance.phone};

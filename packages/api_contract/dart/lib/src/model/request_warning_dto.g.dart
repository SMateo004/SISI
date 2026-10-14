// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_warning_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RequestWarningDtoCWProxy {
  RequestWarningDto code(String code);

  RequestWarningDto message(String message);

  RequestWarningDto referenceMinBs(String referenceMinBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestWarningDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestWarningDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestWarningDto call({String code, String message, String referenceMinBs});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRequestWarningDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRequestWarningDto.copyWith.fieldName(...)`
class _$RequestWarningDtoCWProxyImpl implements _$RequestWarningDtoCWProxy {
  const _$RequestWarningDtoCWProxyImpl(this._value);

  final RequestWarningDto _value;

  @override
  RequestWarningDto code(String code) => this(code: code);

  @override
  RequestWarningDto message(String message) => this(message: message);

  @override
  RequestWarningDto referenceMinBs(String referenceMinBs) =>
      this(referenceMinBs: referenceMinBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestWarningDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestWarningDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestWarningDto call({
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? referenceMinBs = const $CopyWithPlaceholder(),
  }) {
    return RequestWarningDto(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      referenceMinBs: referenceMinBs == const $CopyWithPlaceholder()
          ? _value.referenceMinBs
          // ignore: cast_nullable_to_non_nullable
          : referenceMinBs as String,
    );
  }
}

extension $RequestWarningDtoCopyWith on RequestWarningDto {
  /// Returns a callable class that can be used as follows: `instanceOfRequestWarningDto.copyWith(...)` or like so:`instanceOfRequestWarningDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RequestWarningDtoCWProxy get copyWith =>
      _$RequestWarningDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestWarningDto _$RequestWarningDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RequestWarningDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['code', 'message', 'referenceMinBs'],
      );
      final val = RequestWarningDto(
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
        referenceMinBs: $checkedConvert('referenceMinBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RequestWarningDtoToJson(RequestWarningDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'referenceMinBs': instance.referenceMinBs,
    };

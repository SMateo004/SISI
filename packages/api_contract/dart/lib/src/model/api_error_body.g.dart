// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_body.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApiErrorBodyCWProxy {
  ApiErrorBody statusCode(num statusCode);

  ApiErrorBody code(String code);

  ApiErrorBody message(String message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApiErrorBody(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApiErrorBody(...).copyWith(id: 12, name: "My name")
  /// ````
  ApiErrorBody call({num statusCode, String code, String message});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApiErrorBody.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApiErrorBody.copyWith.fieldName(...)`
class _$ApiErrorBodyCWProxyImpl implements _$ApiErrorBodyCWProxy {
  const _$ApiErrorBodyCWProxyImpl(this._value);

  final ApiErrorBody _value;

  @override
  ApiErrorBody statusCode(num statusCode) => this(statusCode: statusCode);

  @override
  ApiErrorBody code(String code) => this(code: code);

  @override
  ApiErrorBody message(String message) => this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApiErrorBody(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApiErrorBody(...).copyWith(id: 12, name: "My name")
  /// ````
  ApiErrorBody call({
    Object? statusCode = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return ApiErrorBody(
      statusCode: statusCode == const $CopyWithPlaceholder()
          ? _value.statusCode
          // ignore: cast_nullable_to_non_nullable
          : statusCode as num,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $ApiErrorBodyCopyWith on ApiErrorBody {
  /// Returns a callable class that can be used as follows: `instanceOfApiErrorBody.copyWith(...)` or like so:`instanceOfApiErrorBody.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApiErrorBodyCWProxy get copyWith => _$ApiErrorBodyCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorBody _$ApiErrorBodyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApiErrorBody', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['statusCode', 'code', 'message']);
      final val = ApiErrorBody(
        statusCode: $checkedConvert('statusCode', (v) => v as num),
        code: $checkedConvert('code', (v) => v as String),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ApiErrorBodyToJson(ApiErrorBody instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'code': instance.code,
      'message': instance.message,
    };

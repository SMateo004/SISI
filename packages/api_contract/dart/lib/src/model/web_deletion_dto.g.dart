// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_deletion_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WebDeletionDtoCWProxy {
  WebDeletionDto phone(String phone);

  WebDeletionDto code(String code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WebDeletionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WebDeletionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WebDeletionDto call({String phone, String code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWebDeletionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWebDeletionDto.copyWith.fieldName(...)`
class _$WebDeletionDtoCWProxyImpl implements _$WebDeletionDtoCWProxy {
  const _$WebDeletionDtoCWProxyImpl(this._value);

  final WebDeletionDto _value;

  @override
  WebDeletionDto phone(String phone) => this(phone: phone);

  @override
  WebDeletionDto code(String code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WebDeletionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WebDeletionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WebDeletionDto call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
  }) {
    return WebDeletionDto(
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

extension $WebDeletionDtoCopyWith on WebDeletionDto {
  /// Returns a callable class that can be used as follows: `instanceOfWebDeletionDto.copyWith(...)` or like so:`instanceOfWebDeletionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WebDeletionDtoCWProxy get copyWith => _$WebDeletionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebDeletionDto _$WebDeletionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebDeletionDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone', 'code']);
      final val = WebDeletionDto(
        phone: $checkedConvert('phone', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$WebDeletionDtoToJson(WebDeletionDto instance) =>
    <String, dynamic>{'phone': instance.phone, 'code': instance.code};

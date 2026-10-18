// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_deletion_code_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WebDeletionCodeDtoCWProxy {
  WebDeletionCodeDto phone(String phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WebDeletionCodeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WebDeletionCodeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WebDeletionCodeDto call({String phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWebDeletionCodeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWebDeletionCodeDto.copyWith.fieldName(...)`
class _$WebDeletionCodeDtoCWProxyImpl implements _$WebDeletionCodeDtoCWProxy {
  const _$WebDeletionCodeDtoCWProxyImpl(this._value);

  final WebDeletionCodeDto _value;

  @override
  WebDeletionCodeDto phone(String phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WebDeletionCodeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WebDeletionCodeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WebDeletionCodeDto call({Object? phone = const $CopyWithPlaceholder()}) {
    return WebDeletionCodeDto(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
    );
  }
}

extension $WebDeletionCodeDtoCopyWith on WebDeletionCodeDto {
  /// Returns a callable class that can be used as follows: `instanceOfWebDeletionCodeDto.copyWith(...)` or like so:`instanceOfWebDeletionCodeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WebDeletionCodeDtoCWProxy get copyWith =>
      _$WebDeletionCodeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebDeletionCodeDto _$WebDeletionCodeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WebDeletionCodeDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone']);
      final val = WebDeletionCodeDto(
        phone: $checkedConvert('phone', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$WebDeletionCodeDtoToJson(WebDeletionCodeDto instance) =>
    <String, dynamic>{'phone': instance.phone};

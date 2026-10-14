// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_upload_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConfirmUploadDtoCWProxy {
  ConfirmUploadDto key(String key);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConfirmUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConfirmUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ConfirmUploadDto call({String key});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConfirmUploadDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConfirmUploadDto.copyWith.fieldName(...)`
class _$ConfirmUploadDtoCWProxyImpl implements _$ConfirmUploadDtoCWProxy {
  const _$ConfirmUploadDtoCWProxyImpl(this._value);

  final ConfirmUploadDto _value;

  @override
  ConfirmUploadDto key(String key) => this(key: key);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConfirmUploadDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConfirmUploadDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ConfirmUploadDto call({Object? key = const $CopyWithPlaceholder()}) {
    return ConfirmUploadDto(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
    );
  }
}

extension $ConfirmUploadDtoCopyWith on ConfirmUploadDto {
  /// Returns a callable class that can be used as follows: `instanceOfConfirmUploadDto.copyWith(...)` or like so:`instanceOfConfirmUploadDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConfirmUploadDtoCWProxy get copyWith => _$ConfirmUploadDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmUploadDto _$ConfirmUploadDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConfirmUploadDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['key']);
      final val = ConfirmUploadDto(
        key: $checkedConvert('key', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ConfirmUploadDtoToJson(ConfirmUploadDto instance) =>
    <String, dynamic>{'key': instance.key};

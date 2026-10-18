// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_deletion_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConfirmDeletionDtoCWProxy {
  ConfirmDeletionDto code(String code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConfirmDeletionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConfirmDeletionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ConfirmDeletionDto call({String code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConfirmDeletionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConfirmDeletionDto.copyWith.fieldName(...)`
class _$ConfirmDeletionDtoCWProxyImpl implements _$ConfirmDeletionDtoCWProxy {
  const _$ConfirmDeletionDtoCWProxyImpl(this._value);

  final ConfirmDeletionDto _value;

  @override
  ConfirmDeletionDto code(String code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConfirmDeletionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConfirmDeletionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ConfirmDeletionDto call({Object? code = const $CopyWithPlaceholder()}) {
    return ConfirmDeletionDto(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
    );
  }
}

extension $ConfirmDeletionDtoCopyWith on ConfirmDeletionDto {
  /// Returns a callable class that can be used as follows: `instanceOfConfirmDeletionDto.copyWith(...)` or like so:`instanceOfConfirmDeletionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConfirmDeletionDtoCWProxy get copyWith =>
      _$ConfirmDeletionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmDeletionDto _$ConfirmDeletionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConfirmDeletionDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code']);
      final val = ConfirmDeletionDto(
        code: $checkedConvert('code', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ConfirmDeletionDtoToJson(ConfirmDeletionDto instance) =>
    <String, dynamic>{'code': instance.code};

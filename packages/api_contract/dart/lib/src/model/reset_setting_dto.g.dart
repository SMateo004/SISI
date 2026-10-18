// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_setting_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResetSettingDtoCWProxy {
  ResetSettingDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResetSettingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResetSettingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResetSettingDto call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResetSettingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResetSettingDto.copyWith.fieldName(...)`
class _$ResetSettingDtoCWProxyImpl implements _$ResetSettingDtoCWProxy {
  const _$ResetSettingDtoCWProxyImpl(this._value);

  final ResetSettingDto _value;

  @override
  ResetSettingDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResetSettingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResetSettingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResetSettingDto call({Object? reason = const $CopyWithPlaceholder()}) {
    return ResetSettingDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $ResetSettingDtoCopyWith on ResetSettingDto {
  /// Returns a callable class that can be used as follows: `instanceOfResetSettingDto.copyWith(...)` or like so:`instanceOfResetSettingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResetSettingDtoCWProxy get copyWith => _$ResetSettingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetSettingDto _$ResetSettingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ResetSettingDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = ResetSettingDto(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ResetSettingDtoToJson(ResetSettingDto instance) =>
    <String, dynamic>{'reason': instance.reason};

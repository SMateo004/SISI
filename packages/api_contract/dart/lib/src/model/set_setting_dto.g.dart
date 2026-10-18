// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_setting_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SetSettingDtoCWProxy {
  SetSettingDto value(String value);

  SetSettingDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetSettingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetSettingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetSettingDto call({String value, String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSetSettingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSetSettingDto.copyWith.fieldName(...)`
class _$SetSettingDtoCWProxyImpl implements _$SetSettingDtoCWProxy {
  const _$SetSettingDtoCWProxyImpl(this._value);

  final SetSettingDto _value;

  @override
  SetSettingDto value(String value) => this(value: value);

  @override
  SetSettingDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SetSettingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SetSettingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SetSettingDto call({
    Object? value = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return SetSettingDto(
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $SetSettingDtoCopyWith on SetSettingDto {
  /// Returns a callable class that can be used as follows: `instanceOfSetSettingDto.copyWith(...)` or like so:`instanceOfSetSettingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SetSettingDtoCWProxy get copyWith => _$SetSettingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetSettingDto _$SetSettingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SetSettingDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['value', 'reason']);
      final val = SetSettingDto(
        value: $checkedConvert('value', (v) => v as String),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SetSettingDtoToJson(SetSettingDto instance) =>
    <String, dynamic>{'value': instance.value, 'reason': instance.reason};

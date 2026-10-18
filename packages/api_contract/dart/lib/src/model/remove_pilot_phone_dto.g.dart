// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_pilot_phone_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RemovePilotPhoneDtoCWProxy {
  RemovePilotPhoneDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RemovePilotPhoneDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RemovePilotPhoneDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RemovePilotPhoneDto call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRemovePilotPhoneDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRemovePilotPhoneDto.copyWith.fieldName(...)`
class _$RemovePilotPhoneDtoCWProxyImpl implements _$RemovePilotPhoneDtoCWProxy {
  const _$RemovePilotPhoneDtoCWProxyImpl(this._value);

  final RemovePilotPhoneDto _value;

  @override
  RemovePilotPhoneDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RemovePilotPhoneDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RemovePilotPhoneDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RemovePilotPhoneDto call({Object? reason = const $CopyWithPlaceholder()}) {
    return RemovePilotPhoneDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $RemovePilotPhoneDtoCopyWith on RemovePilotPhoneDto {
  /// Returns a callable class that can be used as follows: `instanceOfRemovePilotPhoneDto.copyWith(...)` or like so:`instanceOfRemovePilotPhoneDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RemovePilotPhoneDtoCWProxy get copyWith =>
      _$RemovePilotPhoneDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemovePilotPhoneDto _$RemovePilotPhoneDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RemovePilotPhoneDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = RemovePilotPhoneDto(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RemovePilotPhoneDtoToJson(
  RemovePilotPhoneDto instance,
) => <String, dynamic>{'reason': instance.reason};

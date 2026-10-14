// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch_mode_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SwitchModeDtoCWProxy {
  SwitchModeDto mode(SwitchModeDtoModeEnum mode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SwitchModeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SwitchModeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SwitchModeDto call({SwitchModeDtoModeEnum mode});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSwitchModeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSwitchModeDto.copyWith.fieldName(...)`
class _$SwitchModeDtoCWProxyImpl implements _$SwitchModeDtoCWProxy {
  const _$SwitchModeDtoCWProxyImpl(this._value);

  final SwitchModeDto _value;

  @override
  SwitchModeDto mode(SwitchModeDtoModeEnum mode) => this(mode: mode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SwitchModeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SwitchModeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SwitchModeDto call({Object? mode = const $CopyWithPlaceholder()}) {
    return SwitchModeDto(
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as SwitchModeDtoModeEnum,
    );
  }
}

extension $SwitchModeDtoCopyWith on SwitchModeDto {
  /// Returns a callable class that can be used as follows: `instanceOfSwitchModeDto.copyWith(...)` or like so:`instanceOfSwitchModeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SwitchModeDtoCWProxy get copyWith => _$SwitchModeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwitchModeDto _$SwitchModeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SwitchModeDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['mode']);
      final val = SwitchModeDto(
        mode: $checkedConvert(
          'mode',
          (v) => $enumDecode(_$SwitchModeDtoModeEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SwitchModeDtoToJson(SwitchModeDto instance) =>
    <String, dynamic>{'mode': _$SwitchModeDtoModeEnumEnumMap[instance.mode]!};

const _$SwitchModeDtoModeEnumEnumMap = {
  SwitchModeDtoModeEnum.employer: 'employer',
  SwitchModeDtoModeEnum.worker: 'worker',
};

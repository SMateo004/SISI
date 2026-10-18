// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingDtoCWProxy {
  SettingDto key(String key);

  SettingDto group(SettingDtoGroupEnum group);

  SettingDto label(String label);

  SettingDto help(String help);

  SettingDto kind(SettingDtoKindEnum kind);

  SettingDto unit(SettingDtoUnitEnum unit);

  SettingDto min(num? min);

  SettingDto max(num? max);

  SettingDto value(String value);

  SettingDto defaultValue(String defaultValue);

  SettingDto overridden(bool overridden);

  SettingDto updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingDto call({
    String key,
    SettingDtoGroupEnum group,
    String label,
    String help,
    SettingDtoKindEnum kind,
    SettingDtoUnitEnum unit,
    num? min,
    num? max,
    String value,
    String defaultValue,
    bool overridden,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSettingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSettingDto.copyWith.fieldName(...)`
class _$SettingDtoCWProxyImpl implements _$SettingDtoCWProxy {
  const _$SettingDtoCWProxyImpl(this._value);

  final SettingDto _value;

  @override
  SettingDto key(String key) => this(key: key);

  @override
  SettingDto group(SettingDtoGroupEnum group) => this(group: group);

  @override
  SettingDto label(String label) => this(label: label);

  @override
  SettingDto help(String help) => this(help: help);

  @override
  SettingDto kind(SettingDtoKindEnum kind) => this(kind: kind);

  @override
  SettingDto unit(SettingDtoUnitEnum unit) => this(unit: unit);

  @override
  SettingDto min(num? min) => this(min: min);

  @override
  SettingDto max(num? max) => this(max: max);

  @override
  SettingDto value(String value) => this(value: value);

  @override
  SettingDto defaultValue(String defaultValue) =>
      this(defaultValue: defaultValue);

  @override
  SettingDto overridden(bool overridden) => this(overridden: overridden);

  @override
  SettingDto updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingDto call({
    Object? key = const $CopyWithPlaceholder(),
    Object? group = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? help = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? min = const $CopyWithPlaceholder(),
    Object? max = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? defaultValue = const $CopyWithPlaceholder(),
    Object? overridden = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return SettingDto(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      group: group == const $CopyWithPlaceholder()
          ? _value.group
          // ignore: cast_nullable_to_non_nullable
          : group as SettingDtoGroupEnum,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      help: help == const $CopyWithPlaceholder()
          ? _value.help
          // ignore: cast_nullable_to_non_nullable
          : help as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as SettingDtoKindEnum,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as SettingDtoUnitEnum,
      min: min == const $CopyWithPlaceholder()
          ? _value.min
          // ignore: cast_nullable_to_non_nullable
          : min as num?,
      max: max == const $CopyWithPlaceholder()
          ? _value.max
          // ignore: cast_nullable_to_non_nullable
          : max as num?,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String,
      defaultValue: defaultValue == const $CopyWithPlaceholder()
          ? _value.defaultValue
          // ignore: cast_nullable_to_non_nullable
          : defaultValue as String,
      overridden: overridden == const $CopyWithPlaceholder()
          ? _value.overridden
          // ignore: cast_nullable_to_non_nullable
          : overridden as bool,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $SettingDtoCopyWith on SettingDto {
  /// Returns a callable class that can be used as follows: `instanceOfSettingDto.copyWith(...)` or like so:`instanceOfSettingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingDtoCWProxy get copyWith => _$SettingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingDto _$SettingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SettingDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'key',
          'group',
          'label',
          'help',
          'kind',
          'unit',
          'min',
          'max',
          'value',
          'defaultValue',
          'overridden',
          'updatedAt',
        ],
      );
      final val = SettingDto(
        key: $checkedConvert('key', (v) => v as String),
        group: $checkedConvert(
          'group',
          (v) => $enumDecode(_$SettingDtoGroupEnumEnumMap, v),
        ),
        label: $checkedConvert('label', (v) => v as String),
        help: $checkedConvert('help', (v) => v as String),
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$SettingDtoKindEnumEnumMap, v),
        ),
        unit: $checkedConvert(
          'unit',
          (v) => $enumDecode(_$SettingDtoUnitEnumEnumMap, v),
        ),
        min: $checkedConvert('min', (v) => v as num?),
        max: $checkedConvert('max', (v) => v as num?),
        value: $checkedConvert('value', (v) => v as String),
        defaultValue: $checkedConvert('defaultValue', (v) => v as String),
        overridden: $checkedConvert('overridden', (v) => v as bool),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SettingDtoToJson(SettingDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'group': _$SettingDtoGroupEnumEnumMap[instance.group]!,
      'label': instance.label,
      'help': instance.help,
      'kind': _$SettingDtoKindEnumEnumMap[instance.kind]!,
      'unit': _$SettingDtoUnitEnumEnumMap[instance.unit]!,
      'min': instance.min,
      'max': instance.max,
      'value': instance.value,
      'defaultValue': instance.defaultValue,
      'overridden': instance.overridden,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SettingDtoGroupEnumEnumMap = {
  SettingDtoGroupEnum.matching: 'matching',
  SettingDtoGroupEnum.ofertas: 'ofertas',
  SettingDtoGroupEnum.trabajos: 'trabajos',
  SettingDtoGroupEnum.cobros: 'cobros',
  SettingDtoGroupEnum.app: 'app',
};

const _$SettingDtoKindEnumEnumMap = {
  SettingDtoKindEnum.int_: 'int',
  SettingDtoKindEnum.decimal: 'decimal',
  SettingDtoKindEnum.rings: 'rings',
  SettingDtoKindEnum.text: 'text',
};

const _$SettingDtoUnitEnumEnumMap = {
  SettingDtoUnitEnum.ms: 'ms',
  SettingDtoUnitEnum.das: 'días',
  SettingDtoUnitEnum.hora: 'hora',
  SettingDtoUnitEnum.bs: 'Bs',
  SettingDtoUnitEnum.ofertas: 'ofertas',
  SettingDtoUnitEnum.veces: 'veces',
  SettingDtoUnitEnum.anillos: 'anillos',
  SettingDtoUnitEnum.texto: 'texto',
};

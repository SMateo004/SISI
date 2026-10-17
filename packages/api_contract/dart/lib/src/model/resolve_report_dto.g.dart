// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_report_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResolveReportDtoCWProxy {
  ResolveReportDto valid(bool valid);

  ResolveReportDto resolution(String resolution);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResolveReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResolveReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResolveReportDto call({bool valid, String resolution});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResolveReportDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResolveReportDto.copyWith.fieldName(...)`
class _$ResolveReportDtoCWProxyImpl implements _$ResolveReportDtoCWProxy {
  const _$ResolveReportDtoCWProxyImpl(this._value);

  final ResolveReportDto _value;

  @override
  ResolveReportDto valid(bool valid) => this(valid: valid);

  @override
  ResolveReportDto resolution(String resolution) =>
      this(resolution: resolution);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResolveReportDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResolveReportDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResolveReportDto call({
    Object? valid = const $CopyWithPlaceholder(),
    Object? resolution = const $CopyWithPlaceholder(),
  }) {
    return ResolveReportDto(
      valid: valid == const $CopyWithPlaceholder()
          ? _value.valid
          // ignore: cast_nullable_to_non_nullable
          : valid as bool,
      resolution: resolution == const $CopyWithPlaceholder()
          ? _value.resolution
          // ignore: cast_nullable_to_non_nullable
          : resolution as String,
    );
  }
}

extension $ResolveReportDtoCopyWith on ResolveReportDto {
  /// Returns a callable class that can be used as follows: `instanceOfResolveReportDto.copyWith(...)` or like so:`instanceOfResolveReportDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResolveReportDtoCWProxy get copyWith => _$ResolveReportDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveReportDto _$ResolveReportDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ResolveReportDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['valid', 'resolution']);
      final val = ResolveReportDto(
        valid: $checkedConvert('valid', (v) => v as bool),
        resolution: $checkedConvert('resolution', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ResolveReportDtoToJson(ResolveReportDto instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'resolution': instance.resolution,
    };

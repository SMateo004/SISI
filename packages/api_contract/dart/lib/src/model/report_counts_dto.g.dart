// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_counts_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportCountsDtoCWProxy {
  ReportCountsDto pendiente(num pendiente);

  ReportCountsDto valido(num valido);

  ReportCountsDto descartado(num descartado);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportCountsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportCountsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportCountsDto call({num pendiente, num valido, num descartado});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportCountsDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportCountsDto.copyWith.fieldName(...)`
class _$ReportCountsDtoCWProxyImpl implements _$ReportCountsDtoCWProxy {
  const _$ReportCountsDtoCWProxyImpl(this._value);

  final ReportCountsDto _value;

  @override
  ReportCountsDto pendiente(num pendiente) => this(pendiente: pendiente);

  @override
  ReportCountsDto valido(num valido) => this(valido: valido);

  @override
  ReportCountsDto descartado(num descartado) => this(descartado: descartado);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportCountsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportCountsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportCountsDto call({
    Object? pendiente = const $CopyWithPlaceholder(),
    Object? valido = const $CopyWithPlaceholder(),
    Object? descartado = const $CopyWithPlaceholder(),
  }) {
    return ReportCountsDto(
      pendiente: pendiente == const $CopyWithPlaceholder()
          ? _value.pendiente
          // ignore: cast_nullable_to_non_nullable
          : pendiente as num,
      valido: valido == const $CopyWithPlaceholder()
          ? _value.valido
          // ignore: cast_nullable_to_non_nullable
          : valido as num,
      descartado: descartado == const $CopyWithPlaceholder()
          ? _value.descartado
          // ignore: cast_nullable_to_non_nullable
          : descartado as num,
    );
  }
}

extension $ReportCountsDtoCopyWith on ReportCountsDto {
  /// Returns a callable class that can be used as follows: `instanceOfReportCountsDto.copyWith(...)` or like so:`instanceOfReportCountsDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportCountsDtoCWProxy get copyWith => _$ReportCountsDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportCountsDto _$ReportCountsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportCountsDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['pendiente', 'valido', 'descartado'],
      );
      final val = ReportCountsDto(
        pendiente: $checkedConvert('pendiente', (v) => v as num),
        valido: $checkedConvert('valido', (v) => v as num),
        descartado: $checkedConvert('descartado', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$ReportCountsDtoToJson(ReportCountsDto instance) =>
    <String, dynamic>{
      'pendiente': instance.pendiente,
      'valido': instance.valido,
      'descartado': instance.descartado,
    };

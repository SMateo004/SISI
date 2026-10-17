// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_report_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResolveReportResultDtoCWProxy {
  ResolveReportResultDto report(AdminReportDto report);

  ResolveReportResultDto outcome(ResolveReportResultDtoOutcomeEnum outcome);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResolveReportResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResolveReportResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResolveReportResultDto call({
    AdminReportDto report,
    ResolveReportResultDtoOutcomeEnum outcome,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResolveReportResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResolveReportResultDto.copyWith.fieldName(...)`
class _$ResolveReportResultDtoCWProxyImpl
    implements _$ResolveReportResultDtoCWProxy {
  const _$ResolveReportResultDtoCWProxyImpl(this._value);

  final ResolveReportResultDto _value;

  @override
  ResolveReportResultDto report(AdminReportDto report) => this(report: report);

  @override
  ResolveReportResultDto outcome(ResolveReportResultDtoOutcomeEnum outcome) =>
      this(outcome: outcome);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResolveReportResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResolveReportResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResolveReportResultDto call({
    Object? report = const $CopyWithPlaceholder(),
    Object? outcome = const $CopyWithPlaceholder(),
  }) {
    return ResolveReportResultDto(
      report: report == const $CopyWithPlaceholder()
          ? _value.report
          // ignore: cast_nullable_to_non_nullable
          : report as AdminReportDto,
      outcome: outcome == const $CopyWithPlaceholder()
          ? _value.outcome
          // ignore: cast_nullable_to_non_nullable
          : outcome as ResolveReportResultDtoOutcomeEnum,
    );
  }
}

extension $ResolveReportResultDtoCopyWith on ResolveReportResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfResolveReportResultDto.copyWith(...)` or like so:`instanceOfResolveReportResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResolveReportResultDtoCWProxy get copyWith =>
      _$ResolveReportResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveReportResultDto _$ResolveReportResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ResolveReportResultDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['report', 'outcome']);
  final val = ResolveReportResultDto(
    report: $checkedConvert(
      'report',
      (v) => AdminReportDto.fromJson(v as Map<String, dynamic>),
    ),
    outcome: $checkedConvert(
      'outcome',
      (v) => $enumDecode(_$ResolveReportResultDtoOutcomeEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$ResolveReportResultDtoToJson(
  ResolveReportResultDto instance,
) => <String, dynamic>{
  'report': instance.report.toJson(),
  'outcome': _$ResolveReportResultDtoOutcomeEnumEnumMap[instance.outcome]!,
};

const _$ResolveReportResultDtoOutcomeEnumEnumMap = {
  ResolveReportResultDtoOutcomeEnum.suspend: 'suspend',
  ResolveReportResultDtoOutcomeEnum.flag: 'flag',
  ResolveReportResultDtoOutcomeEnum.none: 'none',
};

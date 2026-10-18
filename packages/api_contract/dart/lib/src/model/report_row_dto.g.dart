// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportRowDtoCWProxy {
  ReportRowDto id(String id);

  ReportRowDto targetType(String targetType);

  ReportRowDto reason(String reason);

  ReportRowDto status(String status);

  ReportRowDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportRowDto call({
    String id,
    String targetType,
    String reason,
    String status,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportRowDto.copyWith.fieldName(...)`
class _$ReportRowDtoCWProxyImpl implements _$ReportRowDtoCWProxy {
  const _$ReportRowDtoCWProxyImpl(this._value);

  final ReportRowDto _value;

  @override
  ReportRowDto id(String id) => this(id: id);

  @override
  ReportRowDto targetType(String targetType) => this(targetType: targetType);

  @override
  ReportRowDto reason(String reason) => this(reason: reason);

  @override
  ReportRowDto status(String status) => this(status: status);

  @override
  ReportRowDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? targetType = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return ReportRowDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      targetType: targetType == const $CopyWithPlaceholder()
          ? _value.targetType
          // ignore: cast_nullable_to_non_nullable
          : targetType as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $ReportRowDtoCopyWith on ReportRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfReportRowDto.copyWith(...)` or like so:`instanceOfReportRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportRowDtoCWProxy get copyWith => _$ReportRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRowDto _$ReportRowDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ReportRowDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['id', 'targetType', 'reason', 'status', 'createdAt'],
  );
  final val = ReportRowDto(
    id: $checkedConvert('id', (v) => v as String),
    targetType: $checkedConvert('targetType', (v) => v as String),
    reason: $checkedConvert('reason', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$ReportRowDtoToJson(ReportRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetType': instance.targetType,
      'reason': instance.reason,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };

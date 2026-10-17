// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reported_user_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReportedUserDtoCWProxy {
  ReportedUserDto id(String id);

  ReportedUserDto validReporters(num validReporters);

  ReportedUserDto workerStatus(String? workerStatus);

  ReportedUserDto flaggedAt(DateTime? flaggedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportedUserDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportedUserDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportedUserDto call({
    String id,
    num validReporters,
    String? workerStatus,
    DateTime? flaggedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReportedUserDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReportedUserDto.copyWith.fieldName(...)`
class _$ReportedUserDtoCWProxyImpl implements _$ReportedUserDtoCWProxy {
  const _$ReportedUserDtoCWProxyImpl(this._value);

  final ReportedUserDto _value;

  @override
  ReportedUserDto id(String id) => this(id: id);

  @override
  ReportedUserDto validReporters(num validReporters) =>
      this(validReporters: validReporters);

  @override
  ReportedUserDto workerStatus(String? workerStatus) =>
      this(workerStatus: workerStatus);

  @override
  ReportedUserDto flaggedAt(DateTime? flaggedAt) => this(flaggedAt: flaggedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReportedUserDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReportedUserDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReportedUserDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? validReporters = const $CopyWithPlaceholder(),
    Object? workerStatus = const $CopyWithPlaceholder(),
    Object? flaggedAt = const $CopyWithPlaceholder(),
  }) {
    return ReportedUserDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      validReporters: validReporters == const $CopyWithPlaceholder()
          ? _value.validReporters
          // ignore: cast_nullable_to_non_nullable
          : validReporters as num,
      workerStatus: workerStatus == const $CopyWithPlaceholder()
          ? _value.workerStatus
          // ignore: cast_nullable_to_non_nullable
          : workerStatus as String?,
      flaggedAt: flaggedAt == const $CopyWithPlaceholder()
          ? _value.flaggedAt
          // ignore: cast_nullable_to_non_nullable
          : flaggedAt as DateTime?,
    );
  }
}

extension $ReportedUserDtoCopyWith on ReportedUserDto {
  /// Returns a callable class that can be used as follows: `instanceOfReportedUserDto.copyWith(...)` or like so:`instanceOfReportedUserDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReportedUserDtoCWProxy get copyWith => _$ReportedUserDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportedUserDto _$ReportedUserDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReportedUserDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'validReporters',
          'workerStatus',
          'flaggedAt',
        ],
      );
      final val = ReportedUserDto(
        id: $checkedConvert('id', (v) => v as String),
        validReporters: $checkedConvert('validReporters', (v) => v as num),
        workerStatus: $checkedConvert('workerStatus', (v) => v as String?),
        flaggedAt: $checkedConvert(
          'flaggedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReportedUserDtoToJson(ReportedUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'validReporters': instance.validReporters,
      'workerStatus': instance.workerStatus,
      'flaggedAt': instance.flaggedAt?.toIso8601String(),
    };

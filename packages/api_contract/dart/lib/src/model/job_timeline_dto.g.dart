// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_timeline_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobTimelineDtoCWProxy {
  JobTimelineDto assignedAt(DateTime assignedAt);

  JobTimelineDto onTheWayAt(DateTime? onTheWayAt);

  JobTimelineDto startedAt(DateTime? startedAt);

  JobTimelineDto workerFinishedAt(DateTime? workerFinishedAt);

  JobTimelineDto disputedAt(DateTime? disputedAt);

  JobTimelineDto completedAt(DateTime? completedAt);

  JobTimelineDto cancelledAt(DateTime? cancelledAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobTimelineDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobTimelineDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobTimelineDto call({
    DateTime assignedAt,
    DateTime? onTheWayAt,
    DateTime? startedAt,
    DateTime? workerFinishedAt,
    DateTime? disputedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobTimelineDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobTimelineDto.copyWith.fieldName(...)`
class _$JobTimelineDtoCWProxyImpl implements _$JobTimelineDtoCWProxy {
  const _$JobTimelineDtoCWProxyImpl(this._value);

  final JobTimelineDto _value;

  @override
  JobTimelineDto assignedAt(DateTime assignedAt) =>
      this(assignedAt: assignedAt);

  @override
  JobTimelineDto onTheWayAt(DateTime? onTheWayAt) =>
      this(onTheWayAt: onTheWayAt);

  @override
  JobTimelineDto startedAt(DateTime? startedAt) => this(startedAt: startedAt);

  @override
  JobTimelineDto workerFinishedAt(DateTime? workerFinishedAt) =>
      this(workerFinishedAt: workerFinishedAt);

  @override
  JobTimelineDto disputedAt(DateTime? disputedAt) =>
      this(disputedAt: disputedAt);

  @override
  JobTimelineDto completedAt(DateTime? completedAt) =>
      this(completedAt: completedAt);

  @override
  JobTimelineDto cancelledAt(DateTime? cancelledAt) =>
      this(cancelledAt: cancelledAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobTimelineDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobTimelineDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobTimelineDto call({
    Object? assignedAt = const $CopyWithPlaceholder(),
    Object? onTheWayAt = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? workerFinishedAt = const $CopyWithPlaceholder(),
    Object? disputedAt = const $CopyWithPlaceholder(),
    Object? completedAt = const $CopyWithPlaceholder(),
    Object? cancelledAt = const $CopyWithPlaceholder(),
  }) {
    return JobTimelineDto(
      assignedAt: assignedAt == const $CopyWithPlaceholder()
          ? _value.assignedAt
          // ignore: cast_nullable_to_non_nullable
          : assignedAt as DateTime,
      onTheWayAt: onTheWayAt == const $CopyWithPlaceholder()
          ? _value.onTheWayAt
          // ignore: cast_nullable_to_non_nullable
          : onTheWayAt as DateTime?,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime?,
      workerFinishedAt: workerFinishedAt == const $CopyWithPlaceholder()
          ? _value.workerFinishedAt
          // ignore: cast_nullable_to_non_nullable
          : workerFinishedAt as DateTime?,
      disputedAt: disputedAt == const $CopyWithPlaceholder()
          ? _value.disputedAt
          // ignore: cast_nullable_to_non_nullable
          : disputedAt as DateTime?,
      completedAt: completedAt == const $CopyWithPlaceholder()
          ? _value.completedAt
          // ignore: cast_nullable_to_non_nullable
          : completedAt as DateTime?,
      cancelledAt: cancelledAt == const $CopyWithPlaceholder()
          ? _value.cancelledAt
          // ignore: cast_nullable_to_non_nullable
          : cancelledAt as DateTime?,
    );
  }
}

extension $JobTimelineDtoCopyWith on JobTimelineDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobTimelineDto.copyWith(...)` or like so:`instanceOfJobTimelineDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobTimelineDtoCWProxy get copyWith => _$JobTimelineDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobTimelineDto _$JobTimelineDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobTimelineDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'assignedAt',
          'onTheWayAt',
          'startedAt',
          'workerFinishedAt',
          'disputedAt',
          'completedAt',
          'cancelledAt',
        ],
      );
      final val = JobTimelineDto(
        assignedAt: $checkedConvert(
          'assignedAt',
          (v) => DateTime.parse(v as String),
        ),
        onTheWayAt: $checkedConvert(
          'onTheWayAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        startedAt: $checkedConvert(
          'startedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        workerFinishedAt: $checkedConvert(
          'workerFinishedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        disputedAt: $checkedConvert(
          'disputedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        completedAt: $checkedConvert(
          'completedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        cancelledAt: $checkedConvert(
          'cancelledAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JobTimelineDtoToJson(JobTimelineDto instance) =>
    <String, dynamic>{
      'assignedAt': instance.assignedAt.toIso8601String(),
      'onTheWayAt': instance.onTheWayAt?.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'workerFinishedAt': instance.workerFinishedAt?.toIso8601String(),
      'disputedAt': instance.disputedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
    };

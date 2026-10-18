// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_week_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotWeekDtoCWProxy {
  PilotWeekDto weekStart(String weekStart);

  PilotWeekDto activeWorkers(num activeWorkers);

  PilotWeekDto activeEmployers(num activeEmployers);

  PilotWeekDto workerRetentionPct(num? workerRetentionPct);

  PilotWeekDto employerRetentionPct(num? employerRetentionPct);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotWeekDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotWeekDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotWeekDto call({
    String weekStart,
    num activeWorkers,
    num activeEmployers,
    num? workerRetentionPct,
    num? employerRetentionPct,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotWeekDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotWeekDto.copyWith.fieldName(...)`
class _$PilotWeekDtoCWProxyImpl implements _$PilotWeekDtoCWProxy {
  const _$PilotWeekDtoCWProxyImpl(this._value);

  final PilotWeekDto _value;

  @override
  PilotWeekDto weekStart(String weekStart) => this(weekStart: weekStart);

  @override
  PilotWeekDto activeWorkers(num activeWorkers) =>
      this(activeWorkers: activeWorkers);

  @override
  PilotWeekDto activeEmployers(num activeEmployers) =>
      this(activeEmployers: activeEmployers);

  @override
  PilotWeekDto workerRetentionPct(num? workerRetentionPct) =>
      this(workerRetentionPct: workerRetentionPct);

  @override
  PilotWeekDto employerRetentionPct(num? employerRetentionPct) =>
      this(employerRetentionPct: employerRetentionPct);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotWeekDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotWeekDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotWeekDto call({
    Object? weekStart = const $CopyWithPlaceholder(),
    Object? activeWorkers = const $CopyWithPlaceholder(),
    Object? activeEmployers = const $CopyWithPlaceholder(),
    Object? workerRetentionPct = const $CopyWithPlaceholder(),
    Object? employerRetentionPct = const $CopyWithPlaceholder(),
  }) {
    return PilotWeekDto(
      weekStart: weekStart == const $CopyWithPlaceholder()
          ? _value.weekStart
          // ignore: cast_nullable_to_non_nullable
          : weekStart as String,
      activeWorkers: activeWorkers == const $CopyWithPlaceholder()
          ? _value.activeWorkers
          // ignore: cast_nullable_to_non_nullable
          : activeWorkers as num,
      activeEmployers: activeEmployers == const $CopyWithPlaceholder()
          ? _value.activeEmployers
          // ignore: cast_nullable_to_non_nullable
          : activeEmployers as num,
      workerRetentionPct: workerRetentionPct == const $CopyWithPlaceholder()
          ? _value.workerRetentionPct
          // ignore: cast_nullable_to_non_nullable
          : workerRetentionPct as num?,
      employerRetentionPct: employerRetentionPct == const $CopyWithPlaceholder()
          ? _value.employerRetentionPct
          // ignore: cast_nullable_to_non_nullable
          : employerRetentionPct as num?,
    );
  }
}

extension $PilotWeekDtoCopyWith on PilotWeekDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotWeekDto.copyWith(...)` or like so:`instanceOfPilotWeekDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotWeekDtoCWProxy get copyWith => _$PilotWeekDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotWeekDto _$PilotWeekDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PilotWeekDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'weekStart',
          'activeWorkers',
          'activeEmployers',
          'workerRetentionPct',
          'employerRetentionPct',
        ],
      );
      final val = PilotWeekDto(
        weekStart: $checkedConvert('weekStart', (v) => v as String),
        activeWorkers: $checkedConvert('activeWorkers', (v) => v as num),
        activeEmployers: $checkedConvert('activeEmployers', (v) => v as num),
        workerRetentionPct: $checkedConvert(
          'workerRetentionPct',
          (v) => v as num?,
        ),
        employerRetentionPct: $checkedConvert(
          'employerRetentionPct',
          (v) => v as num?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$PilotWeekDtoToJson(PilotWeekDto instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart,
      'activeWorkers': instance.activeWorkers,
      'activeEmployers': instance.activeEmployers,
      'workerRetentionPct': instance.workerRetentionPct,
      'employerRetentionPct': instance.employerRetentionPct,
    };

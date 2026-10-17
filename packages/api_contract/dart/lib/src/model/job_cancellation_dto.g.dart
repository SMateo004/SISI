// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_cancellation_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobCancellationDtoCWProxy {
  JobCancellationDto by(JobCancellationDtoByEnum by);

  JobCancellationDto reason(JobCancellationDtoReasonEnum? reason);

  JobCancellationDto note(String? note);

  JobCancellationDto noteHeld(bool noteHeld);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCancellationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCancellationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCancellationDto call({
    JobCancellationDtoByEnum by,
    JobCancellationDtoReasonEnum? reason,
    String? note,
    bool noteHeld,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobCancellationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobCancellationDto.copyWith.fieldName(...)`
class _$JobCancellationDtoCWProxyImpl implements _$JobCancellationDtoCWProxy {
  const _$JobCancellationDtoCWProxyImpl(this._value);

  final JobCancellationDto _value;

  @override
  JobCancellationDto by(JobCancellationDtoByEnum by) => this(by: by);

  @override
  JobCancellationDto reason(JobCancellationDtoReasonEnum? reason) =>
      this(reason: reason);

  @override
  JobCancellationDto note(String? note) => this(note: note);

  @override
  JobCancellationDto noteHeld(bool noteHeld) => this(noteHeld: noteHeld);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCancellationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCancellationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCancellationDto call({
    Object? by = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? noteHeld = const $CopyWithPlaceholder(),
  }) {
    return JobCancellationDto(
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as JobCancellationDtoByEnum,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as JobCancellationDtoReasonEnum?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      noteHeld: noteHeld == const $CopyWithPlaceholder()
          ? _value.noteHeld
          // ignore: cast_nullable_to_non_nullable
          : noteHeld as bool,
    );
  }
}

extension $JobCancellationDtoCopyWith on JobCancellationDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobCancellationDto.copyWith(...)` or like so:`instanceOfJobCancellationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobCancellationDtoCWProxy get copyWith =>
      _$JobCancellationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobCancellationDto _$JobCancellationDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobCancellationDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['by', 'reason', 'note', 'noteHeld'],
      );
      final val = JobCancellationDto(
        by: $checkedConvert(
          'by',
          (v) => $enumDecode(_$JobCancellationDtoByEnumEnumMap, v),
        ),
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecodeNullable(_$JobCancellationDtoReasonEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String?),
        noteHeld: $checkedConvert('noteHeld', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$JobCancellationDtoToJson(JobCancellationDto instance) =>
    <String, dynamic>{
      'by': _$JobCancellationDtoByEnumEnumMap[instance.by]!,
      'reason': _$JobCancellationDtoReasonEnumEnumMap[instance.reason],
      'note': instance.note,
      'noteHeld': instance.noteHeld,
    };

const _$JobCancellationDtoByEnumEnumMap = {
  JobCancellationDtoByEnum.worker: 'worker',
  JobCancellationDtoByEnum.employer: 'employer',
  JobCancellationDtoByEnum.admin: 'admin',
};

const _$JobCancellationDtoReasonEnumEnumMap = {
  JobCancellationDtoReasonEnum.cambioDePlanes: 'cambio_de_planes',
  JobCancellationDtoReasonEnum.noLlegaONoResponde: 'no_llega_o_no_responde',
  JobCancellationDtoReasonEnum.desacuerdoDePrecio: 'desacuerdo_de_precio',
  JobCancellationDtoReasonEnum.emergencia: 'emergencia',
  JobCancellationDtoReasonEnum.otro: 'otro',
};

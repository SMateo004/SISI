// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_job_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DisputeJobDtoCWProxy {
  DisputeJobDto note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DisputeJobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DisputeJobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DisputeJobDto call({String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDisputeJobDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDisputeJobDto.copyWith.fieldName(...)`
class _$DisputeJobDtoCWProxyImpl implements _$DisputeJobDtoCWProxy {
  const _$DisputeJobDtoCWProxyImpl(this._value);

  final DisputeJobDto _value;

  @override
  DisputeJobDto note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DisputeJobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DisputeJobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DisputeJobDto call({Object? note = const $CopyWithPlaceholder()}) {
    return DisputeJobDto(
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $DisputeJobDtoCopyWith on DisputeJobDto {
  /// Returns a callable class that can be used as follows: `instanceOfDisputeJobDto.copyWith(...)` or like so:`instanceOfDisputeJobDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DisputeJobDtoCWProxy get copyWith => _$DisputeJobDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisputeJobDto _$DisputeJobDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DisputeJobDto', json, ($checkedConvert) {
      final val = DisputeJobDto(
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$DisputeJobDtoToJson(DisputeJobDto instance) =>
    <String, dynamic>{'note': ?instance.note};

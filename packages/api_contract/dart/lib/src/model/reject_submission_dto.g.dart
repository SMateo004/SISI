// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_submission_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RejectSubmissionDtoCWProxy {
  RejectSubmissionDto note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectSubmissionDto call({String note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRejectSubmissionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRejectSubmissionDto.copyWith.fieldName(...)`
class _$RejectSubmissionDtoCWProxyImpl implements _$RejectSubmissionDtoCWProxy {
  const _$RejectSubmissionDtoCWProxyImpl(this._value);

  final RejectSubmissionDto _value;

  @override
  RejectSubmissionDto note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectSubmissionDto call({Object? note = const $CopyWithPlaceholder()}) {
    return RejectSubmissionDto(
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $RejectSubmissionDtoCopyWith on RejectSubmissionDto {
  /// Returns a callable class that can be used as follows: `instanceOfRejectSubmissionDto.copyWith(...)` or like so:`instanceOfRejectSubmissionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RejectSubmissionDtoCWProxy get copyWith =>
      _$RejectSubmissionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectSubmissionDto _$RejectSubmissionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RejectSubmissionDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['note']);
      final val = RejectSubmissionDto(
        note: $checkedConvert('note', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RejectSubmissionDtoToJson(
  RejectSubmissionDto instance,
) => <String, dynamic>{'note': instance.note};

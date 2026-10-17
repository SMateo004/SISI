// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_submission_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateSubmissionDtoCWProxy {
  CreateSubmissionDto receiptKey(String receiptKey);

  CreateSubmissionDto declaredAmountBs(String? declaredAmountBs);

  CreateSubmissionDto note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateSubmissionDto call({
    String receiptKey,
    String? declaredAmountBs,
    String? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateSubmissionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateSubmissionDto.copyWith.fieldName(...)`
class _$CreateSubmissionDtoCWProxyImpl implements _$CreateSubmissionDtoCWProxy {
  const _$CreateSubmissionDtoCWProxyImpl(this._value);

  final CreateSubmissionDto _value;

  @override
  CreateSubmissionDto receiptKey(String receiptKey) =>
      this(receiptKey: receiptKey);

  @override
  CreateSubmissionDto declaredAmountBs(String? declaredAmountBs) =>
      this(declaredAmountBs: declaredAmountBs);

  @override
  CreateSubmissionDto note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateSubmissionDto call({
    Object? receiptKey = const $CopyWithPlaceholder(),
    Object? declaredAmountBs = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return CreateSubmissionDto(
      receiptKey: receiptKey == const $CopyWithPlaceholder()
          ? _value.receiptKey
          // ignore: cast_nullable_to_non_nullable
          : receiptKey as String,
      declaredAmountBs: declaredAmountBs == const $CopyWithPlaceholder()
          ? _value.declaredAmountBs
          // ignore: cast_nullable_to_non_nullable
          : declaredAmountBs as String?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $CreateSubmissionDtoCopyWith on CreateSubmissionDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateSubmissionDto.copyWith(...)` or like so:`instanceOfCreateSubmissionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateSubmissionDtoCWProxy get copyWith =>
      _$CreateSubmissionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSubmissionDto _$CreateSubmissionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateSubmissionDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['receiptKey']);
      final val = CreateSubmissionDto(
        receiptKey: $checkedConvert('receiptKey', (v) => v as String),
        declaredAmountBs: $checkedConvert(
          'declaredAmountBs',
          (v) => v as String?,
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreateSubmissionDtoToJson(
  CreateSubmissionDto instance,
) => <String, dynamic>{
  'receiptKey': instance.receiptKey,
  'declaredAmountBs': ?instance.declaredAmountBs,
  'note': ?instance.note,
};

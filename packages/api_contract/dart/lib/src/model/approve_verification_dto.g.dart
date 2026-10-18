// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approve_verification_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApproveVerificationDtoCWProxy {
  ApproveVerificationDto note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApproveVerificationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApproveVerificationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ApproveVerificationDto call({String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApproveVerificationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApproveVerificationDto.copyWith.fieldName(...)`
class _$ApproveVerificationDtoCWProxyImpl
    implements _$ApproveVerificationDtoCWProxy {
  const _$ApproveVerificationDtoCWProxyImpl(this._value);

  final ApproveVerificationDto _value;

  @override
  ApproveVerificationDto note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApproveVerificationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApproveVerificationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ApproveVerificationDto call({Object? note = const $CopyWithPlaceholder()}) {
    return ApproveVerificationDto(
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $ApproveVerificationDtoCopyWith on ApproveVerificationDto {
  /// Returns a callable class that can be used as follows: `instanceOfApproveVerificationDto.copyWith(...)` or like so:`instanceOfApproveVerificationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApproveVerificationDtoCWProxy get copyWith =>
      _$ApproveVerificationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApproveVerificationDto _$ApproveVerificationDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ApproveVerificationDto', json, ($checkedConvert) {
  final val = ApproveVerificationDto(
    note: $checkedConvert('note', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$ApproveVerificationDtoToJson(
  ApproveVerificationDto instance,
) => <String, dynamic>{'note': ?instance.note};

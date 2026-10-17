// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_adjustment_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RegisterAdjustmentDtoCWProxy {
  RegisterAdjustmentDto workerId(String workerId);

  RegisterAdjustmentDto amountBs(String amountBs);

  RegisterAdjustmentDto reason(String reason);

  RegisterAdjustmentDto correctsEntryId(String? correctsEntryId);

  RegisterAdjustmentDto periodId(String? periodId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RegisterAdjustmentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RegisterAdjustmentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RegisterAdjustmentDto call({
    String workerId,
    String amountBs,
    String reason,
    String? correctsEntryId,
    String? periodId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRegisterAdjustmentDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRegisterAdjustmentDto.copyWith.fieldName(...)`
class _$RegisterAdjustmentDtoCWProxyImpl
    implements _$RegisterAdjustmentDtoCWProxy {
  const _$RegisterAdjustmentDtoCWProxyImpl(this._value);

  final RegisterAdjustmentDto _value;

  @override
  RegisterAdjustmentDto workerId(String workerId) => this(workerId: workerId);

  @override
  RegisterAdjustmentDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  RegisterAdjustmentDto reason(String reason) => this(reason: reason);

  @override
  RegisterAdjustmentDto correctsEntryId(String? correctsEntryId) =>
      this(correctsEntryId: correctsEntryId);

  @override
  RegisterAdjustmentDto periodId(String? periodId) => this(periodId: periodId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RegisterAdjustmentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RegisterAdjustmentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RegisterAdjustmentDto call({
    Object? workerId = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? correctsEntryId = const $CopyWithPlaceholder(),
    Object? periodId = const $CopyWithPlaceholder(),
  }) {
    return RegisterAdjustmentDto(
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      correctsEntryId: correctsEntryId == const $CopyWithPlaceholder()
          ? _value.correctsEntryId
          // ignore: cast_nullable_to_non_nullable
          : correctsEntryId as String?,
      periodId: periodId == const $CopyWithPlaceholder()
          ? _value.periodId
          // ignore: cast_nullable_to_non_nullable
          : periodId as String?,
    );
  }
}

extension $RegisterAdjustmentDtoCopyWith on RegisterAdjustmentDto {
  /// Returns a callable class that can be used as follows: `instanceOfRegisterAdjustmentDto.copyWith(...)` or like so:`instanceOfRegisterAdjustmentDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RegisterAdjustmentDtoCWProxy get copyWith =>
      _$RegisterAdjustmentDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAdjustmentDto _$RegisterAdjustmentDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('RegisterAdjustmentDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['workerId', 'amountBs', 'reason']);
  final val = RegisterAdjustmentDto(
    workerId: $checkedConvert('workerId', (v) => v as String),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
    reason: $checkedConvert('reason', (v) => v as String),
    correctsEntryId: $checkedConvert('correctsEntryId', (v) => v as String?),
    periodId: $checkedConvert('periodId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$RegisterAdjustmentDtoToJson(
  RegisterAdjustmentDto instance,
) => <String, dynamic>{
  'workerId': instance.workerId,
  'amountBs': instance.amountBs,
  'reason': instance.reason,
  'correctsEntryId': ?instance.correctsEntryId,
  'periodId': ?instance.periodId,
};

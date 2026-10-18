// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_preview_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdjustmentPreviewDtoCWProxy {
  AdjustmentPreviewDto workerId(String workerId);

  AdjustmentPreviewDto amountBs(String amountBs);

  AdjustmentPreviewDto correctsEntryId(String? correctsEntryId);

  AdjustmentPreviewDto periodId(String? periodId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentPreviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentPreviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentPreviewDto call({
    String workerId,
    String amountBs,
    String? correctsEntryId,
    String? periodId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdjustmentPreviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdjustmentPreviewDto.copyWith.fieldName(...)`
class _$AdjustmentPreviewDtoCWProxyImpl
    implements _$AdjustmentPreviewDtoCWProxy {
  const _$AdjustmentPreviewDtoCWProxyImpl(this._value);

  final AdjustmentPreviewDto _value;

  @override
  AdjustmentPreviewDto workerId(String workerId) => this(workerId: workerId);

  @override
  AdjustmentPreviewDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  AdjustmentPreviewDto correctsEntryId(String? correctsEntryId) =>
      this(correctsEntryId: correctsEntryId);

  @override
  AdjustmentPreviewDto periodId(String? periodId) => this(periodId: periodId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentPreviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentPreviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentPreviewDto call({
    Object? workerId = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? correctsEntryId = const $CopyWithPlaceholder(),
    Object? periodId = const $CopyWithPlaceholder(),
  }) {
    return AdjustmentPreviewDto(
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
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

extension $AdjustmentPreviewDtoCopyWith on AdjustmentPreviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdjustmentPreviewDto.copyWith(...)` or like so:`instanceOfAdjustmentPreviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdjustmentPreviewDtoCWProxy get copyWith =>
      _$AdjustmentPreviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustmentPreviewDto _$AdjustmentPreviewDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdjustmentPreviewDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['workerId', 'amountBs']);
  final val = AdjustmentPreviewDto(
    workerId: $checkedConvert('workerId', (v) => v as String),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
    correctsEntryId: $checkedConvert('correctsEntryId', (v) => v as String?),
    periodId: $checkedConvert('periodId', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$AdjustmentPreviewDtoToJson(
  AdjustmentPreviewDto instance,
) => <String, dynamic>{
  'workerId': instance.workerId,
  'amountBs': instance.amountBs,
  'correctsEntryId': ?instance.correctsEntryId,
  'periodId': ?instance.periodId,
};

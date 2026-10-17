// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdjustmentResultDtoCWProxy {
  AdjustmentResultDto entryId(String entryId);

  AdjustmentResultDto periodId(String periodId);

  AdjustmentResultDto amountBs(String amountBs);

  AdjustmentResultDto periodStatus(
    AdjustmentResultDtoPeriodStatusEnum periodStatus,
  );

  AdjustmentResultDto balanceBs(String balanceBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentResultDto call({
    String entryId,
    String periodId,
    String amountBs,
    AdjustmentResultDtoPeriodStatusEnum periodStatus,
    String balanceBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdjustmentResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdjustmentResultDto.copyWith.fieldName(...)`
class _$AdjustmentResultDtoCWProxyImpl implements _$AdjustmentResultDtoCWProxy {
  const _$AdjustmentResultDtoCWProxyImpl(this._value);

  final AdjustmentResultDto _value;

  @override
  AdjustmentResultDto entryId(String entryId) => this(entryId: entryId);

  @override
  AdjustmentResultDto periodId(String periodId) => this(periodId: periodId);

  @override
  AdjustmentResultDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  AdjustmentResultDto periodStatus(
    AdjustmentResultDtoPeriodStatusEnum periodStatus,
  ) => this(periodStatus: periodStatus);

  @override
  AdjustmentResultDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdjustmentResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdjustmentResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdjustmentResultDto call({
    Object? entryId = const $CopyWithPlaceholder(),
    Object? periodId = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? periodStatus = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
  }) {
    return AdjustmentResultDto(
      entryId: entryId == const $CopyWithPlaceholder()
          ? _value.entryId
          // ignore: cast_nullable_to_non_nullable
          : entryId as String,
      periodId: periodId == const $CopyWithPlaceholder()
          ? _value.periodId
          // ignore: cast_nullable_to_non_nullable
          : periodId as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      periodStatus: periodStatus == const $CopyWithPlaceholder()
          ? _value.periodStatus
          // ignore: cast_nullable_to_non_nullable
          : periodStatus as AdjustmentResultDtoPeriodStatusEnum,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
    );
  }
}

extension $AdjustmentResultDtoCopyWith on AdjustmentResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdjustmentResultDto.copyWith(...)` or like so:`instanceOfAdjustmentResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdjustmentResultDtoCWProxy get copyWith =>
      _$AdjustmentResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdjustmentResultDto _$AdjustmentResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdjustmentResultDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'entryId',
          'periodId',
          'amountBs',
          'periodStatus',
          'balanceBs',
        ],
      );
      final val = AdjustmentResultDto(
        entryId: $checkedConvert('entryId', (v) => v as String),
        periodId: $checkedConvert('periodId', (v) => v as String),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        periodStatus: $checkedConvert(
          'periodStatus',
          (v) => $enumDecode(_$AdjustmentResultDtoPeriodStatusEnumEnumMap, v),
        ),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdjustmentResultDtoToJson(
  AdjustmentResultDto instance,
) => <String, dynamic>{
  'entryId': instance.entryId,
  'periodId': instance.periodId,
  'amountBs': instance.amountBs,
  'periodStatus':
      _$AdjustmentResultDtoPeriodStatusEnumEnumMap[instance.periodStatus]!,
  'balanceBs': instance.balanceBs,
};

const _$AdjustmentResultDtoPeriodStatusEnumEnumMap = {
  AdjustmentResultDtoPeriodStatusEnum.abierto: 'abierto',
  AdjustmentResultDtoPeriodStatusEnum.cerradoPendiente: 'cerrado_pendiente',
  AdjustmentResultDtoPeriodStatusEnum.pagado: 'pagado',
  AdjustmentResultDtoPeriodStatusEnum.vencido: 'vencido',
};

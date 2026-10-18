// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_allocation_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PreviewAllocationDtoCWProxy {
  PreviewAllocationDto periodId(String? periodId);

  PreviewAllocationDto paymentReference(String? paymentReference);

  PreviewAllocationDto amountBs(String amountBs);

  PreviewAllocationDto periodBalanceAfterBs(String periodBalanceAfterBs);

  PreviewAllocationDto statusAfter(
    PreviewAllocationDtoStatusAfterEnum statusAfter,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PreviewAllocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PreviewAllocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PreviewAllocationDto call({
    String? periodId,
    String? paymentReference,
    String amountBs,
    String periodBalanceAfterBs,
    PreviewAllocationDtoStatusAfterEnum statusAfter,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPreviewAllocationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPreviewAllocationDto.copyWith.fieldName(...)`
class _$PreviewAllocationDtoCWProxyImpl
    implements _$PreviewAllocationDtoCWProxy {
  const _$PreviewAllocationDtoCWProxyImpl(this._value);

  final PreviewAllocationDto _value;

  @override
  PreviewAllocationDto periodId(String? periodId) => this(periodId: periodId);

  @override
  PreviewAllocationDto paymentReference(String? paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  PreviewAllocationDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  PreviewAllocationDto periodBalanceAfterBs(String periodBalanceAfterBs) =>
      this(periodBalanceAfterBs: periodBalanceAfterBs);

  @override
  PreviewAllocationDto statusAfter(
    PreviewAllocationDtoStatusAfterEnum statusAfter,
  ) => this(statusAfter: statusAfter);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PreviewAllocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PreviewAllocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PreviewAllocationDto call({
    Object? periodId = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? periodBalanceAfterBs = const $CopyWithPlaceholder(),
    Object? statusAfter = const $CopyWithPlaceholder(),
  }) {
    return PreviewAllocationDto(
      periodId: periodId == const $CopyWithPlaceholder()
          ? _value.periodId
          // ignore: cast_nullable_to_non_nullable
          : periodId as String?,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String?,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      periodBalanceAfterBs: periodBalanceAfterBs == const $CopyWithPlaceholder()
          ? _value.periodBalanceAfterBs
          // ignore: cast_nullable_to_non_nullable
          : periodBalanceAfterBs as String,
      statusAfter: statusAfter == const $CopyWithPlaceholder()
          ? _value.statusAfter
          // ignore: cast_nullable_to_non_nullable
          : statusAfter as PreviewAllocationDtoStatusAfterEnum,
    );
  }
}

extension $PreviewAllocationDtoCopyWith on PreviewAllocationDto {
  /// Returns a callable class that can be used as follows: `instanceOfPreviewAllocationDto.copyWith(...)` or like so:`instanceOfPreviewAllocationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PreviewAllocationDtoCWProxy get copyWith =>
      _$PreviewAllocationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewAllocationDto _$PreviewAllocationDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PreviewAllocationDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'periodId',
      'paymentReference',
      'amountBs',
      'periodBalanceAfterBs',
      'statusAfter',
    ],
  );
  final val = PreviewAllocationDto(
    periodId: $checkedConvert('periodId', (v) => v as String?),
    paymentReference: $checkedConvert('paymentReference', (v) => v as String?),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
    periodBalanceAfterBs: $checkedConvert(
      'periodBalanceAfterBs',
      (v) => v as String,
    ),
    statusAfter: $checkedConvert(
      'statusAfter',
      (v) => $enumDecode(_$PreviewAllocationDtoStatusAfterEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$PreviewAllocationDtoToJson(
  PreviewAllocationDto instance,
) => <String, dynamic>{
  'periodId': instance.periodId,
  'paymentReference': instance.paymentReference,
  'amountBs': instance.amountBs,
  'periodBalanceAfterBs': instance.periodBalanceAfterBs,
  'statusAfter':
      _$PreviewAllocationDtoStatusAfterEnumEnumMap[instance.statusAfter]!,
};

const _$PreviewAllocationDtoStatusAfterEnumEnumMap = {
  PreviewAllocationDtoStatusAfterEnum.abierto: 'abierto',
  PreviewAllocationDtoStatusAfterEnum.cerradoPendiente: 'cerrado_pendiente',
  PreviewAllocationDtoStatusAfterEnum.pagado: 'pagado',
  PreviewAllocationDtoStatusAfterEnum.vencido: 'vencido',
};

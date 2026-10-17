// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allocation_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AllocationDtoCWProxy {
  AllocationDto periodId(String periodId);

  AllocationDto paymentReference(String paymentReference);

  AllocationDto amountBs(String amountBs);

  AllocationDto status(AllocationDtoStatusEnum status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AllocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AllocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AllocationDto call({
    String periodId,
    String paymentReference,
    String amountBs,
    AllocationDtoStatusEnum status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAllocationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAllocationDto.copyWith.fieldName(...)`
class _$AllocationDtoCWProxyImpl implements _$AllocationDtoCWProxy {
  const _$AllocationDtoCWProxyImpl(this._value);

  final AllocationDto _value;

  @override
  AllocationDto periodId(String periodId) => this(periodId: periodId);

  @override
  AllocationDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  AllocationDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  AllocationDto status(AllocationDtoStatusEnum status) => this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AllocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AllocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AllocationDto call({
    Object? periodId = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return AllocationDto(
      periodId: periodId == const $CopyWithPlaceholder()
          ? _value.periodId
          // ignore: cast_nullable_to_non_nullable
          : periodId as String,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AllocationDtoStatusEnum,
    );
  }
}

extension $AllocationDtoCopyWith on AllocationDto {
  /// Returns a callable class that can be used as follows: `instanceOfAllocationDto.copyWith(...)` or like so:`instanceOfAllocationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AllocationDtoCWProxy get copyWith => _$AllocationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllocationDto _$AllocationDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AllocationDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['periodId', 'paymentReference', 'amountBs', 'status'],
  );
  final val = AllocationDto(
    periodId: $checkedConvert('periodId', (v) => v as String),
    paymentReference: $checkedConvert('paymentReference', (v) => v as String),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$AllocationDtoStatusEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$AllocationDtoToJson(AllocationDto instance) =>
    <String, dynamic>{
      'periodId': instance.periodId,
      'paymentReference': instance.paymentReference,
      'amountBs': instance.amountBs,
      'status': _$AllocationDtoStatusEnumEnumMap[instance.status]!,
    };

const _$AllocationDtoStatusEnumEnumMap = {
  AllocationDtoStatusEnum.abierto: 'abierto',
  AllocationDtoStatusEnum.cerradoPendiente: 'cerrado_pendiente',
  AllocationDtoStatusEnum.pagado: 'pagado',
  AllocationDtoStatusEnum.vencido: 'vencido',
};

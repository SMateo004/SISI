// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_allocation_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaymentAllocationDtoCWProxy {
  PaymentAllocationDto periodId(String periodId);

  PaymentAllocationDto paymentReference(String paymentReference);

  PaymentAllocationDto amountBs(String amountBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentAllocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentAllocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentAllocationDto call({
    String periodId,
    String paymentReference,
    String amountBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPaymentAllocationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPaymentAllocationDto.copyWith.fieldName(...)`
class _$PaymentAllocationDtoCWProxyImpl
    implements _$PaymentAllocationDtoCWProxy {
  const _$PaymentAllocationDtoCWProxyImpl(this._value);

  final PaymentAllocationDto _value;

  @override
  PaymentAllocationDto periodId(String periodId) => this(periodId: periodId);

  @override
  PaymentAllocationDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  PaymentAllocationDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentAllocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentAllocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentAllocationDto call({
    Object? periodId = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
  }) {
    return PaymentAllocationDto(
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
    );
  }
}

extension $PaymentAllocationDtoCopyWith on PaymentAllocationDto {
  /// Returns a callable class that can be used as follows: `instanceOfPaymentAllocationDto.copyWith(...)` or like so:`instanceOfPaymentAllocationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaymentAllocationDtoCWProxy get copyWith =>
      _$PaymentAllocationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentAllocationDto _$PaymentAllocationDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PaymentAllocationDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['periodId', 'paymentReference', 'amountBs'],
  );
  final val = PaymentAllocationDto(
    periodId: $checkedConvert('periodId', (v) => v as String),
    paymentReference: $checkedConvert('paymentReference', (v) => v as String),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$PaymentAllocationDtoToJson(
  PaymentAllocationDto instance,
) => <String, dynamic>{
  'periodId': instance.periodId,
  'paymentReference': instance.paymentReference,
  'amountBs': instance.amountBs,
};

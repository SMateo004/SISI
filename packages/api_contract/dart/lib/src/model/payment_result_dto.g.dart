// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaymentResultDtoCWProxy {
  PaymentResultDto paymentId(String paymentId);

  PaymentResultDto workerId(String workerId);

  PaymentResultDto amountBs(String amountBs);

  PaymentResultDto allocations(List<AllocationDto> allocations);

  PaymentResultDto balanceBs(String balanceBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentResultDto call({
    String paymentId,
    String workerId,
    String amountBs,
    List<AllocationDto> allocations,
    String balanceBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPaymentResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPaymentResultDto.copyWith.fieldName(...)`
class _$PaymentResultDtoCWProxyImpl implements _$PaymentResultDtoCWProxy {
  const _$PaymentResultDtoCWProxyImpl(this._value);

  final PaymentResultDto _value;

  @override
  PaymentResultDto paymentId(String paymentId) => this(paymentId: paymentId);

  @override
  PaymentResultDto workerId(String workerId) => this(workerId: workerId);

  @override
  PaymentResultDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  PaymentResultDto allocations(List<AllocationDto> allocations) =>
      this(allocations: allocations);

  @override
  PaymentResultDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentResultDto call({
    Object? paymentId = const $CopyWithPlaceholder(),
    Object? workerId = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? allocations = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
  }) {
    return PaymentResultDto(
      paymentId: paymentId == const $CopyWithPlaceholder()
          ? _value.paymentId
          // ignore: cast_nullable_to_non_nullable
          : paymentId as String,
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      allocations: allocations == const $CopyWithPlaceholder()
          ? _value.allocations
          // ignore: cast_nullable_to_non_nullable
          : allocations as List<AllocationDto>,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
    );
  }
}

extension $PaymentResultDtoCopyWith on PaymentResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfPaymentResultDto.copyWith(...)` or like so:`instanceOfPaymentResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaymentResultDtoCWProxy get copyWith => _$PaymentResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentResultDto _$PaymentResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PaymentResultDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'paymentId',
          'workerId',
          'amountBs',
          'allocations',
          'balanceBs',
        ],
      );
      final val = PaymentResultDto(
        paymentId: $checkedConvert('paymentId', (v) => v as String),
        workerId: $checkedConvert('workerId', (v) => v as String),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        allocations: $checkedConvert(
          'allocations',
          (v) => (v as List<dynamic>)
              .map((e) => AllocationDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PaymentResultDtoToJson(PaymentResultDto instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'workerId': instance.workerId,
      'amountBs': instance.amountBs,
      'allocations': instance.allocations.map((e) => e.toJson()).toList(),
      'balanceBs': instance.balanceBs,
    };

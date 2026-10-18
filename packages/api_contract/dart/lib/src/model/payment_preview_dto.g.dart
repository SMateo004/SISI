// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_preview_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaymentPreviewDtoCWProxy {
  PaymentPreviewDto workerId(String workerId);

  PaymentPreviewDto amountBs(String amountBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentPreviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentPreviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentPreviewDto call({String workerId, String amountBs});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPaymentPreviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPaymentPreviewDto.copyWith.fieldName(...)`
class _$PaymentPreviewDtoCWProxyImpl implements _$PaymentPreviewDtoCWProxy {
  const _$PaymentPreviewDtoCWProxyImpl(this._value);

  final PaymentPreviewDto _value;

  @override
  PaymentPreviewDto workerId(String workerId) => this(workerId: workerId);

  @override
  PaymentPreviewDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentPreviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentPreviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentPreviewDto call({
    Object? workerId = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
  }) {
    return PaymentPreviewDto(
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
    );
  }
}

extension $PaymentPreviewDtoCopyWith on PaymentPreviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfPaymentPreviewDto.copyWith(...)` or like so:`instanceOfPaymentPreviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaymentPreviewDtoCWProxy get copyWith =>
      _$PaymentPreviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentPreviewDto _$PaymentPreviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PaymentPreviewDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['workerId', 'amountBs']);
      final val = PaymentPreviewDto(
        workerId: $checkedConvert('workerId', (v) => v as String),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PaymentPreviewDtoToJson(PaymentPreviewDto instance) =>
    <String, dynamic>{
      'workerId': instance.workerId,
      'amountBs': instance.amountBs,
    };

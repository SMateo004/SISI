// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_payment_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RegisterPaymentDtoCWProxy {
  RegisterPaymentDto workerId(String workerId);

  RegisterPaymentDto amountBs(String amountBs);

  RegisterPaymentDto method(RegisterPaymentDtoMethodEnum method);

  RegisterPaymentDto paidAt(DateTime paidAt);

  RegisterPaymentDto reference(String? reference);

  RegisterPaymentDto receiptKey(String? receiptKey);

  RegisterPaymentDto submissionId(String? submissionId);

  RegisterPaymentDto invoiceNumber(String? invoiceNumber);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RegisterPaymentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RegisterPaymentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RegisterPaymentDto call({
    String workerId,
    String amountBs,
    RegisterPaymentDtoMethodEnum method,
    DateTime paidAt,
    String? reference,
    String? receiptKey,
    String? submissionId,
    String? invoiceNumber,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRegisterPaymentDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRegisterPaymentDto.copyWith.fieldName(...)`
class _$RegisterPaymentDtoCWProxyImpl implements _$RegisterPaymentDtoCWProxy {
  const _$RegisterPaymentDtoCWProxyImpl(this._value);

  final RegisterPaymentDto _value;

  @override
  RegisterPaymentDto workerId(String workerId) => this(workerId: workerId);

  @override
  RegisterPaymentDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  RegisterPaymentDto method(RegisterPaymentDtoMethodEnum method) =>
      this(method: method);

  @override
  RegisterPaymentDto paidAt(DateTime paidAt) => this(paidAt: paidAt);

  @override
  RegisterPaymentDto reference(String? reference) => this(reference: reference);

  @override
  RegisterPaymentDto receiptKey(String? receiptKey) =>
      this(receiptKey: receiptKey);

  @override
  RegisterPaymentDto submissionId(String? submissionId) =>
      this(submissionId: submissionId);

  @override
  RegisterPaymentDto invoiceNumber(String? invoiceNumber) =>
      this(invoiceNumber: invoiceNumber);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RegisterPaymentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RegisterPaymentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RegisterPaymentDto call({
    Object? workerId = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? paidAt = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
    Object? receiptKey = const $CopyWithPlaceholder(),
    Object? submissionId = const $CopyWithPlaceholder(),
    Object? invoiceNumber = const $CopyWithPlaceholder(),
  }) {
    return RegisterPaymentDto(
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      method: method == const $CopyWithPlaceholder()
          ? _value.method
          // ignore: cast_nullable_to_non_nullable
          : method as RegisterPaymentDtoMethodEnum,
      paidAt: paidAt == const $CopyWithPlaceholder()
          ? _value.paidAt
          // ignore: cast_nullable_to_non_nullable
          : paidAt as DateTime,
      reference: reference == const $CopyWithPlaceholder()
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as String?,
      receiptKey: receiptKey == const $CopyWithPlaceholder()
          ? _value.receiptKey
          // ignore: cast_nullable_to_non_nullable
          : receiptKey as String?,
      submissionId: submissionId == const $CopyWithPlaceholder()
          ? _value.submissionId
          // ignore: cast_nullable_to_non_nullable
          : submissionId as String?,
      invoiceNumber: invoiceNumber == const $CopyWithPlaceholder()
          ? _value.invoiceNumber
          // ignore: cast_nullable_to_non_nullable
          : invoiceNumber as String?,
    );
  }
}

extension $RegisterPaymentDtoCopyWith on RegisterPaymentDto {
  /// Returns a callable class that can be used as follows: `instanceOfRegisterPaymentDto.copyWith(...)` or like so:`instanceOfRegisterPaymentDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RegisterPaymentDtoCWProxy get copyWith =>
      _$RegisterPaymentDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterPaymentDto _$RegisterPaymentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RegisterPaymentDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['workerId', 'amountBs', 'method', 'paidAt'],
      );
      final val = RegisterPaymentDto(
        workerId: $checkedConvert('workerId', (v) => v as String),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        method: $checkedConvert(
          'method',
          (v) => $enumDecode(_$RegisterPaymentDtoMethodEnumEnumMap, v),
        ),
        paidAt: $checkedConvert('paidAt', (v) => DateTime.parse(v as String)),
        reference: $checkedConvert('reference', (v) => v as String?),
        receiptKey: $checkedConvert('receiptKey', (v) => v as String?),
        submissionId: $checkedConvert('submissionId', (v) => v as String?),
        invoiceNumber: $checkedConvert('invoiceNumber', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RegisterPaymentDtoToJson(RegisterPaymentDto instance) =>
    <String, dynamic>{
      'workerId': instance.workerId,
      'amountBs': instance.amountBs,
      'method': _$RegisterPaymentDtoMethodEnumEnumMap[instance.method]!,
      'paidAt': instance.paidAt.toIso8601String(),
      'reference': ?instance.reference,
      'receiptKey': ?instance.receiptKey,
      'submissionId': ?instance.submissionId,
      'invoiceNumber': ?instance.invoiceNumber,
    };

const _$RegisterPaymentDtoMethodEnumEnumMap = {
  RegisterPaymentDtoMethodEnum.qrTransferencia: 'qr_transferencia',
  RegisterPaymentDtoMethodEnum.efectivo: 'efectivo',
  RegisterPaymentDtoMethodEnum.otro: 'otro',
};

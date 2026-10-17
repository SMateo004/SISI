// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_payment_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyPaymentDtoCWProxy {
  MyPaymentDto id(String id);

  MyPaymentDto amountBs(String amountBs);

  MyPaymentDto paidAt(DateTime paidAt);

  MyPaymentDto method(MyPaymentDtoMethodEnum method);

  MyPaymentDto status(MyPaymentDtoStatusEnum status);

  MyPaymentDto reference(String? reference);

  MyPaymentDto periods(List<PaymentAllocationDto> periods);

  MyPaymentDto receiptUrl(String? receiptUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyPaymentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyPaymentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MyPaymentDto call({
    String id,
    String amountBs,
    DateTime paidAt,
    MyPaymentDtoMethodEnum method,
    MyPaymentDtoStatusEnum status,
    String? reference,
    List<PaymentAllocationDto> periods,
    String? receiptUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyPaymentDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyPaymentDto.copyWith.fieldName(...)`
class _$MyPaymentDtoCWProxyImpl implements _$MyPaymentDtoCWProxy {
  const _$MyPaymentDtoCWProxyImpl(this._value);

  final MyPaymentDto _value;

  @override
  MyPaymentDto id(String id) => this(id: id);

  @override
  MyPaymentDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  MyPaymentDto paidAt(DateTime paidAt) => this(paidAt: paidAt);

  @override
  MyPaymentDto method(MyPaymentDtoMethodEnum method) => this(method: method);

  @override
  MyPaymentDto status(MyPaymentDtoStatusEnum status) => this(status: status);

  @override
  MyPaymentDto reference(String? reference) => this(reference: reference);

  @override
  MyPaymentDto periods(List<PaymentAllocationDto> periods) =>
      this(periods: periods);

  @override
  MyPaymentDto receiptUrl(String? receiptUrl) => this(receiptUrl: receiptUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyPaymentDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyPaymentDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MyPaymentDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? paidAt = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? reference = const $CopyWithPlaceholder(),
    Object? periods = const $CopyWithPlaceholder(),
    Object? receiptUrl = const $CopyWithPlaceholder(),
  }) {
    return MyPaymentDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      paidAt: paidAt == const $CopyWithPlaceholder()
          ? _value.paidAt
          // ignore: cast_nullable_to_non_nullable
          : paidAt as DateTime,
      method: method == const $CopyWithPlaceholder()
          ? _value.method
          // ignore: cast_nullable_to_non_nullable
          : method as MyPaymentDtoMethodEnum,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as MyPaymentDtoStatusEnum,
      reference: reference == const $CopyWithPlaceholder()
          ? _value.reference
          // ignore: cast_nullable_to_non_nullable
          : reference as String?,
      periods: periods == const $CopyWithPlaceholder()
          ? _value.periods
          // ignore: cast_nullable_to_non_nullable
          : periods as List<PaymentAllocationDto>,
      receiptUrl: receiptUrl == const $CopyWithPlaceholder()
          ? _value.receiptUrl
          // ignore: cast_nullable_to_non_nullable
          : receiptUrl as String?,
    );
  }
}

extension $MyPaymentDtoCopyWith on MyPaymentDto {
  /// Returns a callable class that can be used as follows: `instanceOfMyPaymentDto.copyWith(...)` or like so:`instanceOfMyPaymentDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MyPaymentDtoCWProxy get copyWith => _$MyPaymentDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPaymentDto _$MyPaymentDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MyPaymentDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'amountBs',
          'paidAt',
          'method',
          'status',
          'reference',
          'periods',
          'receiptUrl',
        ],
      );
      final val = MyPaymentDto(
        id: $checkedConvert('id', (v) => v as String),
        amountBs: $checkedConvert('amountBs', (v) => v as String),
        paidAt: $checkedConvert('paidAt', (v) => DateTime.parse(v as String)),
        method: $checkedConvert(
          'method',
          (v) => $enumDecode(_$MyPaymentDtoMethodEnumEnumMap, v),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$MyPaymentDtoStatusEnumEnumMap, v),
        ),
        reference: $checkedConvert('reference', (v) => v as String?),
        periods: $checkedConvert(
          'periods',
          (v) => (v as List<dynamic>)
              .map(
                (e) => PaymentAllocationDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        receiptUrl: $checkedConvert('receiptUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MyPaymentDtoToJson(MyPaymentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amountBs': instance.amountBs,
      'paidAt': instance.paidAt.toIso8601String(),
      'method': _$MyPaymentDtoMethodEnumEnumMap[instance.method]!,
      'status': _$MyPaymentDtoStatusEnumEnumMap[instance.status]!,
      'reference': instance.reference,
      'periods': instance.periods.map((e) => e.toJson()).toList(),
      'receiptUrl': instance.receiptUrl,
    };

const _$MyPaymentDtoMethodEnumEnumMap = {
  MyPaymentDtoMethodEnum.qrTransferencia: 'qr_transferencia',
  MyPaymentDtoMethodEnum.efectivo: 'efectivo',
  MyPaymentDtoMethodEnum.otro: 'otro',
};

const _$MyPaymentDtoStatusEnumEnumMap = {
  MyPaymentDtoStatusEnum.registrado: 'registrado',
};

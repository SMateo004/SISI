// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_submission_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PaymentSubmissionDtoCWProxy {
  PaymentSubmissionDto id(String id);

  PaymentSubmissionDto workerId(String workerId);

  PaymentSubmissionDto status(PaymentSubmissionDtoStatusEnum status);

  PaymentSubmissionDto declaredAmountBs(String? declaredAmountBs);

  PaymentSubmissionDto note(String? note);

  PaymentSubmissionDto reviewNote(String? reviewNote);

  PaymentSubmissionDto paymentId(String? paymentId);

  PaymentSubmissionDto receiptUrl(String receiptUrl);

  PaymentSubmissionDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentSubmissionDto call({
    String id,
    String workerId,
    PaymentSubmissionDtoStatusEnum status,
    String? declaredAmountBs,
    String? note,
    String? reviewNote,
    String? paymentId,
    String receiptUrl,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPaymentSubmissionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPaymentSubmissionDto.copyWith.fieldName(...)`
class _$PaymentSubmissionDtoCWProxyImpl
    implements _$PaymentSubmissionDtoCWProxy {
  const _$PaymentSubmissionDtoCWProxyImpl(this._value);

  final PaymentSubmissionDto _value;

  @override
  PaymentSubmissionDto id(String id) => this(id: id);

  @override
  PaymentSubmissionDto workerId(String workerId) => this(workerId: workerId);

  @override
  PaymentSubmissionDto status(PaymentSubmissionDtoStatusEnum status) =>
      this(status: status);

  @override
  PaymentSubmissionDto declaredAmountBs(String? declaredAmountBs) =>
      this(declaredAmountBs: declaredAmountBs);

  @override
  PaymentSubmissionDto note(String? note) => this(note: note);

  @override
  PaymentSubmissionDto reviewNote(String? reviewNote) =>
      this(reviewNote: reviewNote);

  @override
  PaymentSubmissionDto paymentId(String? paymentId) =>
      this(paymentId: paymentId);

  @override
  PaymentSubmissionDto receiptUrl(String receiptUrl) =>
      this(receiptUrl: receiptUrl);

  @override
  PaymentSubmissionDto createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PaymentSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PaymentSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PaymentSubmissionDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? workerId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? declaredAmountBs = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? reviewNote = const $CopyWithPlaceholder(),
    Object? paymentId = const $CopyWithPlaceholder(),
    Object? receiptUrl = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return PaymentSubmissionDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as PaymentSubmissionDtoStatusEnum,
      declaredAmountBs: declaredAmountBs == const $CopyWithPlaceholder()
          ? _value.declaredAmountBs
          // ignore: cast_nullable_to_non_nullable
          : declaredAmountBs as String?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      reviewNote: reviewNote == const $CopyWithPlaceholder()
          ? _value.reviewNote
          // ignore: cast_nullable_to_non_nullable
          : reviewNote as String?,
      paymentId: paymentId == const $CopyWithPlaceholder()
          ? _value.paymentId
          // ignore: cast_nullable_to_non_nullable
          : paymentId as String?,
      receiptUrl: receiptUrl == const $CopyWithPlaceholder()
          ? _value.receiptUrl
          // ignore: cast_nullable_to_non_nullable
          : receiptUrl as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $PaymentSubmissionDtoCopyWith on PaymentSubmissionDto {
  /// Returns a callable class that can be used as follows: `instanceOfPaymentSubmissionDto.copyWith(...)` or like so:`instanceOfPaymentSubmissionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PaymentSubmissionDtoCWProxy get copyWith =>
      _$PaymentSubmissionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSubmissionDto _$PaymentSubmissionDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PaymentSubmissionDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'workerId',
      'status',
      'declaredAmountBs',
      'note',
      'reviewNote',
      'paymentId',
      'receiptUrl',
      'createdAt',
    ],
  );
  final val = PaymentSubmissionDto(
    id: $checkedConvert('id', (v) => v as String),
    workerId: $checkedConvert('workerId', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$PaymentSubmissionDtoStatusEnumEnumMap, v),
    ),
    declaredAmountBs: $checkedConvert('declaredAmountBs', (v) => v as String?),
    note: $checkedConvert('note', (v) => v as String?),
    reviewNote: $checkedConvert('reviewNote', (v) => v as String?),
    paymentId: $checkedConvert('paymentId', (v) => v as String?),
    receiptUrl: $checkedConvert('receiptUrl', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$PaymentSubmissionDtoToJson(
  PaymentSubmissionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'workerId': instance.workerId,
  'status': _$PaymentSubmissionDtoStatusEnumEnumMap[instance.status]!,
  'declaredAmountBs': instance.declaredAmountBs,
  'note': instance.note,
  'reviewNote': instance.reviewNote,
  'paymentId': instance.paymentId,
  'receiptUrl': instance.receiptUrl,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$PaymentSubmissionDtoStatusEnumEnumMap = {
  PaymentSubmissionDtoStatusEnum.pendiente: 'pendiente',
  PaymentSubmissionDtoStatusEnum.registrado: 'registrado',
  PaymentSubmissionDtoStatusEnum.rechazado: 'rechazado',
};

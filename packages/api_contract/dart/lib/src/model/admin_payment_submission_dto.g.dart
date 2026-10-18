// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_submission_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminPaymentSubmissionDtoCWProxy {
  AdminPaymentSubmissionDto id(String id);

  AdminPaymentSubmissionDto workerId(String workerId);

  AdminPaymentSubmissionDto status(AdminPaymentSubmissionDtoStatusEnum status);

  AdminPaymentSubmissionDto declaredAmountBs(String? declaredAmountBs);

  AdminPaymentSubmissionDto note(String? note);

  AdminPaymentSubmissionDto reviewNote(String? reviewNote);

  AdminPaymentSubmissionDto paymentId(String? paymentId);

  AdminPaymentSubmissionDto receiptUrl(String receiptUrl);

  AdminPaymentSubmissionDto createdAt(DateTime createdAt);

  AdminPaymentSubmissionDto workerName(String? workerName);

  AdminPaymentSubmissionDto workerPhone(String workerPhone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPaymentSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPaymentSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPaymentSubmissionDto call({
    String id,
    String workerId,
    AdminPaymentSubmissionDtoStatusEnum status,
    String? declaredAmountBs,
    String? note,
    String? reviewNote,
    String? paymentId,
    String receiptUrl,
    DateTime createdAt,
    String? workerName,
    String workerPhone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminPaymentSubmissionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminPaymentSubmissionDto.copyWith.fieldName(...)`
class _$AdminPaymentSubmissionDtoCWProxyImpl
    implements _$AdminPaymentSubmissionDtoCWProxy {
  const _$AdminPaymentSubmissionDtoCWProxyImpl(this._value);

  final AdminPaymentSubmissionDto _value;

  @override
  AdminPaymentSubmissionDto id(String id) => this(id: id);

  @override
  AdminPaymentSubmissionDto workerId(String workerId) =>
      this(workerId: workerId);

  @override
  AdminPaymentSubmissionDto status(
    AdminPaymentSubmissionDtoStatusEnum status,
  ) => this(status: status);

  @override
  AdminPaymentSubmissionDto declaredAmountBs(String? declaredAmountBs) =>
      this(declaredAmountBs: declaredAmountBs);

  @override
  AdminPaymentSubmissionDto note(String? note) => this(note: note);

  @override
  AdminPaymentSubmissionDto reviewNote(String? reviewNote) =>
      this(reviewNote: reviewNote);

  @override
  AdminPaymentSubmissionDto paymentId(String? paymentId) =>
      this(paymentId: paymentId);

  @override
  AdminPaymentSubmissionDto receiptUrl(String receiptUrl) =>
      this(receiptUrl: receiptUrl);

  @override
  AdminPaymentSubmissionDto createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  AdminPaymentSubmissionDto workerName(String? workerName) =>
      this(workerName: workerName);

  @override
  AdminPaymentSubmissionDto workerPhone(String workerPhone) =>
      this(workerPhone: workerPhone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPaymentSubmissionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPaymentSubmissionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPaymentSubmissionDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? workerId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? declaredAmountBs = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? reviewNote = const $CopyWithPlaceholder(),
    Object? paymentId = const $CopyWithPlaceholder(),
    Object? receiptUrl = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? workerName = const $CopyWithPlaceholder(),
    Object? workerPhone = const $CopyWithPlaceholder(),
  }) {
    return AdminPaymentSubmissionDto(
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
          : status as AdminPaymentSubmissionDtoStatusEnum,
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
      workerName: workerName == const $CopyWithPlaceholder()
          ? _value.workerName
          // ignore: cast_nullable_to_non_nullable
          : workerName as String?,
      workerPhone: workerPhone == const $CopyWithPlaceholder()
          ? _value.workerPhone
          // ignore: cast_nullable_to_non_nullable
          : workerPhone as String,
    );
  }
}

extension $AdminPaymentSubmissionDtoCopyWith on AdminPaymentSubmissionDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminPaymentSubmissionDto.copyWith(...)` or like so:`instanceOfAdminPaymentSubmissionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminPaymentSubmissionDtoCWProxy get copyWith =>
      _$AdminPaymentSubmissionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminPaymentSubmissionDto _$AdminPaymentSubmissionDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminPaymentSubmissionDto', json, ($checkedConvert) {
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
      'workerName',
      'workerPhone',
    ],
  );
  final val = AdminPaymentSubmissionDto(
    id: $checkedConvert('id', (v) => v as String),
    workerId: $checkedConvert('workerId', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$AdminPaymentSubmissionDtoStatusEnumEnumMap, v),
    ),
    declaredAmountBs: $checkedConvert('declaredAmountBs', (v) => v as String?),
    note: $checkedConvert('note', (v) => v as String?),
    reviewNote: $checkedConvert('reviewNote', (v) => v as String?),
    paymentId: $checkedConvert('paymentId', (v) => v as String?),
    receiptUrl: $checkedConvert('receiptUrl', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    workerName: $checkedConvert('workerName', (v) => v as String?),
    workerPhone: $checkedConvert('workerPhone', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AdminPaymentSubmissionDtoToJson(
  AdminPaymentSubmissionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'workerId': instance.workerId,
  'status': _$AdminPaymentSubmissionDtoStatusEnumEnumMap[instance.status]!,
  'declaredAmountBs': instance.declaredAmountBs,
  'note': instance.note,
  'reviewNote': instance.reviewNote,
  'paymentId': instance.paymentId,
  'receiptUrl': instance.receiptUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'workerName': instance.workerName,
  'workerPhone': instance.workerPhone,
};

const _$AdminPaymentSubmissionDtoStatusEnumEnumMap = {
  AdminPaymentSubmissionDtoStatusEnum.pendiente: 'pendiente',
  AdminPaymentSubmissionDtoStatusEnum.registrado: 'registrado',
  AdminPaymentSubmissionDtoStatusEnum.rechazado: 'rechazado',
};

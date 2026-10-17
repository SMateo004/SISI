// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ledger_entry_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminLedgerEntryDtoCWProxy {
  AdminLedgerEntryDto id(String id);

  AdminLedgerEntryDto type(AdminLedgerEntryDtoTypeEnum type);

  AdminLedgerEntryDto amountBs(String amountBs);

  AdminLedgerEntryDto periodId(String periodId);

  AdminLedgerEntryDto jobId(String? jobId);

  AdminLedgerEntryDto paymentId(String? paymentId);

  AdminLedgerEntryDto correctsEntryId(String? correctsEntryId);

  AdminLedgerEntryDto reason(String? reason);

  AdminLedgerEntryDto createdById(String? createdById);

  AdminLedgerEntryDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminLedgerEntryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminLedgerEntryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminLedgerEntryDto call({
    String id,
    AdminLedgerEntryDtoTypeEnum type,
    String amountBs,
    String periodId,
    String? jobId,
    String? paymentId,
    String? correctsEntryId,
    String? reason,
    String? createdById,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminLedgerEntryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminLedgerEntryDto.copyWith.fieldName(...)`
class _$AdminLedgerEntryDtoCWProxyImpl implements _$AdminLedgerEntryDtoCWProxy {
  const _$AdminLedgerEntryDtoCWProxyImpl(this._value);

  final AdminLedgerEntryDto _value;

  @override
  AdminLedgerEntryDto id(String id) => this(id: id);

  @override
  AdminLedgerEntryDto type(AdminLedgerEntryDtoTypeEnum type) =>
      this(type: type);

  @override
  AdminLedgerEntryDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  AdminLedgerEntryDto periodId(String periodId) => this(periodId: periodId);

  @override
  AdminLedgerEntryDto jobId(String? jobId) => this(jobId: jobId);

  @override
  AdminLedgerEntryDto paymentId(String? paymentId) =>
      this(paymentId: paymentId);

  @override
  AdminLedgerEntryDto correctsEntryId(String? correctsEntryId) =>
      this(correctsEntryId: correctsEntryId);

  @override
  AdminLedgerEntryDto reason(String? reason) => this(reason: reason);

  @override
  AdminLedgerEntryDto createdById(String? createdById) =>
      this(createdById: createdById);

  @override
  AdminLedgerEntryDto createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminLedgerEntryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminLedgerEntryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminLedgerEntryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? periodId = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? paymentId = const $CopyWithPlaceholder(),
    Object? correctsEntryId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? createdById = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AdminLedgerEntryDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as AdminLedgerEntryDtoTypeEnum,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      periodId: periodId == const $CopyWithPlaceholder()
          ? _value.periodId
          // ignore: cast_nullable_to_non_nullable
          : periodId as String,
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String?,
      paymentId: paymentId == const $CopyWithPlaceholder()
          ? _value.paymentId
          // ignore: cast_nullable_to_non_nullable
          : paymentId as String?,
      correctsEntryId: correctsEntryId == const $CopyWithPlaceholder()
          ? _value.correctsEntryId
          // ignore: cast_nullable_to_non_nullable
          : correctsEntryId as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
      createdById: createdById == const $CopyWithPlaceholder()
          ? _value.createdById
          // ignore: cast_nullable_to_non_nullable
          : createdById as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $AdminLedgerEntryDtoCopyWith on AdminLedgerEntryDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminLedgerEntryDto.copyWith(...)` or like so:`instanceOfAdminLedgerEntryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminLedgerEntryDtoCWProxy get copyWith =>
      _$AdminLedgerEntryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminLedgerEntryDto _$AdminLedgerEntryDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminLedgerEntryDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'type',
      'amountBs',
      'periodId',
      'jobId',
      'paymentId',
      'correctsEntryId',
      'reason',
      'createdById',
      'createdAt',
    ],
  );
  final val = AdminLedgerEntryDto(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$AdminLedgerEntryDtoTypeEnumEnumMap, v),
    ),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
    periodId: $checkedConvert('periodId', (v) => v as String),
    jobId: $checkedConvert('jobId', (v) => v as String?),
    paymentId: $checkedConvert('paymentId', (v) => v as String?),
    correctsEntryId: $checkedConvert('correctsEntryId', (v) => v as String?),
    reason: $checkedConvert('reason', (v) => v as String?),
    createdById: $checkedConvert('createdById', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$AdminLedgerEntryDtoToJson(
  AdminLedgerEntryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$AdminLedgerEntryDtoTypeEnumEnumMap[instance.type]!,
  'amountBs': instance.amountBs,
  'periodId': instance.periodId,
  'jobId': instance.jobId,
  'paymentId': instance.paymentId,
  'correctsEntryId': instance.correctsEntryId,
  'reason': instance.reason,
  'createdById': instance.createdById,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$AdminLedgerEntryDtoTypeEnumEnumMap = {
  AdminLedgerEntryDtoTypeEnum.comision: 'comision',
  AdminLedgerEntryDtoTypeEnum.pago: 'pago',
  AdminLedgerEntryDtoTypeEnum.ajuste: 'ajuste',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LedgerRowDtoCWProxy {
  LedgerRowDto id(String id);

  LedgerRowDto type(LedgerRowDtoTypeEnum type);

  LedgerRowDto amountBs(String amountBs);

  LedgerRowDto runningBs(String runningBs);

  LedgerRowDto paymentReference(String paymentReference);

  LedgerRowDto jobId(String? jobId);

  LedgerRowDto paymentId(String? paymentId);

  LedgerRowDto correctsEntryId(String? correctsEntryId);

  LedgerRowDto reason(String? reason);

  LedgerRowDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LedgerRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LedgerRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LedgerRowDto call({
    String id,
    LedgerRowDtoTypeEnum type,
    String amountBs,
    String runningBs,
    String paymentReference,
    String? jobId,
    String? paymentId,
    String? correctsEntryId,
    String? reason,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLedgerRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLedgerRowDto.copyWith.fieldName(...)`
class _$LedgerRowDtoCWProxyImpl implements _$LedgerRowDtoCWProxy {
  const _$LedgerRowDtoCWProxyImpl(this._value);

  final LedgerRowDto _value;

  @override
  LedgerRowDto id(String id) => this(id: id);

  @override
  LedgerRowDto type(LedgerRowDtoTypeEnum type) => this(type: type);

  @override
  LedgerRowDto amountBs(String amountBs) => this(amountBs: amountBs);

  @override
  LedgerRowDto runningBs(String runningBs) => this(runningBs: runningBs);

  @override
  LedgerRowDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  LedgerRowDto jobId(String? jobId) => this(jobId: jobId);

  @override
  LedgerRowDto paymentId(String? paymentId) => this(paymentId: paymentId);

  @override
  LedgerRowDto correctsEntryId(String? correctsEntryId) =>
      this(correctsEntryId: correctsEntryId);

  @override
  LedgerRowDto reason(String? reason) => this(reason: reason);

  @override
  LedgerRowDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LedgerRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LedgerRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  LedgerRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? amountBs = const $CopyWithPlaceholder(),
    Object? runningBs = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? paymentId = const $CopyWithPlaceholder(),
    Object? correctsEntryId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return LedgerRowDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as LedgerRowDtoTypeEnum,
      amountBs: amountBs == const $CopyWithPlaceholder()
          ? _value.amountBs
          // ignore: cast_nullable_to_non_nullable
          : amountBs as String,
      runningBs: runningBs == const $CopyWithPlaceholder()
          ? _value.runningBs
          // ignore: cast_nullable_to_non_nullable
          : runningBs as String,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String,
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
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $LedgerRowDtoCopyWith on LedgerRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfLedgerRowDto.copyWith(...)` or like so:`instanceOfLedgerRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LedgerRowDtoCWProxy get copyWith => _$LedgerRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedgerRowDto _$LedgerRowDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('LedgerRowDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'type',
      'amountBs',
      'runningBs',
      'paymentReference',
      'jobId',
      'paymentId',
      'correctsEntryId',
      'reason',
      'createdAt',
    ],
  );
  final val = LedgerRowDto(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$LedgerRowDtoTypeEnumEnumMap, v),
    ),
    amountBs: $checkedConvert('amountBs', (v) => v as String),
    runningBs: $checkedConvert('runningBs', (v) => v as String),
    paymentReference: $checkedConvert('paymentReference', (v) => v as String),
    jobId: $checkedConvert('jobId', (v) => v as String?),
    paymentId: $checkedConvert('paymentId', (v) => v as String?),
    correctsEntryId: $checkedConvert('correctsEntryId', (v) => v as String?),
    reason: $checkedConvert('reason', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$LedgerRowDtoToJson(LedgerRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$LedgerRowDtoTypeEnumEnumMap[instance.type]!,
      'amountBs': instance.amountBs,
      'runningBs': instance.runningBs,
      'paymentReference': instance.paymentReference,
      'jobId': instance.jobId,
      'paymentId': instance.paymentId,
      'correctsEntryId': instance.correctsEntryId,
      'reason': instance.reason,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$LedgerRowDtoTypeEnumEnumMap = {
  LedgerRowDtoTypeEnum.comision: 'comision',
  LedgerRowDtoTypeEnum.pago: 'pago',
  LedgerRowDtoTypeEnum.ajuste: 'ajuste',
};

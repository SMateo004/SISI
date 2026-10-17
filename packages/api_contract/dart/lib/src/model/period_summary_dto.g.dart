// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_summary_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PeriodSummaryDtoCWProxy {
  PeriodSummaryDto id(String id);

  PeriodSummaryDto startAt(DateTime startAt);

  PeriodSummaryDto endAt(DateTime endAt);

  PeriodSummaryDto dueAt(DateTime dueAt);

  PeriodSummaryDto status(PeriodSummaryDtoStatusEnum status);

  PeriodSummaryDto grossBs(String grossBs);

  PeriodSummaryDto commissionBs(String commissionBs);

  PeriodSummaryDto netBs(String netBs);

  PeriodSummaryDto balanceBs(String balanceBs);

  PeriodSummaryDto paymentReference(String paymentReference);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PeriodSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PeriodSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PeriodSummaryDto call({
    String id,
    DateTime startAt,
    DateTime endAt,
    DateTime dueAt,
    PeriodSummaryDtoStatusEnum status,
    String grossBs,
    String commissionBs,
    String netBs,
    String balanceBs,
    String paymentReference,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPeriodSummaryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPeriodSummaryDto.copyWith.fieldName(...)`
class _$PeriodSummaryDtoCWProxyImpl implements _$PeriodSummaryDtoCWProxy {
  const _$PeriodSummaryDtoCWProxyImpl(this._value);

  final PeriodSummaryDto _value;

  @override
  PeriodSummaryDto id(String id) => this(id: id);

  @override
  PeriodSummaryDto startAt(DateTime startAt) => this(startAt: startAt);

  @override
  PeriodSummaryDto endAt(DateTime endAt) => this(endAt: endAt);

  @override
  PeriodSummaryDto dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  PeriodSummaryDto status(PeriodSummaryDtoStatusEnum status) =>
      this(status: status);

  @override
  PeriodSummaryDto grossBs(String grossBs) => this(grossBs: grossBs);

  @override
  PeriodSummaryDto commissionBs(String commissionBs) =>
      this(commissionBs: commissionBs);

  @override
  PeriodSummaryDto netBs(String netBs) => this(netBs: netBs);

  @override
  PeriodSummaryDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  PeriodSummaryDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PeriodSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PeriodSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PeriodSummaryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? endAt = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? grossBs = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
    Object? netBs = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
  }) {
    return PeriodSummaryDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      startAt: startAt == const $CopyWithPlaceholder()
          ? _value.startAt
          // ignore: cast_nullable_to_non_nullable
          : startAt as DateTime,
      endAt: endAt == const $CopyWithPlaceholder()
          ? _value.endAt
          // ignore: cast_nullable_to_non_nullable
          : endAt as DateTime,
      dueAt: dueAt == const $CopyWithPlaceholder()
          ? _value.dueAt
          // ignore: cast_nullable_to_non_nullable
          : dueAt as DateTime,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as PeriodSummaryDtoStatusEnum,
      grossBs: grossBs == const $CopyWithPlaceholder()
          ? _value.grossBs
          // ignore: cast_nullable_to_non_nullable
          : grossBs as String,
      commissionBs: commissionBs == const $CopyWithPlaceholder()
          ? _value.commissionBs
          // ignore: cast_nullable_to_non_nullable
          : commissionBs as String,
      netBs: netBs == const $CopyWithPlaceholder()
          ? _value.netBs
          // ignore: cast_nullable_to_non_nullable
          : netBs as String,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String,
    );
  }
}

extension $PeriodSummaryDtoCopyWith on PeriodSummaryDto {
  /// Returns a callable class that can be used as follows: `instanceOfPeriodSummaryDto.copyWith(...)` or like so:`instanceOfPeriodSummaryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PeriodSummaryDtoCWProxy get copyWith => _$PeriodSummaryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeriodSummaryDto _$PeriodSummaryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PeriodSummaryDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'startAt',
          'endAt',
          'dueAt',
          'status',
          'grossBs',
          'commissionBs',
          'netBs',
          'balanceBs',
          'paymentReference',
        ],
      );
      final val = PeriodSummaryDto(
        id: $checkedConvert('id', (v) => v as String),
        startAt: $checkedConvert('startAt', (v) => DateTime.parse(v as String)),
        endAt: $checkedConvert('endAt', (v) => DateTime.parse(v as String)),
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$PeriodSummaryDtoStatusEnumEnumMap, v),
        ),
        grossBs: $checkedConvert('grossBs', (v) => v as String),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String),
        netBs: $checkedConvert('netBs', (v) => v as String),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String,
        ),
      );
      return val;
    });

Map<String, dynamic> _$PeriodSummaryDtoToJson(PeriodSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'dueAt': instance.dueAt.toIso8601String(),
      'status': _$PeriodSummaryDtoStatusEnumEnumMap[instance.status]!,
      'grossBs': instance.grossBs,
      'commissionBs': instance.commissionBs,
      'netBs': instance.netBs,
      'balanceBs': instance.balanceBs,
      'paymentReference': instance.paymentReference,
    };

const _$PeriodSummaryDtoStatusEnumEnumMap = {
  PeriodSummaryDtoStatusEnum.abierto: 'abierto',
  PeriodSummaryDtoStatusEnum.cerradoPendiente: 'cerrado_pendiente',
  PeriodSummaryDtoStatusEnum.pagado: 'pagado',
  PeriodSummaryDtoStatusEnum.vencido: 'vencido',
};

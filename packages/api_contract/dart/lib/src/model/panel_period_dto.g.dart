// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_period_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PanelPeriodDtoCWProxy {
  PanelPeriodDto id(String id);

  PanelPeriodDto workerId(String workerId);

  PanelPeriodDto workerName(String? workerName);

  PanelPeriodDto workerPhone(String workerPhone);

  PanelPeriodDto status(PanelPeriodDtoStatusEnum status);

  PanelPeriodDto paymentReference(String paymentReference);

  PanelPeriodDto startAt(DateTime startAt);

  PanelPeriodDto endAt(DateTime endAt);

  PanelPeriodDto dueAt(DateTime dueAt);

  PanelPeriodDto grossBs(String grossBs);

  PanelPeriodDto commissionBs(String commissionBs);

  PanelPeriodDto balanceBs(String balanceBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PanelPeriodDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PanelPeriodDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PanelPeriodDto call({
    String id,
    String workerId,
    String? workerName,
    String workerPhone,
    PanelPeriodDtoStatusEnum status,
    String paymentReference,
    DateTime startAt,
    DateTime endAt,
    DateTime dueAt,
    String grossBs,
    String commissionBs,
    String balanceBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPanelPeriodDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPanelPeriodDto.copyWith.fieldName(...)`
class _$PanelPeriodDtoCWProxyImpl implements _$PanelPeriodDtoCWProxy {
  const _$PanelPeriodDtoCWProxyImpl(this._value);

  final PanelPeriodDto _value;

  @override
  PanelPeriodDto id(String id) => this(id: id);

  @override
  PanelPeriodDto workerId(String workerId) => this(workerId: workerId);

  @override
  PanelPeriodDto workerName(String? workerName) => this(workerName: workerName);

  @override
  PanelPeriodDto workerPhone(String workerPhone) =>
      this(workerPhone: workerPhone);

  @override
  PanelPeriodDto status(PanelPeriodDtoStatusEnum status) =>
      this(status: status);

  @override
  PanelPeriodDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  PanelPeriodDto startAt(DateTime startAt) => this(startAt: startAt);

  @override
  PanelPeriodDto endAt(DateTime endAt) => this(endAt: endAt);

  @override
  PanelPeriodDto dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  PanelPeriodDto grossBs(String grossBs) => this(grossBs: grossBs);

  @override
  PanelPeriodDto commissionBs(String commissionBs) =>
      this(commissionBs: commissionBs);

  @override
  PanelPeriodDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PanelPeriodDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PanelPeriodDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PanelPeriodDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? workerId = const $CopyWithPlaceholder(),
    Object? workerName = const $CopyWithPlaceholder(),
    Object? workerPhone = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? endAt = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? grossBs = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
  }) {
    return PanelPeriodDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      workerName: workerName == const $CopyWithPlaceholder()
          ? _value.workerName
          // ignore: cast_nullable_to_non_nullable
          : workerName as String?,
      workerPhone: workerPhone == const $CopyWithPlaceholder()
          ? _value.workerPhone
          // ignore: cast_nullable_to_non_nullable
          : workerPhone as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as PanelPeriodDtoStatusEnum,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String,
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
      grossBs: grossBs == const $CopyWithPlaceholder()
          ? _value.grossBs
          // ignore: cast_nullable_to_non_nullable
          : grossBs as String,
      commissionBs: commissionBs == const $CopyWithPlaceholder()
          ? _value.commissionBs
          // ignore: cast_nullable_to_non_nullable
          : commissionBs as String,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
    );
  }
}

extension $PanelPeriodDtoCopyWith on PanelPeriodDto {
  /// Returns a callable class that can be used as follows: `instanceOfPanelPeriodDto.copyWith(...)` or like so:`instanceOfPanelPeriodDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PanelPeriodDtoCWProxy get copyWith => _$PanelPeriodDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelPeriodDto _$PanelPeriodDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PanelPeriodDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'workerId',
          'workerName',
          'workerPhone',
          'status',
          'paymentReference',
          'startAt',
          'endAt',
          'dueAt',
          'grossBs',
          'commissionBs',
          'balanceBs',
        ],
      );
      final val = PanelPeriodDto(
        id: $checkedConvert('id', (v) => v as String),
        workerId: $checkedConvert('workerId', (v) => v as String),
        workerName: $checkedConvert('workerName', (v) => v as String?),
        workerPhone: $checkedConvert('workerPhone', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$PanelPeriodDtoStatusEnumEnumMap, v),
        ),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String,
        ),
        startAt: $checkedConvert('startAt', (v) => DateTime.parse(v as String)),
        endAt: $checkedConvert('endAt', (v) => DateTime.parse(v as String)),
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        grossBs: $checkedConvert('grossBs', (v) => v as String),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PanelPeriodDtoToJson(PanelPeriodDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workerId': instance.workerId,
      'workerName': instance.workerName,
      'workerPhone': instance.workerPhone,
      'status': _$PanelPeriodDtoStatusEnumEnumMap[instance.status]!,
      'paymentReference': instance.paymentReference,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'dueAt': instance.dueAt.toIso8601String(),
      'grossBs': instance.grossBs,
      'commissionBs': instance.commissionBs,
      'balanceBs': instance.balanceBs,
    };

const _$PanelPeriodDtoStatusEnumEnumMap = {
  PanelPeriodDtoStatusEnum.abierto: 'abierto',
  PanelPeriodDtoStatusEnum.cerradoPendiente: 'cerrado_pendiente',
  PanelPeriodDtoStatusEnum.pagado: 'pagado',
  PanelPeriodDtoStatusEnum.vencido: 'vencido',
};

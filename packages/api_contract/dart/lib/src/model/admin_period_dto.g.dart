// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_period_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminPeriodDtoCWProxy {
  AdminPeriodDto id(String id);

  AdminPeriodDto startAt(DateTime startAt);

  AdminPeriodDto endAt(DateTime endAt);

  AdminPeriodDto dueAt(DateTime dueAt);

  AdminPeriodDto status(AdminPeriodDtoStatusEnum status);

  AdminPeriodDto grossBs(String grossBs);

  AdminPeriodDto commissionBs(String commissionBs);

  AdminPeriodDto balanceBs(String balanceBs);

  AdminPeriodDto paymentReference(String paymentReference);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPeriodDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPeriodDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPeriodDto call({
    String id,
    DateTime startAt,
    DateTime endAt,
    DateTime dueAt,
    AdminPeriodDtoStatusEnum status,
    String grossBs,
    String commissionBs,
    String balanceBs,
    String paymentReference,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminPeriodDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminPeriodDto.copyWith.fieldName(...)`
class _$AdminPeriodDtoCWProxyImpl implements _$AdminPeriodDtoCWProxy {
  const _$AdminPeriodDtoCWProxyImpl(this._value);

  final AdminPeriodDto _value;

  @override
  AdminPeriodDto id(String id) => this(id: id);

  @override
  AdminPeriodDto startAt(DateTime startAt) => this(startAt: startAt);

  @override
  AdminPeriodDto endAt(DateTime endAt) => this(endAt: endAt);

  @override
  AdminPeriodDto dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  AdminPeriodDto status(AdminPeriodDtoStatusEnum status) =>
      this(status: status);

  @override
  AdminPeriodDto grossBs(String grossBs) => this(grossBs: grossBs);

  @override
  AdminPeriodDto commissionBs(String commissionBs) =>
      this(commissionBs: commissionBs);

  @override
  AdminPeriodDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  AdminPeriodDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPeriodDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPeriodDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPeriodDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? endAt = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? grossBs = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
  }) {
    return AdminPeriodDto(
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
          : status as AdminPeriodDtoStatusEnum,
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
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String,
    );
  }
}

extension $AdminPeriodDtoCopyWith on AdminPeriodDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminPeriodDto.copyWith(...)` or like so:`instanceOfAdminPeriodDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminPeriodDtoCWProxy get copyWith => _$AdminPeriodDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminPeriodDto _$AdminPeriodDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminPeriodDto', json, ($checkedConvert) {
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
          'balanceBs',
          'paymentReference',
        ],
      );
      final val = AdminPeriodDto(
        id: $checkedConvert('id', (v) => v as String),
        startAt: $checkedConvert('startAt', (v) => DateTime.parse(v as String)),
        endAt: $checkedConvert('endAt', (v) => DateTime.parse(v as String)),
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$AdminPeriodDtoStatusEnumEnumMap, v),
        ),
        grossBs: $checkedConvert('grossBs', (v) => v as String),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String,
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminPeriodDtoToJson(AdminPeriodDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'dueAt': instance.dueAt.toIso8601String(),
      'status': _$AdminPeriodDtoStatusEnumEnumMap[instance.status]!,
      'grossBs': instance.grossBs,
      'commissionBs': instance.commissionBs,
      'balanceBs': instance.balanceBs,
      'paymentReference': instance.paymentReference,
    };

const _$AdminPeriodDtoStatusEnumEnumMap = {
  AdminPeriodDtoStatusEnum.abierto: 'abierto',
  AdminPeriodDtoStatusEnum.cerradoPendiente: 'cerrado_pendiente',
  AdminPeriodDtoStatusEnum.pagado: 'pagado',
  AdminPeriodDtoStatusEnum.vencido: 'vencido',
};

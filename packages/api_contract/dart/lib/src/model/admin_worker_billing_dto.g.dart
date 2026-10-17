// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_worker_billing_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminWorkerBillingDtoCWProxy {
  AdminWorkerBillingDto workerId(String workerId);

  AdminWorkerBillingDto balanceBs(String balanceBs);

  AdminWorkerBillingDto periods(List<AdminPeriodDto> periods);

  AdminWorkerBillingDto entries(List<AdminLedgerEntryDto> entries);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminWorkerBillingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminWorkerBillingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminWorkerBillingDto call({
    String workerId,
    String balanceBs,
    List<AdminPeriodDto> periods,
    List<AdminLedgerEntryDto> entries,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminWorkerBillingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminWorkerBillingDto.copyWith.fieldName(...)`
class _$AdminWorkerBillingDtoCWProxyImpl
    implements _$AdminWorkerBillingDtoCWProxy {
  const _$AdminWorkerBillingDtoCWProxyImpl(this._value);

  final AdminWorkerBillingDto _value;

  @override
  AdminWorkerBillingDto workerId(String workerId) => this(workerId: workerId);

  @override
  AdminWorkerBillingDto balanceBs(String balanceBs) =>
      this(balanceBs: balanceBs);

  @override
  AdminWorkerBillingDto periods(List<AdminPeriodDto> periods) =>
      this(periods: periods);

  @override
  AdminWorkerBillingDto entries(List<AdminLedgerEntryDto> entries) =>
      this(entries: entries);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminWorkerBillingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminWorkerBillingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminWorkerBillingDto call({
    Object? workerId = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? periods = const $CopyWithPlaceholder(),
    Object? entries = const $CopyWithPlaceholder(),
  }) {
    return AdminWorkerBillingDto(
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
      periods: periods == const $CopyWithPlaceholder()
          ? _value.periods
          // ignore: cast_nullable_to_non_nullable
          : periods as List<AdminPeriodDto>,
      entries: entries == const $CopyWithPlaceholder()
          ? _value.entries
          // ignore: cast_nullable_to_non_nullable
          : entries as List<AdminLedgerEntryDto>,
    );
  }
}

extension $AdminWorkerBillingDtoCopyWith on AdminWorkerBillingDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminWorkerBillingDto.copyWith(...)` or like so:`instanceOfAdminWorkerBillingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminWorkerBillingDtoCWProxy get copyWith =>
      _$AdminWorkerBillingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminWorkerBillingDto _$AdminWorkerBillingDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminWorkerBillingDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['workerId', 'balanceBs', 'periods', 'entries'],
  );
  final val = AdminWorkerBillingDto(
    workerId: $checkedConvert('workerId', (v) => v as String),
    balanceBs: $checkedConvert('balanceBs', (v) => v as String),
    periods: $checkedConvert(
      'periods',
      (v) => (v as List<dynamic>)
          .map((e) => AdminPeriodDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    entries: $checkedConvert(
      'entries',
      (v) => (v as List<dynamic>)
          .map((e) => AdminLedgerEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$AdminWorkerBillingDtoToJson(
  AdminWorkerBillingDto instance,
) => <String, dynamic>{
  'workerId': instance.workerId,
  'balanceBs': instance.balanceBs,
  'periods': instance.periods.map((e) => e.toJson()).toList(),
  'entries': instance.entries.map((e) => e.toJson()).toList(),
};

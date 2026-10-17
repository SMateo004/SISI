// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_summary_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EarningsSummaryDtoCWProxy {
  EarningsSummaryDto currentPeriod(CurrentPeriodDto currentPeriod);

  EarningsSummaryDto balanceBs(String balanceBs);

  EarningsSummaryDto overdueOrPendingBs(String overdueOrPendingBs);

  EarningsSummaryDto nextDueAt(DateTime? nextDueAt);

  EarningsSummaryDto overdue(bool overdue);

  EarningsSummaryDto blocked(bool blocked);

  EarningsSummaryDto debtCap(DebtCapStateDto debtCap);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EarningsSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EarningsSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  EarningsSummaryDto call({
    CurrentPeriodDto currentPeriod,
    String balanceBs,
    String overdueOrPendingBs,
    DateTime? nextDueAt,
    bool overdue,
    bool blocked,
    DebtCapStateDto debtCap,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEarningsSummaryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEarningsSummaryDto.copyWith.fieldName(...)`
class _$EarningsSummaryDtoCWProxyImpl implements _$EarningsSummaryDtoCWProxy {
  const _$EarningsSummaryDtoCWProxyImpl(this._value);

  final EarningsSummaryDto _value;

  @override
  EarningsSummaryDto currentPeriod(CurrentPeriodDto currentPeriod) =>
      this(currentPeriod: currentPeriod);

  @override
  EarningsSummaryDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  EarningsSummaryDto overdueOrPendingBs(String overdueOrPendingBs) =>
      this(overdueOrPendingBs: overdueOrPendingBs);

  @override
  EarningsSummaryDto nextDueAt(DateTime? nextDueAt) =>
      this(nextDueAt: nextDueAt);

  @override
  EarningsSummaryDto overdue(bool overdue) => this(overdue: overdue);

  @override
  EarningsSummaryDto blocked(bool blocked) => this(blocked: blocked);

  @override
  EarningsSummaryDto debtCap(DebtCapStateDto debtCap) => this(debtCap: debtCap);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EarningsSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EarningsSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  EarningsSummaryDto call({
    Object? currentPeriod = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? overdueOrPendingBs = const $CopyWithPlaceholder(),
    Object? nextDueAt = const $CopyWithPlaceholder(),
    Object? overdue = const $CopyWithPlaceholder(),
    Object? blocked = const $CopyWithPlaceholder(),
    Object? debtCap = const $CopyWithPlaceholder(),
  }) {
    return EarningsSummaryDto(
      currentPeriod: currentPeriod == const $CopyWithPlaceholder()
          ? _value.currentPeriod
          // ignore: cast_nullable_to_non_nullable
          : currentPeriod as CurrentPeriodDto,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
      overdueOrPendingBs: overdueOrPendingBs == const $CopyWithPlaceholder()
          ? _value.overdueOrPendingBs
          // ignore: cast_nullable_to_non_nullable
          : overdueOrPendingBs as String,
      nextDueAt: nextDueAt == const $CopyWithPlaceholder()
          ? _value.nextDueAt
          // ignore: cast_nullable_to_non_nullable
          : nextDueAt as DateTime?,
      overdue: overdue == const $CopyWithPlaceholder()
          ? _value.overdue
          // ignore: cast_nullable_to_non_nullable
          : overdue as bool,
      blocked: blocked == const $CopyWithPlaceholder()
          ? _value.blocked
          // ignore: cast_nullable_to_non_nullable
          : blocked as bool,
      debtCap: debtCap == const $CopyWithPlaceholder()
          ? _value.debtCap
          // ignore: cast_nullable_to_non_nullable
          : debtCap as DebtCapStateDto,
    );
  }
}

extension $EarningsSummaryDtoCopyWith on EarningsSummaryDto {
  /// Returns a callable class that can be used as follows: `instanceOfEarningsSummaryDto.copyWith(...)` or like so:`instanceOfEarningsSummaryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EarningsSummaryDtoCWProxy get copyWith =>
      _$EarningsSummaryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EarningsSummaryDto _$EarningsSummaryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EarningsSummaryDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'currentPeriod',
          'balanceBs',
          'overdueOrPendingBs',
          'nextDueAt',
          'overdue',
          'blocked',
          'debtCap',
        ],
      );
      final val = EarningsSummaryDto(
        currentPeriod: $checkedConvert(
          'currentPeriod',
          (v) => CurrentPeriodDto.fromJson(v as Map<String, dynamic>),
        ),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
        overdueOrPendingBs: $checkedConvert(
          'overdueOrPendingBs',
          (v) => v as String,
        ),
        nextDueAt: $checkedConvert(
          'nextDueAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        overdue: $checkedConvert('overdue', (v) => v as bool),
        blocked: $checkedConvert('blocked', (v) => v as bool),
        debtCap: $checkedConvert(
          'debtCap',
          (v) => DebtCapStateDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EarningsSummaryDtoToJson(EarningsSummaryDto instance) =>
    <String, dynamic>{
      'currentPeriod': instance.currentPeriod.toJson(),
      'balanceBs': instance.balanceBs,
      'overdueOrPendingBs': instance.overdueOrPendingBs,
      'nextDueAt': instance.nextDueAt?.toIso8601String(),
      'overdue': instance.overdue,
      'blocked': instance.blocked,
      'debtCap': instance.debtCap.toJson(),
    };

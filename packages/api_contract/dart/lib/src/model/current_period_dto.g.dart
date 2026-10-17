// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_period_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CurrentPeriodDtoCWProxy {
  CurrentPeriodDto id(String? id);

  CurrentPeriodDto startAt(DateTime startAt);

  CurrentPeriodDto endAt(DateTime endAt);

  CurrentPeriodDto dueAt(DateTime dueAt);

  CurrentPeriodDto grossBs(String grossBs);

  CurrentPeriodDto commissionBs(String commissionBs);

  CurrentPeriodDto netBs(String netBs);

  CurrentPeriodDto paymentReference(String? paymentReference);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CurrentPeriodDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CurrentPeriodDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CurrentPeriodDto call({
    String? id,
    DateTime startAt,
    DateTime endAt,
    DateTime dueAt,
    String grossBs,
    String commissionBs,
    String netBs,
    String? paymentReference,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCurrentPeriodDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCurrentPeriodDto.copyWith.fieldName(...)`
class _$CurrentPeriodDtoCWProxyImpl implements _$CurrentPeriodDtoCWProxy {
  const _$CurrentPeriodDtoCWProxyImpl(this._value);

  final CurrentPeriodDto _value;

  @override
  CurrentPeriodDto id(String? id) => this(id: id);

  @override
  CurrentPeriodDto startAt(DateTime startAt) => this(startAt: startAt);

  @override
  CurrentPeriodDto endAt(DateTime endAt) => this(endAt: endAt);

  @override
  CurrentPeriodDto dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  CurrentPeriodDto grossBs(String grossBs) => this(grossBs: grossBs);

  @override
  CurrentPeriodDto commissionBs(String commissionBs) =>
      this(commissionBs: commissionBs);

  @override
  CurrentPeriodDto netBs(String netBs) => this(netBs: netBs);

  @override
  CurrentPeriodDto paymentReference(String? paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CurrentPeriodDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CurrentPeriodDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CurrentPeriodDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? endAt = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? grossBs = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
    Object? netBs = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
  }) {
    return CurrentPeriodDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
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
      netBs: netBs == const $CopyWithPlaceholder()
          ? _value.netBs
          // ignore: cast_nullable_to_non_nullable
          : netBs as String,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String?,
    );
  }
}

extension $CurrentPeriodDtoCopyWith on CurrentPeriodDto {
  /// Returns a callable class that can be used as follows: `instanceOfCurrentPeriodDto.copyWith(...)` or like so:`instanceOfCurrentPeriodDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CurrentPeriodDtoCWProxy get copyWith => _$CurrentPeriodDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentPeriodDto _$CurrentPeriodDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrentPeriodDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'startAt',
          'endAt',
          'dueAt',
          'grossBs',
          'commissionBs',
          'netBs',
          'paymentReference',
        ],
      );
      final val = CurrentPeriodDto(
        id: $checkedConvert('id', (v) => v as String?),
        startAt: $checkedConvert('startAt', (v) => DateTime.parse(v as String)),
        endAt: $checkedConvert('endAt', (v) => DateTime.parse(v as String)),
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        grossBs: $checkedConvert('grossBs', (v) => v as String),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String),
        netBs: $checkedConvert('netBs', (v) => v as String),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$CurrentPeriodDtoToJson(CurrentPeriodDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'dueAt': instance.dueAt.toIso8601String(),
      'grossBs': instance.grossBs,
      'commissionBs': instance.commissionBs,
      'netBs': instance.netBs,
      'paymentReference': instance.paymentReference,
    };

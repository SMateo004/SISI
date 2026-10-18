// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PeriodRowDtoCWProxy {
  PeriodRowDto id(String id);

  PeriodRowDto status(String status);

  PeriodRowDto paymentReference(String paymentReference);

  PeriodRowDto startAt(DateTime startAt);

  PeriodRowDto dueAt(DateTime dueAt);

  PeriodRowDto commissionBs(String commissionBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PeriodRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PeriodRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PeriodRowDto call({
    String id,
    String status,
    String paymentReference,
    DateTime startAt,
    DateTime dueAt,
    String commissionBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPeriodRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPeriodRowDto.copyWith.fieldName(...)`
class _$PeriodRowDtoCWProxyImpl implements _$PeriodRowDtoCWProxy {
  const _$PeriodRowDtoCWProxyImpl(this._value);

  final PeriodRowDto _value;

  @override
  PeriodRowDto id(String id) => this(id: id);

  @override
  PeriodRowDto status(String status) => this(status: status);

  @override
  PeriodRowDto paymentReference(String paymentReference) =>
      this(paymentReference: paymentReference);

  @override
  PeriodRowDto startAt(DateTime startAt) => this(startAt: startAt);

  @override
  PeriodRowDto dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  PeriodRowDto commissionBs(String commissionBs) =>
      this(commissionBs: commissionBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PeriodRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PeriodRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PeriodRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? paymentReference = const $CopyWithPlaceholder(),
    Object? startAt = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
  }) {
    return PeriodRowDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      paymentReference: paymentReference == const $CopyWithPlaceholder()
          ? _value.paymentReference
          // ignore: cast_nullable_to_non_nullable
          : paymentReference as String,
      startAt: startAt == const $CopyWithPlaceholder()
          ? _value.startAt
          // ignore: cast_nullable_to_non_nullable
          : startAt as DateTime,
      dueAt: dueAt == const $CopyWithPlaceholder()
          ? _value.dueAt
          // ignore: cast_nullable_to_non_nullable
          : dueAt as DateTime,
      commissionBs: commissionBs == const $CopyWithPlaceholder()
          ? _value.commissionBs
          // ignore: cast_nullable_to_non_nullable
          : commissionBs as String,
    );
  }
}

extension $PeriodRowDtoCopyWith on PeriodRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfPeriodRowDto.copyWith(...)` or like so:`instanceOfPeriodRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PeriodRowDtoCWProxy get copyWith => _$PeriodRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeriodRowDto _$PeriodRowDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PeriodRowDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'status',
          'paymentReference',
          'startAt',
          'dueAt',
          'commissionBs',
        ],
      );
      final val = PeriodRowDto(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        paymentReference: $checkedConvert(
          'paymentReference',
          (v) => v as String,
        ),
        startAt: $checkedConvert('startAt', (v) => DateTime.parse(v as String)),
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PeriodRowDtoToJson(PeriodRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'paymentReference': instance.paymentReference,
      'startAt': instance.startAt.toIso8601String(),
      'dueAt': instance.dueAt.toIso8601String(),
      'commissionBs': instance.commissionBs,
    };

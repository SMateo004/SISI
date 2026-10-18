// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_count_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancellationCountDtoCWProxy {
  CancellationCountDto reason(String reason);

  CancellationCountDto count(num count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancellationCountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancellationCountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CancellationCountDto call({String reason, num count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancellationCountDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancellationCountDto.copyWith.fieldName(...)`
class _$CancellationCountDtoCWProxyImpl
    implements _$CancellationCountDtoCWProxy {
  const _$CancellationCountDtoCWProxyImpl(this._value);

  final CancellationCountDto _value;

  @override
  CancellationCountDto reason(String reason) => this(reason: reason);

  @override
  CancellationCountDto count(num count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancellationCountDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancellationCountDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CancellationCountDto call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
  }) {
    return CancellationCountDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as num,
    );
  }
}

extension $CancellationCountDtoCopyWith on CancellationCountDto {
  /// Returns a callable class that can be used as follows: `instanceOfCancellationCountDto.copyWith(...)` or like so:`instanceOfCancellationCountDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancellationCountDtoCWProxy get copyWith =>
      _$CancellationCountDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancellationCountDto _$CancellationCountDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CancellationCountDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['reason', 'count']);
  final val = CancellationCountDto(
    reason: $checkedConvert('reason', (v) => v as String),
    count: $checkedConvert('count', (v) => v as num),
  );
  return val;
});

Map<String, dynamic> _$CancellationCountDtoToJson(
  CancellationCountDto instance,
) => <String, dynamic>{'reason': instance.reason, 'count': instance.count};

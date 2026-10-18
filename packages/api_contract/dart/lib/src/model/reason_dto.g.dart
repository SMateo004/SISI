// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reason_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReasonDtoCWProxy {
  ReasonDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReasonDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReasonDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReasonDto call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReasonDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReasonDto.copyWith.fieldName(...)`
class _$ReasonDtoCWProxyImpl implements _$ReasonDtoCWProxy {
  const _$ReasonDtoCWProxyImpl(this._value);

  final ReasonDto _value;

  @override
  ReasonDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReasonDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReasonDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReasonDto call({Object? reason = const $CopyWithPlaceholder()}) {
    return ReasonDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $ReasonDtoCopyWith on ReasonDto {
  /// Returns a callable class that can be used as follows: `instanceOfReasonDto.copyWith(...)` or like so:`instanceOfReasonDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReasonDtoCWProxy get copyWith => _$ReasonDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReasonDto _$ReasonDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReasonDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = ReasonDto(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ReasonDtoToJson(ReasonDto instance) => <String, dynamic>{
  'reason': instance.reason,
};

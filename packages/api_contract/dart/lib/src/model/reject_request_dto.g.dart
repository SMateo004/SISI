// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RejectRequestDtoCWProxy {
  RejectRequestDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectRequestDto call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRejectRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRejectRequestDto.copyWith.fieldName(...)`
class _$RejectRequestDtoCWProxyImpl implements _$RejectRequestDtoCWProxy {
  const _$RejectRequestDtoCWProxyImpl(this._value);

  final RejectRequestDto _value;

  @override
  RejectRequestDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RejectRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RejectRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RejectRequestDto call({Object? reason = const $CopyWithPlaceholder()}) {
    return RejectRequestDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $RejectRequestDtoCopyWith on RejectRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfRejectRequestDto.copyWith(...)` or like so:`instanceOfRejectRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RejectRequestDtoCWProxy get copyWith => _$RejectRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RejectRequestDto _$RejectRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RejectRequestDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = RejectRequestDto(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RejectRequestDtoToJson(RejectRequestDto instance) =>
    <String, dynamic>{'reason': instance.reason};

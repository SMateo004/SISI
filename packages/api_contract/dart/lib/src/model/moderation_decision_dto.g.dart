// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_decision_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationDecisionDtoCWProxy {
  ModerationDecisionDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationDecisionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationDecisionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationDecisionDto call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationDecisionDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationDecisionDto.copyWith.fieldName(...)`
class _$ModerationDecisionDtoCWProxyImpl
    implements _$ModerationDecisionDtoCWProxy {
  const _$ModerationDecisionDtoCWProxyImpl(this._value);

  final ModerationDecisionDto _value;

  @override
  ModerationDecisionDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationDecisionDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationDecisionDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationDecisionDto call({Object? reason = const $CopyWithPlaceholder()}) {
    return ModerationDecisionDto(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $ModerationDecisionDtoCopyWith on ModerationDecisionDto {
  /// Returns a callable class that can be used as follows: `instanceOfModerationDecisionDto.copyWith(...)` or like so:`instanceOfModerationDecisionDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationDecisionDtoCWProxy get copyWith =>
      _$ModerationDecisionDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationDecisionDto _$ModerationDecisionDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ModerationDecisionDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['reason']);
  final val = ModerationDecisionDto(
    reason: $checkedConvert('reason', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$ModerationDecisionDtoToJson(
  ModerationDecisionDto instance,
) => <String, dynamic>{'reason': instance.reason};

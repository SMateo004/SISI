// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_dispute_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResolveDisputeDtoCWProxy {
  ResolveDisputeDto decision(ResolveDisputeDtoDecisionEnum decision);

  ResolveDisputeDto note(String note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResolveDisputeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResolveDisputeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResolveDisputeDto call({ResolveDisputeDtoDecisionEnum decision, String note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResolveDisputeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResolveDisputeDto.copyWith.fieldName(...)`
class _$ResolveDisputeDtoCWProxyImpl implements _$ResolveDisputeDtoCWProxy {
  const _$ResolveDisputeDtoCWProxyImpl(this._value);

  final ResolveDisputeDto _value;

  @override
  ResolveDisputeDto decision(ResolveDisputeDtoDecisionEnum decision) =>
      this(decision: decision);

  @override
  ResolveDisputeDto note(String note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResolveDisputeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResolveDisputeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ResolveDisputeDto call({
    Object? decision = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return ResolveDisputeDto(
      decision: decision == const $CopyWithPlaceholder()
          ? _value.decision
          // ignore: cast_nullable_to_non_nullable
          : decision as ResolveDisputeDtoDecisionEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
    );
  }
}

extension $ResolveDisputeDtoCopyWith on ResolveDisputeDto {
  /// Returns a callable class that can be used as follows: `instanceOfResolveDisputeDto.copyWith(...)` or like so:`instanceOfResolveDisputeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResolveDisputeDtoCWProxy get copyWith =>
      _$ResolveDisputeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveDisputeDto _$ResolveDisputeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ResolveDisputeDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['decision', 'note']);
      final val = ResolveDisputeDto(
        decision: $checkedConvert(
          'decision',
          (v) => $enumDecode(_$ResolveDisputeDtoDecisionEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ResolveDisputeDtoToJson(ResolveDisputeDto instance) =>
    <String, dynamic>{
      'decision': _$ResolveDisputeDtoDecisionEnumEnumMap[instance.decision]!,
      'note': instance.note,
    };

const _$ResolveDisputeDtoDecisionEnumEnumMap = {
  ResolveDisputeDtoDecisionEnum.confirm: 'confirm',
  ResolveDisputeDtoDecisionEnum.cancel: 'cancel',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_test_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ModerationTestResultDtoCWProxy {
  ModerationTestResultDto held(bool held);

  ModerationTestResultDto matches(List<ModerationMatchDto> matches);

  ModerationTestResultDto timedOut(bool timedOut);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationTestResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationTestResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationTestResultDto call({
    bool held,
    List<ModerationMatchDto> matches,
    bool timedOut,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfModerationTestResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfModerationTestResultDto.copyWith.fieldName(...)`
class _$ModerationTestResultDtoCWProxyImpl
    implements _$ModerationTestResultDtoCWProxy {
  const _$ModerationTestResultDtoCWProxyImpl(this._value);

  final ModerationTestResultDto _value;

  @override
  ModerationTestResultDto held(bool held) => this(held: held);

  @override
  ModerationTestResultDto matches(List<ModerationMatchDto> matches) =>
      this(matches: matches);

  @override
  ModerationTestResultDto timedOut(bool timedOut) => this(timedOut: timedOut);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ModerationTestResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ModerationTestResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ModerationTestResultDto call({
    Object? held = const $CopyWithPlaceholder(),
    Object? matches = const $CopyWithPlaceholder(),
    Object? timedOut = const $CopyWithPlaceholder(),
  }) {
    return ModerationTestResultDto(
      held: held == const $CopyWithPlaceholder()
          ? _value.held
          // ignore: cast_nullable_to_non_nullable
          : held as bool,
      matches: matches == const $CopyWithPlaceholder()
          ? _value.matches
          // ignore: cast_nullable_to_non_nullable
          : matches as List<ModerationMatchDto>,
      timedOut: timedOut == const $CopyWithPlaceholder()
          ? _value.timedOut
          // ignore: cast_nullable_to_non_nullable
          : timedOut as bool,
    );
  }
}

extension $ModerationTestResultDtoCopyWith on ModerationTestResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfModerationTestResultDto.copyWith(...)` or like so:`instanceOfModerationTestResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ModerationTestResultDtoCWProxy get copyWith =>
      _$ModerationTestResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationTestResultDto _$ModerationTestResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ModerationTestResultDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['held', 'matches', 'timedOut']);
  final val = ModerationTestResultDto(
    held: $checkedConvert('held', (v) => v as bool),
    matches: $checkedConvert(
      'matches',
      (v) => (v as List<dynamic>)
          .map((e) => ModerationMatchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    timedOut: $checkedConvert('timedOut', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$ModerationTestResultDtoToJson(
  ModerationTestResultDto instance,
) => <String, dynamic>{
  'held': instance.held,
  'matches': instance.matches.map((e) => e.toJson()).toList(),
  'timedOut': instance.timedOut,
};

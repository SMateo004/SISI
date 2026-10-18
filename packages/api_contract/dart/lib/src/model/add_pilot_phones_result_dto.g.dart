// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pilot_phones_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddPilotPhonesResultDtoCWProxy {
  AddPilotPhonesResultDto added(List<String> added);

  AddPilotPhonesResultDto alreadyListed(List<String> alreadyListed);

  AddPilotPhonesResultDto invalid(List<String> invalid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddPilotPhonesResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddPilotPhonesResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AddPilotPhonesResultDto call({
    List<String> added,
    List<String> alreadyListed,
    List<String> invalid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddPilotPhonesResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddPilotPhonesResultDto.copyWith.fieldName(...)`
class _$AddPilotPhonesResultDtoCWProxyImpl
    implements _$AddPilotPhonesResultDtoCWProxy {
  const _$AddPilotPhonesResultDtoCWProxyImpl(this._value);

  final AddPilotPhonesResultDto _value;

  @override
  AddPilotPhonesResultDto added(List<String> added) => this(added: added);

  @override
  AddPilotPhonesResultDto alreadyListed(List<String> alreadyListed) =>
      this(alreadyListed: alreadyListed);

  @override
  AddPilotPhonesResultDto invalid(List<String> invalid) =>
      this(invalid: invalid);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddPilotPhonesResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddPilotPhonesResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AddPilotPhonesResultDto call({
    Object? added = const $CopyWithPlaceholder(),
    Object? alreadyListed = const $CopyWithPlaceholder(),
    Object? invalid = const $CopyWithPlaceholder(),
  }) {
    return AddPilotPhonesResultDto(
      added: added == const $CopyWithPlaceholder()
          ? _value.added
          // ignore: cast_nullable_to_non_nullable
          : added as List<String>,
      alreadyListed: alreadyListed == const $CopyWithPlaceholder()
          ? _value.alreadyListed
          // ignore: cast_nullable_to_non_nullable
          : alreadyListed as List<String>,
      invalid: invalid == const $CopyWithPlaceholder()
          ? _value.invalid
          // ignore: cast_nullable_to_non_nullable
          : invalid as List<String>,
    );
  }
}

extension $AddPilotPhonesResultDtoCopyWith on AddPilotPhonesResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfAddPilotPhonesResultDto.copyWith(...)` or like so:`instanceOfAddPilotPhonesResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddPilotPhonesResultDtoCWProxy get copyWith =>
      _$AddPilotPhonesResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPilotPhonesResultDto _$AddPilotPhonesResultDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AddPilotPhonesResultDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['added', 'alreadyListed', 'invalid']);
  final val = AddPilotPhonesResultDto(
    added: $checkedConvert(
      'added',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    alreadyListed: $checkedConvert(
      'alreadyListed',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    invalid: $checkedConvert(
      'invalid',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$AddPilotPhonesResultDtoToJson(
  AddPilotPhonesResultDto instance,
) => <String, dynamic>{
  'added': instance.added,
  'alreadyListed': instance.alreadyListed,
  'invalid': instance.invalid,
};

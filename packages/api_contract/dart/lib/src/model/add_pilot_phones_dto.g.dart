// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_pilot_phones_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddPilotPhonesDtoCWProxy {
  AddPilotPhonesDto phones(List<String> phones);

  AddPilotPhonesDto note(String? note);

  AddPilotPhonesDto cityId(String? cityId);

  AddPilotPhonesDto reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddPilotPhonesDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddPilotPhonesDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AddPilotPhonesDto call({
    List<String> phones,
    String? note,
    String? cityId,
    String reason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddPilotPhonesDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddPilotPhonesDto.copyWith.fieldName(...)`
class _$AddPilotPhonesDtoCWProxyImpl implements _$AddPilotPhonesDtoCWProxy {
  const _$AddPilotPhonesDtoCWProxyImpl(this._value);

  final AddPilotPhonesDto _value;

  @override
  AddPilotPhonesDto phones(List<String> phones) => this(phones: phones);

  @override
  AddPilotPhonesDto note(String? note) => this(note: note);

  @override
  AddPilotPhonesDto cityId(String? cityId) => this(cityId: cityId);

  @override
  AddPilotPhonesDto reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddPilotPhonesDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddPilotPhonesDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AddPilotPhonesDto call({
    Object? phones = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return AddPilotPhonesDto(
      phones: phones == const $CopyWithPlaceholder()
          ? _value.phones
          // ignore: cast_nullable_to_non_nullable
          : phones as List<String>,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $AddPilotPhonesDtoCopyWith on AddPilotPhonesDto {
  /// Returns a callable class that can be used as follows: `instanceOfAddPilotPhonesDto.copyWith(...)` or like so:`instanceOfAddPilotPhonesDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddPilotPhonesDtoCWProxy get copyWith =>
      _$AddPilotPhonesDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPilotPhonesDto _$AddPilotPhonesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AddPilotPhonesDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phones', 'reason']);
      final val = AddPilotPhonesDto(
        phones: $checkedConvert(
          'phones',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        note: $checkedConvert('note', (v) => v as String?),
        cityId: $checkedConvert('cityId', (v) => v as String?),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AddPilotPhonesDtoToJson(AddPilotPhonesDto instance) =>
    <String, dynamic>{
      'phones': instance.phones,
      'note': ?instance.note,
      'cityId': ?instance.cityId,
      'reason': instance.reason,
    };

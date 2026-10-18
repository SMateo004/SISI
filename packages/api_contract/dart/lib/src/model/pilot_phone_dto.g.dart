// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_phone_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotPhoneDtoCWProxy {
  PilotPhoneDto id(String id);

  PilotPhoneDto phone(String phone);

  PilotPhoneDto note(String? note);

  PilotPhoneDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotPhoneDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotPhoneDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotPhoneDto call({
    String id,
    String phone,
    String? note,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotPhoneDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotPhoneDto.copyWith.fieldName(...)`
class _$PilotPhoneDtoCWProxyImpl implements _$PilotPhoneDtoCWProxy {
  const _$PilotPhoneDtoCWProxyImpl(this._value);

  final PilotPhoneDto _value;

  @override
  PilotPhoneDto id(String id) => this(id: id);

  @override
  PilotPhoneDto phone(String phone) => this(phone: phone);

  @override
  PilotPhoneDto note(String? note) => this(note: note);

  @override
  PilotPhoneDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotPhoneDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotPhoneDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotPhoneDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return PilotPhoneDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $PilotPhoneDtoCopyWith on PilotPhoneDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotPhoneDto.copyWith(...)` or like so:`instanceOfPilotPhoneDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotPhoneDtoCWProxy get copyWith => _$PilotPhoneDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotPhoneDto _$PilotPhoneDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PilotPhoneDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'phone', 'note', 'createdAt']);
  final val = PilotPhoneDto(
    id: $checkedConvert('id', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    note: $checkedConvert('note', (v) => v as String?),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$PilotPhoneDtoToJson(PilotPhoneDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
    };

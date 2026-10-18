// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_interest_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotInterestDtoCWProxy {
  PilotInterestDto phone(String phone);

  PilotInterestDto role(PilotInterestDtoRoleEnum role);

  PilotInterestDto categoryId(String? categoryId);

  PilotInterestDto zone(String? zone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotInterestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotInterestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotInterestDto call({
    String phone,
    PilotInterestDtoRoleEnum role,
    String? categoryId,
    String? zone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotInterestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotInterestDto.copyWith.fieldName(...)`
class _$PilotInterestDtoCWProxyImpl implements _$PilotInterestDtoCWProxy {
  const _$PilotInterestDtoCWProxyImpl(this._value);

  final PilotInterestDto _value;

  @override
  PilotInterestDto phone(String phone) => this(phone: phone);

  @override
  PilotInterestDto role(PilotInterestDtoRoleEnum role) => this(role: role);

  @override
  PilotInterestDto categoryId(String? categoryId) =>
      this(categoryId: categoryId);

  @override
  PilotInterestDto zone(String? zone) => this(zone: zone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotInterestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotInterestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotInterestDto call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? zone = const $CopyWithPlaceholder(),
  }) {
    return PilotInterestDto(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as PilotInterestDtoRoleEnum,
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as String?,
      zone: zone == const $CopyWithPlaceholder()
          ? _value.zone
          // ignore: cast_nullable_to_non_nullable
          : zone as String?,
    );
  }
}

extension $PilotInterestDtoCopyWith on PilotInterestDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotInterestDto.copyWith(...)` or like so:`instanceOfPilotInterestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotInterestDtoCWProxy get copyWith => _$PilotInterestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotInterestDto _$PilotInterestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PilotInterestDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone', 'role']);
      final val = PilotInterestDto(
        phone: $checkedConvert('phone', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$PilotInterestDtoRoleEnumEnumMap, v),
        ),
        categoryId: $checkedConvert('categoryId', (v) => v as String?),
        zone: $checkedConvert('zone', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PilotInterestDtoToJson(PilotInterestDto instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'role': _$PilotInterestDtoRoleEnumEnumMap[instance.role]!,
      'categoryId': ?instance.categoryId,
      'zone': ?instance.zone,
    };

const _$PilotInterestDtoRoleEnumEnumMap = {
  PilotInterestDtoRoleEnum.worker: 'worker',
  PilotInterestDtoRoleEnum.employer: 'employer',
  PilotInterestDtoRoleEnum.ambos: 'ambos',
};

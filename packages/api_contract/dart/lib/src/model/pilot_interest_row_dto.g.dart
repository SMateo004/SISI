// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_interest_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotInterestRowDtoCWProxy {
  PilotInterestRowDto id(String id);

  PilotInterestRowDto phone(String phone);

  PilotInterestRowDto role(PilotInterestRowDtoRoleEnum role);

  PilotInterestRowDto categoryName(String? categoryName);

  PilotInterestRowDto zone(String? zone);

  PilotInterestRowDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotInterestRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotInterestRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotInterestRowDto call({
    String id,
    String phone,
    PilotInterestRowDtoRoleEnum role,
    String? categoryName,
    String? zone,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotInterestRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotInterestRowDto.copyWith.fieldName(...)`
class _$PilotInterestRowDtoCWProxyImpl implements _$PilotInterestRowDtoCWProxy {
  const _$PilotInterestRowDtoCWProxyImpl(this._value);

  final PilotInterestRowDto _value;

  @override
  PilotInterestRowDto id(String id) => this(id: id);

  @override
  PilotInterestRowDto phone(String phone) => this(phone: phone);

  @override
  PilotInterestRowDto role(PilotInterestRowDtoRoleEnum role) =>
      this(role: role);

  @override
  PilotInterestRowDto categoryName(String? categoryName) =>
      this(categoryName: categoryName);

  @override
  PilotInterestRowDto zone(String? zone) => this(zone: zone);

  @override
  PilotInterestRowDto createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotInterestRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotInterestRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotInterestRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? categoryName = const $CopyWithPlaceholder(),
    Object? zone = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return PilotInterestRowDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as PilotInterestRowDtoRoleEnum,
      categoryName: categoryName == const $CopyWithPlaceholder()
          ? _value.categoryName
          // ignore: cast_nullable_to_non_nullable
          : categoryName as String?,
      zone: zone == const $CopyWithPlaceholder()
          ? _value.zone
          // ignore: cast_nullable_to_non_nullable
          : zone as String?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $PilotInterestRowDtoCopyWith on PilotInterestRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotInterestRowDto.copyWith(...)` or like so:`instanceOfPilotInterestRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotInterestRowDtoCWProxy get copyWith =>
      _$PilotInterestRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotInterestRowDto _$PilotInterestRowDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PilotInterestRowDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'phone',
          'role',
          'categoryName',
          'zone',
          'createdAt',
        ],
      );
      final val = PilotInterestRowDto(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$PilotInterestRowDtoRoleEnumEnumMap, v),
        ),
        categoryName: $checkedConvert('categoryName', (v) => v as String?),
        zone: $checkedConvert('zone', (v) => v as String?),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PilotInterestRowDtoToJson(
  PilotInterestRowDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'role': _$PilotInterestRowDtoRoleEnumEnumMap[instance.role]!,
  'categoryName': instance.categoryName,
  'zone': instance.zone,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$PilotInterestRowDtoRoleEnumEnumMap = {
  PilotInterestRowDtoRoleEnum.worker: 'worker',
  PilotInterestRowDtoRoleEnum.employer: 'employer',
  PilotInterestRowDtoRoleEnum.ambos: 'ambos',
};

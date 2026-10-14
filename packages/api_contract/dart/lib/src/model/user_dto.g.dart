// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserDtoCWProxy {
  UserDto id(String id);

  UserDto phone(String phone);

  UserDto name(String? name);

  UserDto photoUrl(String? photoUrl);

  UserDto role(UserDtoRoleEnum role);

  UserDto activeMode(UserDtoActiveModeEnum activeMode);

  UserDto cityId(String cityId);

  UserDto createdAt(String createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDto call({
    String id,
    String phone,
    String? name,
    String? photoUrl,
    UserDtoRoleEnum role,
    UserDtoActiveModeEnum activeMode,
    String cityId,
    String createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserDto.copyWith.fieldName(...)`
class _$UserDtoCWProxyImpl implements _$UserDtoCWProxy {
  const _$UserDtoCWProxyImpl(this._value);

  final UserDto _value;

  @override
  UserDto id(String id) => this(id: id);

  @override
  UserDto phone(String phone) => this(phone: phone);

  @override
  UserDto name(String? name) => this(name: name);

  @override
  UserDto photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  UserDto role(UserDtoRoleEnum role) => this(role: role);

  @override
  UserDto activeMode(UserDtoActiveModeEnum activeMode) =>
      this(activeMode: activeMode);

  @override
  UserDto cityId(String cityId) => this(cityId: cityId);

  @override
  UserDto createdAt(String createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? activeMode = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return UserDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UserDtoRoleEnum,
      activeMode: activeMode == const $CopyWithPlaceholder()
          ? _value.activeMode
          // ignore: cast_nullable_to_non_nullable
          : activeMode as UserDtoActiveModeEnum,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as String,
    );
  }
}

extension $UserDtoCopyWith on UserDto {
  /// Returns a callable class that can be used as follows: `instanceOfUserDto.copyWith(...)` or like so:`instanceOfUserDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserDtoCWProxy get copyWith => _$UserDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'phone',
          'name',
          'photoUrl',
          'role',
          'activeMode',
          'cityId',
          'createdAt',
        ],
      );
      final val = UserDto(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String?),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$UserDtoRoleEnumEnumMap, v),
        ),
        activeMode: $checkedConvert(
          'activeMode',
          (v) => $enumDecode(_$UserDtoActiveModeEnumEnumMap, v),
        ),
        cityId: $checkedConvert('cityId', (v) => v as String),
        createdAt: $checkedConvert('createdAt', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'name': instance.name,
  'photoUrl': instance.photoUrl,
  'role': _$UserDtoRoleEnumEnumMap[instance.role]!,
  'activeMode': _$UserDtoActiveModeEnumEnumMap[instance.activeMode]!,
  'cityId': instance.cityId,
  'createdAt': instance.createdAt,
};

const _$UserDtoRoleEnumEnumMap = {
  UserDtoRoleEnum.user: 'user',
  UserDtoRoleEnum.admin: 'admin',
};

const _$UserDtoActiveModeEnumEnumMap = {
  UserDtoActiveModeEnum.employer: 'employer',
  UserDtoActiveModeEnum.worker: 'worker',
};

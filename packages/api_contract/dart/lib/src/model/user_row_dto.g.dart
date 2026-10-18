// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserRowDtoCWProxy {
  UserRowDto id(String id);

  UserRowDto phone(String phone);

  UserRowDto name(String? name);

  UserRowDto role(UserRowDtoRoleEnum role);

  UserRowDto activeMode(UserRowDtoActiveModeEnum activeMode);

  UserRowDto cityName(String cityName);

  UserRowDto workerStatus(String? workerStatus);

  UserRowDto flagged(bool flagged);

  UserRowDto createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserRowDto call({
    String id,
    String phone,
    String? name,
    UserRowDtoRoleEnum role,
    UserRowDtoActiveModeEnum activeMode,
    String cityName,
    String? workerStatus,
    bool flagged,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserRowDto.copyWith.fieldName(...)`
class _$UserRowDtoCWProxyImpl implements _$UserRowDtoCWProxy {
  const _$UserRowDtoCWProxyImpl(this._value);

  final UserRowDto _value;

  @override
  UserRowDto id(String id) => this(id: id);

  @override
  UserRowDto phone(String phone) => this(phone: phone);

  @override
  UserRowDto name(String? name) => this(name: name);

  @override
  UserRowDto role(UserRowDtoRoleEnum role) => this(role: role);

  @override
  UserRowDto activeMode(UserRowDtoActiveModeEnum activeMode) =>
      this(activeMode: activeMode);

  @override
  UserRowDto cityName(String cityName) => this(cityName: cityName);

  @override
  UserRowDto workerStatus(String? workerStatus) =>
      this(workerStatus: workerStatus);

  @override
  UserRowDto flagged(bool flagged) => this(flagged: flagged);

  @override
  UserRowDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? activeMode = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? workerStatus = const $CopyWithPlaceholder(),
    Object? flagged = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return UserRowDto(
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
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UserRowDtoRoleEnum,
      activeMode: activeMode == const $CopyWithPlaceholder()
          ? _value.activeMode
          // ignore: cast_nullable_to_non_nullable
          : activeMode as UserRowDtoActiveModeEnum,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      workerStatus: workerStatus == const $CopyWithPlaceholder()
          ? _value.workerStatus
          // ignore: cast_nullable_to_non_nullable
          : workerStatus as String?,
      flagged: flagged == const $CopyWithPlaceholder()
          ? _value.flagged
          // ignore: cast_nullable_to_non_nullable
          : flagged as bool,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $UserRowDtoCopyWith on UserRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfUserRowDto.copyWith(...)` or like so:`instanceOfUserRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserRowDtoCWProxy get copyWith => _$UserRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRowDto _$UserRowDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserRowDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'phone',
          'name',
          'role',
          'activeMode',
          'cityName',
          'workerStatus',
          'flagged',
          'createdAt',
        ],
      );
      final val = UserRowDto(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String?),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$UserRowDtoRoleEnumEnumMap, v),
        ),
        activeMode: $checkedConvert(
          'activeMode',
          (v) => $enumDecode(_$UserRowDtoActiveModeEnumEnumMap, v),
        ),
        cityName: $checkedConvert('cityName', (v) => v as String),
        workerStatus: $checkedConvert('workerStatus', (v) => v as String?),
        flagged: $checkedConvert('flagged', (v) => v as bool),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$UserRowDtoToJson(UserRowDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': _$UserRowDtoRoleEnumEnumMap[instance.role]!,
      'activeMode': _$UserRowDtoActiveModeEnumEnumMap[instance.activeMode]!,
      'cityName': instance.cityName,
      'workerStatus': instance.workerStatus,
      'flagged': instance.flagged,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UserRowDtoRoleEnumEnumMap = {
  UserRowDtoRoleEnum.user: 'user',
  UserRowDtoRoleEnum.admin: 'admin',
};

const _$UserRowDtoActiveModeEnumEnumMap = {
  UserRowDtoActiveModeEnum.employer: 'employer',
  UserRowDtoActiveModeEnum.worker: 'worker',
};

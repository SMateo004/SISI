// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MeDtoCWProxy {
  MeDto id(String id);

  MeDto phone(String phone);

  MeDto name(String? name);

  MeDto photoUrl(String? photoUrl);

  MeDto role(MeDtoRoleEnum role);

  MeDto activeMode(MeDtoActiveModeEnum activeMode);

  MeDto cityId(String cityId);

  MeDto createdAt(String createdAt);

  MeDto legalPending(List<MeDtoLegalPendingEnum> legalPending);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MeDto call({
    String id,
    String phone,
    String? name,
    String? photoUrl,
    MeDtoRoleEnum role,
    MeDtoActiveModeEnum activeMode,
    String cityId,
    String createdAt,
    List<MeDtoLegalPendingEnum> legalPending,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMeDto.copyWith.fieldName(...)`
class _$MeDtoCWProxyImpl implements _$MeDtoCWProxy {
  const _$MeDtoCWProxyImpl(this._value);

  final MeDto _value;

  @override
  MeDto id(String id) => this(id: id);

  @override
  MeDto phone(String phone) => this(phone: phone);

  @override
  MeDto name(String? name) => this(name: name);

  @override
  MeDto photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  MeDto role(MeDtoRoleEnum role) => this(role: role);

  @override
  MeDto activeMode(MeDtoActiveModeEnum activeMode) =>
      this(activeMode: activeMode);

  @override
  MeDto cityId(String cityId) => this(cityId: cityId);

  @override
  MeDto createdAt(String createdAt) => this(createdAt: createdAt);

  @override
  MeDto legalPending(List<MeDtoLegalPendingEnum> legalPending) =>
      this(legalPending: legalPending);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MeDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? activeMode = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? legalPending = const $CopyWithPlaceholder(),
  }) {
    return MeDto(
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
          : role as MeDtoRoleEnum,
      activeMode: activeMode == const $CopyWithPlaceholder()
          ? _value.activeMode
          // ignore: cast_nullable_to_non_nullable
          : activeMode as MeDtoActiveModeEnum,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as String,
      legalPending: legalPending == const $CopyWithPlaceholder()
          ? _value.legalPending
          // ignore: cast_nullable_to_non_nullable
          : legalPending as List<MeDtoLegalPendingEnum>,
    );
  }
}

extension $MeDtoCopyWith on MeDto {
  /// Returns a callable class that can be used as follows: `instanceOfMeDto.copyWith(...)` or like so:`instanceOfMeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MeDtoCWProxy get copyWith => _$MeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeDto _$MeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MeDto', json, ($checkedConvert) {
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
          'legalPending',
        ],
      );
      final val = MeDto(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String?),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$MeDtoRoleEnumEnumMap, v),
        ),
        activeMode: $checkedConvert(
          'activeMode',
          (v) => $enumDecode(_$MeDtoActiveModeEnumEnumMap, v),
        ),
        cityId: $checkedConvert('cityId', (v) => v as String),
        createdAt: $checkedConvert('createdAt', (v) => v as String),
        legalPending: $checkedConvert(
          'legalPending',
          (v) => (v as List<dynamic>)
              .map((e) => $enumDecode(_$MeDtoLegalPendingEnumEnumMap, e))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MeDtoToJson(MeDto instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'name': instance.name,
  'photoUrl': instance.photoUrl,
  'role': _$MeDtoRoleEnumEnumMap[instance.role]!,
  'activeMode': _$MeDtoActiveModeEnumEnumMap[instance.activeMode]!,
  'cityId': instance.cityId,
  'createdAt': instance.createdAt,
  'legalPending': instance.legalPending
      .map((e) => _$MeDtoLegalPendingEnumEnumMap[e]!)
      .toList(),
};

const _$MeDtoRoleEnumEnumMap = {
  MeDtoRoleEnum.user: 'user',
  MeDtoRoleEnum.admin: 'admin',
};

const _$MeDtoActiveModeEnumEnumMap = {
  MeDtoActiveModeEnum.employer: 'employer',
  MeDtoActiveModeEnum.worker: 'worker',
};

const _$MeDtoLegalPendingEnumEnumMap = {
  MeDtoLegalPendingEnum.terms: 'terms',
  MeDtoLegalPendingEnum.privacy: 'privacy',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_job_party_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminJobPartyDtoCWProxy {
  AdminJobPartyDto id(String id);

  AdminJobPartyDto name(String? name);

  AdminJobPartyDto phone(String phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobPartyDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobPartyDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobPartyDto call({String id, String? name, String phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminJobPartyDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminJobPartyDto.copyWith.fieldName(...)`
class _$AdminJobPartyDtoCWProxyImpl implements _$AdminJobPartyDtoCWProxy {
  const _$AdminJobPartyDtoCWProxyImpl(this._value);

  final AdminJobPartyDto _value;

  @override
  AdminJobPartyDto id(String id) => this(id: id);

  @override
  AdminJobPartyDto name(String? name) => this(name: name);

  @override
  AdminJobPartyDto phone(String phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobPartyDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobPartyDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobPartyDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
  }) {
    return AdminJobPartyDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
    );
  }
}

extension $AdminJobPartyDtoCopyWith on AdminJobPartyDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminJobPartyDto.copyWith(...)` or like so:`instanceOfAdminJobPartyDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminJobPartyDtoCWProxy get copyWith => _$AdminJobPartyDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJobPartyDto _$AdminJobPartyDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminJobPartyDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'phone']);
      final val = AdminJobPartyDto(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminJobPartyDtoToJson(AdminJobPartyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };

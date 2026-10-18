// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminCityDtoCWProxy {
  AdminCityDto id(String id);

  AdminCityDto slug(String slug);

  AdminCityDto name(String name);

  AdminCityDto timezone(String timezone);

  AdminCityDto active(bool active);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCityDto call({
    String id,
    String slug,
    String name,
    String timezone,
    bool active,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminCityDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminCityDto.copyWith.fieldName(...)`
class _$AdminCityDtoCWProxyImpl implements _$AdminCityDtoCWProxy {
  const _$AdminCityDtoCWProxyImpl(this._value);

  final AdminCityDto _value;

  @override
  AdminCityDto id(String id) => this(id: id);

  @override
  AdminCityDto slug(String slug) => this(slug: slug);

  @override
  AdminCityDto name(String name) => this(name: name);

  @override
  AdminCityDto timezone(String timezone) => this(timezone: timezone);

  @override
  AdminCityDto active(bool active) => this(active: active);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCityDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? timezone = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
  }) {
    return AdminCityDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      slug: slug == const $CopyWithPlaceholder()
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      timezone: timezone == const $CopyWithPlaceholder()
          ? _value.timezone
          // ignore: cast_nullable_to_non_nullable
          : timezone as String,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
    );
  }
}

extension $AdminCityDtoCopyWith on AdminCityDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminCityDto.copyWith(...)` or like so:`instanceOfAdminCityDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminCityDtoCWProxy get copyWith => _$AdminCityDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCityDto _$AdminCityDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminCityDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'slug', 'name', 'timezone', 'active'],
      );
      final val = AdminCityDto(
        id: $checkedConvert('id', (v) => v as String),
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        timezone: $checkedConvert('timezone', (v) => v as String),
        active: $checkedConvert('active', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$AdminCityDtoToJson(AdminCityDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'timezone': instance.timezone,
      'active': instance.active,
    };

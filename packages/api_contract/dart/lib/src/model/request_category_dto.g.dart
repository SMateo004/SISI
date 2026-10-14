// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RequestCategoryDtoCWProxy {
  RequestCategoryDto id(String id);

  RequestCategoryDto slug(String slug);

  RequestCategoryDto name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestCategoryDto call({String id, String slug, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRequestCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRequestCategoryDto.copyWith.fieldName(...)`
class _$RequestCategoryDtoCWProxyImpl implements _$RequestCategoryDtoCWProxy {
  const _$RequestCategoryDtoCWProxyImpl(this._value);

  final RequestCategoryDto _value;

  @override
  RequestCategoryDto id(String id) => this(id: id);

  @override
  RequestCategoryDto slug(String slug) => this(slug: slug);

  @override
  RequestCategoryDto name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestCategoryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return RequestCategoryDto(
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
    );
  }
}

extension $RequestCategoryDtoCopyWith on RequestCategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfRequestCategoryDto.copyWith(...)` or like so:`instanceOfRequestCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RequestCategoryDtoCWProxy get copyWith =>
      _$RequestCategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestCategoryDto _$RequestCategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RequestCategoryDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'slug', 'name']);
      final val = RequestCategoryDto(
        id: $checkedConvert('id', (v) => v as String),
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RequestCategoryDtoToJson(RequestCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CategoryDtoCWProxy {
  CategoryDto id(String id);

  CategoryDto slug(String slug);

  CategoryDto name(String name);

  CategoryDto description(String? description);

  CategoryDto priceMinBs(String priceMinBs);

  CategoryDto priceMaxBs(String priceMaxBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryDto call({
    String id,
    String slug,
    String name,
    String? description,
    String priceMinBs,
    String priceMaxBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCategoryDto.copyWith.fieldName(...)`
class _$CategoryDtoCWProxyImpl implements _$CategoryDtoCWProxy {
  const _$CategoryDtoCWProxyImpl(this._value);

  final CategoryDto _value;

  @override
  CategoryDto id(String id) => this(id: id);

  @override
  CategoryDto slug(String slug) => this(slug: slug);

  @override
  CategoryDto name(String name) => this(name: name);

  @override
  CategoryDto description(String? description) =>
      this(description: description);

  @override
  CategoryDto priceMinBs(String priceMinBs) => this(priceMinBs: priceMinBs);

  @override
  CategoryDto priceMaxBs(String priceMaxBs) => this(priceMaxBs: priceMaxBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CategoryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? priceMinBs = const $CopyWithPlaceholder(),
    Object? priceMaxBs = const $CopyWithPlaceholder(),
  }) {
    return CategoryDto(
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
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      priceMinBs: priceMinBs == const $CopyWithPlaceholder()
          ? _value.priceMinBs
          // ignore: cast_nullable_to_non_nullable
          : priceMinBs as String,
      priceMaxBs: priceMaxBs == const $CopyWithPlaceholder()
          ? _value.priceMaxBs
          // ignore: cast_nullable_to_non_nullable
          : priceMaxBs as String,
    );
  }
}

extension $CategoryDtoCopyWith on CategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfCategoryDto.copyWith(...)` or like so:`instanceOfCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CategoryDtoCWProxy get copyWith => _$CategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CategoryDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'slug',
          'name',
          'description',
          'priceMinBs',
          'priceMaxBs',
        ],
      );
      final val = CategoryDto(
        id: $checkedConvert('id', (v) => v as String),
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String?),
        priceMinBs: $checkedConvert('priceMinBs', (v) => v as String),
        priceMaxBs: $checkedConvert('priceMaxBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'priceMinBs': instance.priceMinBs,
      'priceMaxBs': instance.priceMaxBs,
    };

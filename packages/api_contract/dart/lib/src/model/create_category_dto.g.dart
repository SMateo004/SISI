// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateCategoryDtoCWProxy {
  CreateCategoryDto slug(String slug);

  CreateCategoryDto name(String name);

  CreateCategoryDto description(String? description);

  CreateCategoryDto priceMinBs(String priceMinBs);

  CreateCategoryDto priceMaxBs(String priceMaxBs);

  CreateCategoryDto commissionPct(String? commissionPct);

  CreateCategoryDto extraRequirements(List<String>? extraRequirements);

  CreateCategoryDto cityIds(List<String>? cityIds);

  CreateCategoryDto reason(String? reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateCategoryDto call({
    String slug,
    String name,
    String? description,
    String priceMinBs,
    String priceMaxBs,
    String? commissionPct,
    List<String>? extraRequirements,
    List<String>? cityIds,
    String? reason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateCategoryDto.copyWith.fieldName(...)`
class _$CreateCategoryDtoCWProxyImpl implements _$CreateCategoryDtoCWProxy {
  const _$CreateCategoryDtoCWProxyImpl(this._value);

  final CreateCategoryDto _value;

  @override
  CreateCategoryDto slug(String slug) => this(slug: slug);

  @override
  CreateCategoryDto name(String name) => this(name: name);

  @override
  CreateCategoryDto description(String? description) =>
      this(description: description);

  @override
  CreateCategoryDto priceMinBs(String priceMinBs) =>
      this(priceMinBs: priceMinBs);

  @override
  CreateCategoryDto priceMaxBs(String priceMaxBs) =>
      this(priceMaxBs: priceMaxBs);

  @override
  CreateCategoryDto commissionPct(String? commissionPct) =>
      this(commissionPct: commissionPct);

  @override
  CreateCategoryDto extraRequirements(List<String>? extraRequirements) =>
      this(extraRequirements: extraRequirements);

  @override
  CreateCategoryDto cityIds(List<String>? cityIds) => this(cityIds: cityIds);

  @override
  CreateCategoryDto reason(String? reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateCategoryDto call({
    Object? slug = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? priceMinBs = const $CopyWithPlaceholder(),
    Object? priceMaxBs = const $CopyWithPlaceholder(),
    Object? commissionPct = const $CopyWithPlaceholder(),
    Object? extraRequirements = const $CopyWithPlaceholder(),
    Object? cityIds = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return CreateCategoryDto(
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
      commissionPct: commissionPct == const $CopyWithPlaceholder()
          ? _value.commissionPct
          // ignore: cast_nullable_to_non_nullable
          : commissionPct as String?,
      extraRequirements: extraRequirements == const $CopyWithPlaceholder()
          ? _value.extraRequirements
          // ignore: cast_nullable_to_non_nullable
          : extraRequirements as List<String>?,
      cityIds: cityIds == const $CopyWithPlaceholder()
          ? _value.cityIds
          // ignore: cast_nullable_to_non_nullable
          : cityIds as List<String>?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
    );
  }
}

extension $CreateCategoryDtoCopyWith on CreateCategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateCategoryDto.copyWith(...)` or like so:`instanceOfCreateCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateCategoryDtoCWProxy get copyWith =>
      _$CreateCategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryDto _$CreateCategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateCategoryDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['slug', 'name', 'priceMinBs', 'priceMaxBs'],
      );
      final val = CreateCategoryDto(
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String?),
        priceMinBs: $checkedConvert('priceMinBs', (v) => v as String),
        priceMaxBs: $checkedConvert('priceMaxBs', (v) => v as String),
        commissionPct: $checkedConvert('commissionPct', (v) => v as String?),
        extraRequirements: $checkedConvert(
          'extraRequirements',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        cityIds: $checkedConvert(
          'cityIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        reason: $checkedConvert('reason', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreateCategoryDtoToJson(CreateCategoryDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'description': ?instance.description,
      'priceMinBs': instance.priceMinBs,
      'priceMaxBs': instance.priceMaxBs,
      'commissionPct': ?instance.commissionPct,
      'extraRequirements': ?instance.extraRequirements,
      'cityIds': ?instance.cityIds,
      'reason': ?instance.reason,
    };

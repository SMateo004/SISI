// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminCategoryDtoCWProxy {
  AdminCategoryDto id(String id);

  AdminCategoryDto slug(String slug);

  AdminCategoryDto name(String name);

  AdminCategoryDto description(String? description);

  AdminCategoryDto priceMinBs(String priceMinBs);

  AdminCategoryDto priceMaxBs(String priceMaxBs);

  AdminCategoryDto commissionPct(String commissionPct);

  AdminCategoryDto active(bool active);

  AdminCategoryDto extraRequirements(List<String> extraRequirements);

  AdminCategoryDto cities(List<AdminCategoryCityDto> cities);

  AdminCategoryDto notice(String? notice);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCategoryDto call({
    String id,
    String slug,
    String name,
    String? description,
    String priceMinBs,
    String priceMaxBs,
    String commissionPct,
    bool active,
    List<String> extraRequirements,
    List<AdminCategoryCityDto> cities,
    String? notice,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminCategoryDto.copyWith.fieldName(...)`
class _$AdminCategoryDtoCWProxyImpl implements _$AdminCategoryDtoCWProxy {
  const _$AdminCategoryDtoCWProxyImpl(this._value);

  final AdminCategoryDto _value;

  @override
  AdminCategoryDto id(String id) => this(id: id);

  @override
  AdminCategoryDto slug(String slug) => this(slug: slug);

  @override
  AdminCategoryDto name(String name) => this(name: name);

  @override
  AdminCategoryDto description(String? description) =>
      this(description: description);

  @override
  AdminCategoryDto priceMinBs(String priceMinBs) =>
      this(priceMinBs: priceMinBs);

  @override
  AdminCategoryDto priceMaxBs(String priceMaxBs) =>
      this(priceMaxBs: priceMaxBs);

  @override
  AdminCategoryDto commissionPct(String commissionPct) =>
      this(commissionPct: commissionPct);

  @override
  AdminCategoryDto active(bool active) => this(active: active);

  @override
  AdminCategoryDto extraRequirements(List<String> extraRequirements) =>
      this(extraRequirements: extraRequirements);

  @override
  AdminCategoryDto cities(List<AdminCategoryCityDto> cities) =>
      this(cities: cities);

  @override
  AdminCategoryDto notice(String? notice) => this(notice: notice);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCategoryDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? priceMinBs = const $CopyWithPlaceholder(),
    Object? priceMaxBs = const $CopyWithPlaceholder(),
    Object? commissionPct = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? extraRequirements = const $CopyWithPlaceholder(),
    Object? cities = const $CopyWithPlaceholder(),
    Object? notice = const $CopyWithPlaceholder(),
  }) {
    return AdminCategoryDto(
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
      commissionPct: commissionPct == const $CopyWithPlaceholder()
          ? _value.commissionPct
          // ignore: cast_nullable_to_non_nullable
          : commissionPct as String,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
      extraRequirements: extraRequirements == const $CopyWithPlaceholder()
          ? _value.extraRequirements
          // ignore: cast_nullable_to_non_nullable
          : extraRequirements as List<String>,
      cities: cities == const $CopyWithPlaceholder()
          ? _value.cities
          // ignore: cast_nullable_to_non_nullable
          : cities as List<AdminCategoryCityDto>,
      notice: notice == const $CopyWithPlaceholder()
          ? _value.notice
          // ignore: cast_nullable_to_non_nullable
          : notice as String?,
    );
  }
}

extension $AdminCategoryDtoCopyWith on AdminCategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminCategoryDto.copyWith(...)` or like so:`instanceOfAdminCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminCategoryDtoCWProxy get copyWith => _$AdminCategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCategoryDto _$AdminCategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminCategoryDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'slug',
          'name',
          'description',
          'priceMinBs',
          'priceMaxBs',
          'commissionPct',
          'active',
          'extraRequirements',
          'cities',
          'notice',
        ],
      );
      final val = AdminCategoryDto(
        id: $checkedConvert('id', (v) => v as String),
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String?),
        priceMinBs: $checkedConvert('priceMinBs', (v) => v as String),
        priceMaxBs: $checkedConvert('priceMaxBs', (v) => v as String),
        commissionPct: $checkedConvert('commissionPct', (v) => v as String),
        active: $checkedConvert('active', (v) => v as bool),
        extraRequirements: $checkedConvert(
          'extraRequirements',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        cities: $checkedConvert(
          'cities',
          (v) => (v as List<dynamic>)
              .map(
                (e) => AdminCategoryCityDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        notice: $checkedConvert('notice', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminCategoryDtoToJson(AdminCategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'priceMinBs': instance.priceMinBs,
      'priceMaxBs': instance.priceMaxBs,
      'commissionPct': instance.commissionPct,
      'active': instance.active,
      'extraRequirements': instance.extraRequirements,
      'cities': instance.cities.map((e) => e.toJson()).toList(),
      'notice': instance.notice,
    };

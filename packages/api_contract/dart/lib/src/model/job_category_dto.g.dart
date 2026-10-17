// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobCategoryDtoCWProxy {
  JobCategoryDto slug(String slug);

  JobCategoryDto name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCategoryDto call({String slug, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobCategoryDto.copyWith.fieldName(...)`
class _$JobCategoryDtoCWProxyImpl implements _$JobCategoryDtoCWProxy {
  const _$JobCategoryDtoCWProxyImpl(this._value);

  final JobCategoryDto _value;

  @override
  JobCategoryDto slug(String slug) => this(slug: slug);

  @override
  JobCategoryDto name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCategoryDto call({
    Object? slug = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return JobCategoryDto(
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

extension $JobCategoryDtoCopyWith on JobCategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobCategoryDto.copyWith(...)` or like so:`instanceOfJobCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobCategoryDtoCWProxy get copyWith => _$JobCategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobCategoryDto _$JobCategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobCategoryDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['slug', 'name']);
      final val = JobCategoryDto(
        slug: $checkedConvert('slug', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$JobCategoryDtoToJson(JobCategoryDto instance) =>
    <String, dynamic>{'slug': instance.slug, 'name': instance.name};

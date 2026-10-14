// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpdateCategoryDtoCWProxy {
  UpdateCategoryDto name(String? name);

  UpdateCategoryDto description(String? description);

  UpdateCategoryDto priceMinBs(String? priceMinBs);

  UpdateCategoryDto priceMaxBs(String? priceMaxBs);

  UpdateCategoryDto commissionPct(String? commissionPct);

  UpdateCategoryDto active(bool? active);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateCategoryDto call({
    String? name,
    String? description,
    String? priceMinBs,
    String? priceMaxBs,
    String? commissionPct,
    bool? active,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpdateCategoryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpdateCategoryDto.copyWith.fieldName(...)`
class _$UpdateCategoryDtoCWProxyImpl implements _$UpdateCategoryDtoCWProxy {
  const _$UpdateCategoryDtoCWProxyImpl(this._value);

  final UpdateCategoryDto _value;

  @override
  UpdateCategoryDto name(String? name) => this(name: name);

  @override
  UpdateCategoryDto description(String? description) =>
      this(description: description);

  @override
  UpdateCategoryDto priceMinBs(String? priceMinBs) =>
      this(priceMinBs: priceMinBs);

  @override
  UpdateCategoryDto priceMaxBs(String? priceMaxBs) =>
      this(priceMaxBs: priceMaxBs);

  @override
  UpdateCategoryDto commissionPct(String? commissionPct) =>
      this(commissionPct: commissionPct);

  @override
  UpdateCategoryDto active(bool? active) => this(active: active);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpdateCategoryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpdateCategoryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpdateCategoryDto call({
    Object? name = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? priceMinBs = const $CopyWithPlaceholder(),
    Object? priceMaxBs = const $CopyWithPlaceholder(),
    Object? commissionPct = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
  }) {
    return UpdateCategoryDto(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      priceMinBs: priceMinBs == const $CopyWithPlaceholder()
          ? _value.priceMinBs
          // ignore: cast_nullable_to_non_nullable
          : priceMinBs as String?,
      priceMaxBs: priceMaxBs == const $CopyWithPlaceholder()
          ? _value.priceMaxBs
          // ignore: cast_nullable_to_non_nullable
          : priceMaxBs as String?,
      commissionPct: commissionPct == const $CopyWithPlaceholder()
          ? _value.commissionPct
          // ignore: cast_nullable_to_non_nullable
          : commissionPct as String?,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool?,
    );
  }
}

extension $UpdateCategoryDtoCopyWith on UpdateCategoryDto {
  /// Returns a callable class that can be used as follows: `instanceOfUpdateCategoryDto.copyWith(...)` or like so:`instanceOfUpdateCategoryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpdateCategoryDtoCWProxy get copyWith =>
      _$UpdateCategoryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryDto _$UpdateCategoryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UpdateCategoryDto', json, ($checkedConvert) {
      final val = UpdateCategoryDto(
        name: $checkedConvert('name', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
        priceMinBs: $checkedConvert('priceMinBs', (v) => v as String?),
        priceMaxBs: $checkedConvert('priceMaxBs', (v) => v as String?),
        commissionPct: $checkedConvert('commissionPct', (v) => v as String?),
        active: $checkedConvert('active', (v) => v as bool?),
      );
      return val;
    });

Map<String, dynamic> _$UpdateCategoryDtoToJson(UpdateCategoryDto instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'description': ?instance.description,
      'priceMinBs': ?instance.priceMinBs,
      'priceMaxBs': ?instance.priceMaxBs,
      'commissionPct': ?instance.commissionPct,
      'active': ?instance.active,
    };

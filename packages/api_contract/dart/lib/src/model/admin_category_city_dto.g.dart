// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_city_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminCategoryCityDtoCWProxy {
  AdminCategoryCityDto cityId(String cityId);

  AdminCategoryCityDto citySlug(String citySlug);

  AdminCategoryCityDto active(bool active);

  AdminCategoryCityDto priceMinBs(String? priceMinBs);

  AdminCategoryCityDto priceMaxBs(String? priceMaxBs);

  AdminCategoryCityDto commissionPct(String? commissionPct);

  AdminCategoryCityDto effectivePriceMinBs(String effectivePriceMinBs);

  AdminCategoryCityDto effectivePriceMaxBs(String effectivePriceMaxBs);

  AdminCategoryCityDto effectiveCommissionPct(String effectiveCommissionPct);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCategoryCityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCategoryCityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCategoryCityDto call({
    String cityId,
    String citySlug,
    bool active,
    String? priceMinBs,
    String? priceMaxBs,
    String? commissionPct,
    String effectivePriceMinBs,
    String effectivePriceMaxBs,
    String effectiveCommissionPct,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminCategoryCityDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminCategoryCityDto.copyWith.fieldName(...)`
class _$AdminCategoryCityDtoCWProxyImpl
    implements _$AdminCategoryCityDtoCWProxy {
  const _$AdminCategoryCityDtoCWProxyImpl(this._value);

  final AdminCategoryCityDto _value;

  @override
  AdminCategoryCityDto cityId(String cityId) => this(cityId: cityId);

  @override
  AdminCategoryCityDto citySlug(String citySlug) => this(citySlug: citySlug);

  @override
  AdminCategoryCityDto active(bool active) => this(active: active);

  @override
  AdminCategoryCityDto priceMinBs(String? priceMinBs) =>
      this(priceMinBs: priceMinBs);

  @override
  AdminCategoryCityDto priceMaxBs(String? priceMaxBs) =>
      this(priceMaxBs: priceMaxBs);

  @override
  AdminCategoryCityDto commissionPct(String? commissionPct) =>
      this(commissionPct: commissionPct);

  @override
  AdminCategoryCityDto effectivePriceMinBs(String effectivePriceMinBs) =>
      this(effectivePriceMinBs: effectivePriceMinBs);

  @override
  AdminCategoryCityDto effectivePriceMaxBs(String effectivePriceMaxBs) =>
      this(effectivePriceMaxBs: effectivePriceMaxBs);

  @override
  AdminCategoryCityDto effectiveCommissionPct(String effectiveCommissionPct) =>
      this(effectiveCommissionPct: effectiveCommissionPct);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCategoryCityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCategoryCityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCategoryCityDto call({
    Object? cityId = const $CopyWithPlaceholder(),
    Object? citySlug = const $CopyWithPlaceholder(),
    Object? active = const $CopyWithPlaceholder(),
    Object? priceMinBs = const $CopyWithPlaceholder(),
    Object? priceMaxBs = const $CopyWithPlaceholder(),
    Object? commissionPct = const $CopyWithPlaceholder(),
    Object? effectivePriceMinBs = const $CopyWithPlaceholder(),
    Object? effectivePriceMaxBs = const $CopyWithPlaceholder(),
    Object? effectiveCommissionPct = const $CopyWithPlaceholder(),
  }) {
    return AdminCategoryCityDto(
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      citySlug: citySlug == const $CopyWithPlaceholder()
          ? _value.citySlug
          // ignore: cast_nullable_to_non_nullable
          : citySlug as String,
      active: active == const $CopyWithPlaceholder()
          ? _value.active
          // ignore: cast_nullable_to_non_nullable
          : active as bool,
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
      effectivePriceMinBs: effectivePriceMinBs == const $CopyWithPlaceholder()
          ? _value.effectivePriceMinBs
          // ignore: cast_nullable_to_non_nullable
          : effectivePriceMinBs as String,
      effectivePriceMaxBs: effectivePriceMaxBs == const $CopyWithPlaceholder()
          ? _value.effectivePriceMaxBs
          // ignore: cast_nullable_to_non_nullable
          : effectivePriceMaxBs as String,
      effectiveCommissionPct:
          effectiveCommissionPct == const $CopyWithPlaceholder()
          ? _value.effectiveCommissionPct
          // ignore: cast_nullable_to_non_nullable
          : effectiveCommissionPct as String,
    );
  }
}

extension $AdminCategoryCityDtoCopyWith on AdminCategoryCityDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminCategoryCityDto.copyWith(...)` or like so:`instanceOfAdminCategoryCityDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminCategoryCityDtoCWProxy get copyWith =>
      _$AdminCategoryCityDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCategoryCityDto _$AdminCategoryCityDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminCategoryCityDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'cityId',
      'citySlug',
      'active',
      'priceMinBs',
      'priceMaxBs',
      'commissionPct',
      'effectivePriceMinBs',
      'effectivePriceMaxBs',
      'effectiveCommissionPct',
    ],
  );
  final val = AdminCategoryCityDto(
    cityId: $checkedConvert('cityId', (v) => v as String),
    citySlug: $checkedConvert('citySlug', (v) => v as String),
    active: $checkedConvert('active', (v) => v as bool),
    priceMinBs: $checkedConvert('priceMinBs', (v) => v as String?),
    priceMaxBs: $checkedConvert('priceMaxBs', (v) => v as String?),
    commissionPct: $checkedConvert('commissionPct', (v) => v as String?),
    effectivePriceMinBs: $checkedConvert(
      'effectivePriceMinBs',
      (v) => v as String,
    ),
    effectivePriceMaxBs: $checkedConvert(
      'effectivePriceMaxBs',
      (v) => v as String,
    ),
    effectiveCommissionPct: $checkedConvert(
      'effectiveCommissionPct',
      (v) => v as String,
    ),
  );
  return val;
});

Map<String, dynamic> _$AdminCategoryCityDtoToJson(
  AdminCategoryCityDto instance,
) => <String, dynamic>{
  'cityId': instance.cityId,
  'citySlug': instance.citySlug,
  'active': instance.active,
  'priceMinBs': instance.priceMinBs,
  'priceMaxBs': instance.priceMaxBs,
  'commissionPct': instance.commissionPct,
  'effectivePriceMinBs': instance.effectivePriceMinBs,
  'effectivePriceMaxBs': instance.effectivePriceMaxBs,
  'effectiveCommissionPct': instance.effectiveCommissionPct,
};

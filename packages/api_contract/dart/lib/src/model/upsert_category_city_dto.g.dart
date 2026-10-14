// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_category_city_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UpsertCategoryCityDtoCWProxy {
  UpsertCategoryCityDto active(bool active);

  UpsertCategoryCityDto priceMinBs(String? priceMinBs);

  UpsertCategoryCityDto priceMaxBs(String? priceMaxBs);

  UpsertCategoryCityDto commissionPct(String? commissionPct);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpsertCategoryCityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpsertCategoryCityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpsertCategoryCityDto call({
    bool active,
    String? priceMinBs,
    String? priceMaxBs,
    String? commissionPct,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUpsertCategoryCityDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUpsertCategoryCityDto.copyWith.fieldName(...)`
class _$UpsertCategoryCityDtoCWProxyImpl
    implements _$UpsertCategoryCityDtoCWProxy {
  const _$UpsertCategoryCityDtoCWProxyImpl(this._value);

  final UpsertCategoryCityDto _value;

  @override
  UpsertCategoryCityDto active(bool active) => this(active: active);

  @override
  UpsertCategoryCityDto priceMinBs(String? priceMinBs) =>
      this(priceMinBs: priceMinBs);

  @override
  UpsertCategoryCityDto priceMaxBs(String? priceMaxBs) =>
      this(priceMaxBs: priceMaxBs);

  @override
  UpsertCategoryCityDto commissionPct(String? commissionPct) =>
      this(commissionPct: commissionPct);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UpsertCategoryCityDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UpsertCategoryCityDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UpsertCategoryCityDto call({
    Object? active = const $CopyWithPlaceholder(),
    Object? priceMinBs = const $CopyWithPlaceholder(),
    Object? priceMaxBs = const $CopyWithPlaceholder(),
    Object? commissionPct = const $CopyWithPlaceholder(),
  }) {
    return UpsertCategoryCityDto(
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
    );
  }
}

extension $UpsertCategoryCityDtoCopyWith on UpsertCategoryCityDto {
  /// Returns a callable class that can be used as follows: `instanceOfUpsertCategoryCityDto.copyWith(...)` or like so:`instanceOfUpsertCategoryCityDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UpsertCategoryCityDtoCWProxy get copyWith =>
      _$UpsertCategoryCityDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertCategoryCityDto _$UpsertCategoryCityDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UpsertCategoryCityDto', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['active']);
  final val = UpsertCategoryCityDto(
    active: $checkedConvert('active', (v) => v as bool),
    priceMinBs: $checkedConvert('priceMinBs', (v) => v as String?),
    priceMaxBs: $checkedConvert('priceMaxBs', (v) => v as String?),
    commissionPct: $checkedConvert('commissionPct', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$UpsertCategoryCityDtoToJson(
  UpsertCategoryCityDto instance,
) => <String, dynamic>{
  'active': instance.active,
  'priceMinBs': ?instance.priceMinBs,
  'priceMaxBs': ?instance.priceMaxBs,
  'commissionPct': ?instance.commissionPct,
};

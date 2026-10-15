// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_range_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PriceRangeDtoCWProxy {
  PriceRangeDto minBs(String minBs);

  PriceRangeDto maxBs(String maxBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PriceRangeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PriceRangeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PriceRangeDto call({String minBs, String maxBs});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPriceRangeDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPriceRangeDto.copyWith.fieldName(...)`
class _$PriceRangeDtoCWProxyImpl implements _$PriceRangeDtoCWProxy {
  const _$PriceRangeDtoCWProxyImpl(this._value);

  final PriceRangeDto _value;

  @override
  PriceRangeDto minBs(String minBs) => this(minBs: minBs);

  @override
  PriceRangeDto maxBs(String maxBs) => this(maxBs: maxBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PriceRangeDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PriceRangeDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PriceRangeDto call({
    Object? minBs = const $CopyWithPlaceholder(),
    Object? maxBs = const $CopyWithPlaceholder(),
  }) {
    return PriceRangeDto(
      minBs: minBs == const $CopyWithPlaceholder()
          ? _value.minBs
          // ignore: cast_nullable_to_non_nullable
          : minBs as String,
      maxBs: maxBs == const $CopyWithPlaceholder()
          ? _value.maxBs
          // ignore: cast_nullable_to_non_nullable
          : maxBs as String,
    );
  }
}

extension $PriceRangeDtoCopyWith on PriceRangeDto {
  /// Returns a callable class that can be used as follows: `instanceOfPriceRangeDto.copyWith(...)` or like so:`instanceOfPriceRangeDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PriceRangeDtoCWProxy get copyWith => _$PriceRangeDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRangeDto _$PriceRangeDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PriceRangeDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['minBs', 'maxBs']);
      final val = PriceRangeDto(
        minBs: $checkedConvert('minBs', (v) => v as String),
        maxBs: $checkedConvert('maxBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PriceRangeDtoToJson(PriceRangeDto instance) =>
    <String, dynamic>{'minBs': instance.minBs, 'maxBs': instance.maxBs};

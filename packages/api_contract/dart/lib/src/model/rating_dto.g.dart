// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RatingDtoCWProxy {
  RatingDto avg(String avg);

  RatingDto count(num count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RatingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RatingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RatingDto call({String avg, num count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRatingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRatingDto.copyWith.fieldName(...)`
class _$RatingDtoCWProxyImpl implements _$RatingDtoCWProxy {
  const _$RatingDtoCWProxyImpl(this._value);

  final RatingDto _value;

  @override
  RatingDto avg(String avg) => this(avg: avg);

  @override
  RatingDto count(num count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RatingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RatingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RatingDto call({
    Object? avg = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
  }) {
    return RatingDto(
      avg: avg == const $CopyWithPlaceholder()
          ? _value.avg
          // ignore: cast_nullable_to_non_nullable
          : avg as String,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as num,
    );
  }
}

extension $RatingDtoCopyWith on RatingDto {
  /// Returns a callable class that can be used as follows: `instanceOfRatingDto.copyWith(...)` or like so:`instanceOfRatingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RatingDtoCWProxy get copyWith => _$RatingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingDto _$RatingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RatingDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['avg', 'count']);
      final val = RatingDto(
        avg: $checkedConvert('avg', (v) => v as String),
        count: $checkedConvert('count', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$RatingDtoToJson(RatingDto instance) => <String, dynamic>{
  'avg': instance.avg,
  'count': instance.count,
};

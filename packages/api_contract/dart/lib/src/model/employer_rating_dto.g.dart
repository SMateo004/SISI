// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_rating_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EmployerRatingDtoCWProxy {
  EmployerRatingDto ratingAvg(String ratingAvg);

  EmployerRatingDto ratingCount(num ratingCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmployerRatingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmployerRatingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  EmployerRatingDto call({String ratingAvg, num ratingCount});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEmployerRatingDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEmployerRatingDto.copyWith.fieldName(...)`
class _$EmployerRatingDtoCWProxyImpl implements _$EmployerRatingDtoCWProxy {
  const _$EmployerRatingDtoCWProxyImpl(this._value);

  final EmployerRatingDto _value;

  @override
  EmployerRatingDto ratingAvg(String ratingAvg) => this(ratingAvg: ratingAvg);

  @override
  EmployerRatingDto ratingCount(num ratingCount) =>
      this(ratingCount: ratingCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmployerRatingDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmployerRatingDto(...).copyWith(id: 12, name: "My name")
  /// ````
  EmployerRatingDto call({
    Object? ratingAvg = const $CopyWithPlaceholder(),
    Object? ratingCount = const $CopyWithPlaceholder(),
  }) {
    return EmployerRatingDto(
      ratingAvg: ratingAvg == const $CopyWithPlaceholder()
          ? _value.ratingAvg
          // ignore: cast_nullable_to_non_nullable
          : ratingAvg as String,
      ratingCount: ratingCount == const $CopyWithPlaceholder()
          ? _value.ratingCount
          // ignore: cast_nullable_to_non_nullable
          : ratingCount as num,
    );
  }
}

extension $EmployerRatingDtoCopyWith on EmployerRatingDto {
  /// Returns a callable class that can be used as follows: `instanceOfEmployerRatingDto.copyWith(...)` or like so:`instanceOfEmployerRatingDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EmployerRatingDtoCWProxy get copyWith =>
      _$EmployerRatingDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployerRatingDto _$EmployerRatingDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EmployerRatingDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['ratingAvg', 'ratingCount']);
      final val = EmployerRatingDto(
        ratingAvg: $checkedConvert('ratingAvg', (v) => v as String),
        ratingCount: $checkedConvert('ratingCount', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$EmployerRatingDtoToJson(EmployerRatingDto instance) =>
    <String, dynamic>{
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
    };

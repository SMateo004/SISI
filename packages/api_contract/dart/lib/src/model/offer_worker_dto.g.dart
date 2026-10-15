// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_worker_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OfferWorkerDtoCWProxy {
  OfferWorkerDto shortName(String shortName);

  OfferWorkerDto ratingAvg(String ratingAvg);

  OfferWorkerDto ratingCount(num ratingCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferWorkerDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferWorkerDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferWorkerDto call({String shortName, String ratingAvg, num ratingCount});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOfferWorkerDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOfferWorkerDto.copyWith.fieldName(...)`
class _$OfferWorkerDtoCWProxyImpl implements _$OfferWorkerDtoCWProxy {
  const _$OfferWorkerDtoCWProxyImpl(this._value);

  final OfferWorkerDto _value;

  @override
  OfferWorkerDto shortName(String shortName) => this(shortName: shortName);

  @override
  OfferWorkerDto ratingAvg(String ratingAvg) => this(ratingAvg: ratingAvg);

  @override
  OfferWorkerDto ratingCount(num ratingCount) => this(ratingCount: ratingCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OfferWorkerDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OfferWorkerDto(...).copyWith(id: 12, name: "My name")
  /// ````
  OfferWorkerDto call({
    Object? shortName = const $CopyWithPlaceholder(),
    Object? ratingAvg = const $CopyWithPlaceholder(),
    Object? ratingCount = const $CopyWithPlaceholder(),
  }) {
    return OfferWorkerDto(
      shortName: shortName == const $CopyWithPlaceholder()
          ? _value.shortName
          // ignore: cast_nullable_to_non_nullable
          : shortName as String,
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

extension $OfferWorkerDtoCopyWith on OfferWorkerDto {
  /// Returns a callable class that can be used as follows: `instanceOfOfferWorkerDto.copyWith(...)` or like so:`instanceOfOfferWorkerDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OfferWorkerDtoCWProxy get copyWith => _$OfferWorkerDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferWorkerDto _$OfferWorkerDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OfferWorkerDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['shortName', 'ratingAvg', 'ratingCount'],
      );
      final val = OfferWorkerDto(
        shortName: $checkedConvert('shortName', (v) => v as String),
        ratingAvg: $checkedConvert('ratingAvg', (v) => v as String),
        ratingCount: $checkedConvert('ratingCount', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$OfferWorkerDtoToJson(OfferWorkerDto instance) =>
    <String, dynamic>{
      'shortName': instance.shortName,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_reviews_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserReviewsDtoCWProxy {
  UserReviewsDto ratingAvg(String ratingAvg);

  UserReviewsDto ratingCount(num ratingCount);

  UserReviewsDto items(List<PublicReviewDto> items);

  UserReviewsDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserReviewsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserReviewsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserReviewsDto call({
    String ratingAvg,
    num ratingCount,
    List<PublicReviewDto> items,
    String? nextCursor,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserReviewsDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserReviewsDto.copyWith.fieldName(...)`
class _$UserReviewsDtoCWProxyImpl implements _$UserReviewsDtoCWProxy {
  const _$UserReviewsDtoCWProxyImpl(this._value);

  final UserReviewsDto _value;

  @override
  UserReviewsDto ratingAvg(String ratingAvg) => this(ratingAvg: ratingAvg);

  @override
  UserReviewsDto ratingCount(num ratingCount) => this(ratingCount: ratingCount);

  @override
  UserReviewsDto items(List<PublicReviewDto> items) => this(items: items);

  @override
  UserReviewsDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserReviewsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserReviewsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserReviewsDto call({
    Object? ratingAvg = const $CopyWithPlaceholder(),
    Object? ratingCount = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return UserReviewsDto(
      ratingAvg: ratingAvg == const $CopyWithPlaceholder()
          ? _value.ratingAvg
          // ignore: cast_nullable_to_non_nullable
          : ratingAvg as String,
      ratingCount: ratingCount == const $CopyWithPlaceholder()
          ? _value.ratingCount
          // ignore: cast_nullable_to_non_nullable
          : ratingCount as num,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PublicReviewDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $UserReviewsDtoCopyWith on UserReviewsDto {
  /// Returns a callable class that can be used as follows: `instanceOfUserReviewsDto.copyWith(...)` or like so:`instanceOfUserReviewsDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserReviewsDtoCWProxy get copyWith => _$UserReviewsDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReviewsDto _$UserReviewsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserReviewsDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['ratingAvg', 'ratingCount', 'items', 'nextCursor'],
      );
      final val = UserReviewsDto(
        ratingAvg: $checkedConvert('ratingAvg', (v) => v as String),
        ratingCount: $checkedConvert('ratingCount', (v) => v as num),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => PublicReviewDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$UserReviewsDtoToJson(UserReviewsDto instance) =>
    <String, dynamic>{
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };

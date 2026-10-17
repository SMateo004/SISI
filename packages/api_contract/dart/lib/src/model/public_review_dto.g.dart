// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_review_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PublicReviewDtoCWProxy {
  PublicReviewDto id(String id);

  PublicReviewDto stars(num stars);

  PublicReviewDto comment(String? comment);

  PublicReviewDto reviewerShortName(String reviewerShortName);

  PublicReviewDto publishedAt(DateTime publishedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicReviewDto call({
    String id,
    num stars,
    String? comment,
    String reviewerShortName,
    DateTime publishedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPublicReviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPublicReviewDto.copyWith.fieldName(...)`
class _$PublicReviewDtoCWProxyImpl implements _$PublicReviewDtoCWProxy {
  const _$PublicReviewDtoCWProxyImpl(this._value);

  final PublicReviewDto _value;

  @override
  PublicReviewDto id(String id) => this(id: id);

  @override
  PublicReviewDto stars(num stars) => this(stars: stars);

  @override
  PublicReviewDto comment(String? comment) => this(comment: comment);

  @override
  PublicReviewDto reviewerShortName(String reviewerShortName) =>
      this(reviewerShortName: reviewerShortName);

  @override
  PublicReviewDto publishedAt(DateTime publishedAt) =>
      this(publishedAt: publishedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicReviewDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? stars = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? reviewerShortName = const $CopyWithPlaceholder(),
    Object? publishedAt = const $CopyWithPlaceholder(),
  }) {
    return PublicReviewDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      stars: stars == const $CopyWithPlaceholder()
          ? _value.stars
          // ignore: cast_nullable_to_non_nullable
          : stars as num,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      reviewerShortName: reviewerShortName == const $CopyWithPlaceholder()
          ? _value.reviewerShortName
          // ignore: cast_nullable_to_non_nullable
          : reviewerShortName as String,
      publishedAt: publishedAt == const $CopyWithPlaceholder()
          ? _value.publishedAt
          // ignore: cast_nullable_to_non_nullable
          : publishedAt as DateTime,
    );
  }
}

extension $PublicReviewDtoCopyWith on PublicReviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfPublicReviewDto.copyWith(...)` or like so:`instanceOfPublicReviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PublicReviewDtoCWProxy get copyWith => _$PublicReviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicReviewDto _$PublicReviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PublicReviewDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'stars',
          'comment',
          'reviewerShortName',
          'publishedAt',
        ],
      );
      final val = PublicReviewDto(
        id: $checkedConvert('id', (v) => v as String),
        stars: $checkedConvert('stars', (v) => v as num),
        comment: $checkedConvert('comment', (v) => v as String?),
        reviewerShortName: $checkedConvert(
          'reviewerShortName',
          (v) => v as String,
        ),
        publishedAt: $checkedConvert(
          'publishedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PublicReviewDtoToJson(PublicReviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stars': instance.stars,
      'comment': instance.comment,
      'reviewerShortName': instance.reviewerShortName,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };

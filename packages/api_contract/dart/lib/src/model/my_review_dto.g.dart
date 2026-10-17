// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_review_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyReviewDtoCWProxy {
  MyReviewDto stars(num stars);

  MyReviewDto comment(String? comment);

  MyReviewDto commentHeld(bool commentHeld);

  MyReviewDto published(bool published);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MyReviewDto call({
    num stars,
    String? comment,
    bool commentHeld,
    bool published,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyReviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyReviewDto.copyWith.fieldName(...)`
class _$MyReviewDtoCWProxyImpl implements _$MyReviewDtoCWProxy {
  const _$MyReviewDtoCWProxyImpl(this._value);

  final MyReviewDto _value;

  @override
  MyReviewDto stars(num stars) => this(stars: stars);

  @override
  MyReviewDto comment(String? comment) => this(comment: comment);

  @override
  MyReviewDto commentHeld(bool commentHeld) => this(commentHeld: commentHeld);

  @override
  MyReviewDto published(bool published) => this(published: published);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  MyReviewDto call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
    Object? commentHeld = const $CopyWithPlaceholder(),
    Object? published = const $CopyWithPlaceholder(),
  }) {
    return MyReviewDto(
      stars: stars == const $CopyWithPlaceholder()
          ? _value.stars
          // ignore: cast_nullable_to_non_nullable
          : stars as num,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
      commentHeld: commentHeld == const $CopyWithPlaceholder()
          ? _value.commentHeld
          // ignore: cast_nullable_to_non_nullable
          : commentHeld as bool,
      published: published == const $CopyWithPlaceholder()
          ? _value.published
          // ignore: cast_nullable_to_non_nullable
          : published as bool,
    );
  }
}

extension $MyReviewDtoCopyWith on MyReviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfMyReviewDto.copyWith(...)` or like so:`instanceOfMyReviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MyReviewDtoCWProxy get copyWith => _$MyReviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyReviewDto _$MyReviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MyReviewDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['stars', 'comment', 'commentHeld', 'published'],
      );
      final val = MyReviewDto(
        stars: $checkedConvert('stars', (v) => v as num),
        comment: $checkedConvert('comment', (v) => v as String?),
        commentHeld: $checkedConvert('commentHeld', (v) => v as bool),
        published: $checkedConvert('published', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$MyReviewDtoToJson(MyReviewDto instance) =>
    <String, dynamic>{
      'stars': instance.stars,
      'comment': instance.comment,
      'commentHeld': instance.commentHeld,
      'published': instance.published,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateReviewDtoCWProxy {
  CreateReviewDto stars(num stars);

  CreateReviewDto comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateReviewDto call({num stars, String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateReviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateReviewDto.copyWith.fieldName(...)`
class _$CreateReviewDtoCWProxyImpl implements _$CreateReviewDtoCWProxy {
  const _$CreateReviewDtoCWProxyImpl(this._value);

  final CreateReviewDto _value;

  @override
  CreateReviewDto stars(num stars) => this(stars: stars);

  @override
  CreateReviewDto comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateReviewDto call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return CreateReviewDto(
      stars: stars == const $CopyWithPlaceholder()
          ? _value.stars
          // ignore: cast_nullable_to_non_nullable
          : stars as num,
      comment: comment == const $CopyWithPlaceholder()
          ? _value.comment
          // ignore: cast_nullable_to_non_nullable
          : comment as String?,
    );
  }
}

extension $CreateReviewDtoCopyWith on CreateReviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateReviewDto.copyWith(...)` or like so:`instanceOfCreateReviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateReviewDtoCWProxy get copyWith => _$CreateReviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReviewDto _$CreateReviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateReviewDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['stars']);
      final val = CreateReviewDto(
        stars: $checkedConvert('stars', (v) => v as num),
        comment: $checkedConvert('comment', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$CreateReviewDtoToJson(CreateReviewDto instance) =>
    <String, dynamic>{'stars': instance.stars, 'comment': ?instance.comment};

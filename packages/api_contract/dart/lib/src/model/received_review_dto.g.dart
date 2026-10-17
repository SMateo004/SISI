// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'received_review_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReceivedReviewDtoCWProxy {
  ReceivedReviewDto stars(num stars);

  ReceivedReviewDto comment(String? comment);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReceivedReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReceivedReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReceivedReviewDto call({num stars, String? comment});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReceivedReviewDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReceivedReviewDto.copyWith.fieldName(...)`
class _$ReceivedReviewDtoCWProxyImpl implements _$ReceivedReviewDtoCWProxy {
  const _$ReceivedReviewDtoCWProxyImpl(this._value);

  final ReceivedReviewDto _value;

  @override
  ReceivedReviewDto stars(num stars) => this(stars: stars);

  @override
  ReceivedReviewDto comment(String? comment) => this(comment: comment);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReceivedReviewDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReceivedReviewDto(...).copyWith(id: 12, name: "My name")
  /// ````
  ReceivedReviewDto call({
    Object? stars = const $CopyWithPlaceholder(),
    Object? comment = const $CopyWithPlaceholder(),
  }) {
    return ReceivedReviewDto(
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

extension $ReceivedReviewDtoCopyWith on ReceivedReviewDto {
  /// Returns a callable class that can be used as follows: `instanceOfReceivedReviewDto.copyWith(...)` or like so:`instanceOfReceivedReviewDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReceivedReviewDtoCWProxy get copyWith =>
      _$ReceivedReviewDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceivedReviewDto _$ReceivedReviewDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReceivedReviewDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['stars', 'comment']);
      final val = ReceivedReviewDto(
        stars: $checkedConvert('stars', (v) => v as num),
        comment: $checkedConvert('comment', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ReceivedReviewDtoToJson(ReceivedReviewDto instance) =>
    <String, dynamic>{'stars': instance.stars, 'comment': instance.comment};

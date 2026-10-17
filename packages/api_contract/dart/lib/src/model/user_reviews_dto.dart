//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/public_review_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_reviews_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserReviewsDto {
  /// Returns a new [UserReviewsDto] instance.
  UserReviewsDto({

    required  this.ratingAvg,

    required  this.ratingCount,

    required  this.items,

    required  this.nextCursor,
  });

  @JsonKey(
    
    name: r'ratingAvg',
    required: true,
    includeIfNull: false,
  )


  final String ratingAvg;



  @JsonKey(
    
    name: r'ratingCount',
    required: true,
    includeIfNull: false,
  )


  final num ratingCount;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<PublicReviewDto> items;



  @JsonKey(
    
    name: r'nextCursor',
    required: true,
    includeIfNull: true,
  )


  final String? nextCursor;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserReviewsDto &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount &&
      other.items == items &&
      other.nextCursor == nextCursor;

    @override
    int get hashCode =>
        ratingAvg.hashCode +
        ratingCount.hashCode +
        items.hashCode +
        (nextCursor == null ? 0 : nextCursor.hashCode);

  factory UserReviewsDto.fromJson(Map<String, dynamic> json) => _$UserReviewsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserReviewsDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


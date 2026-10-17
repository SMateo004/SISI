//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_review_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PublicReviewDto {
  /// Returns a new [PublicReviewDto] instance.
  PublicReviewDto({

    required  this.id,

    required  this.stars,

    required  this.comment,

    required  this.reviewerShortName,

    required  this.publishedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final num stars;



  @JsonKey(
    
    name: r'comment',
    required: true,
    includeIfNull: true,
  )


  final String? comment;



  @JsonKey(
    
    name: r'reviewerShortName',
    required: true,
    includeIfNull: false,
  )


  final String reviewerShortName;



  @JsonKey(
    
    name: r'publishedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime publishedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PublicReviewDto &&
      other.id == id &&
      other.stars == stars &&
      other.comment == comment &&
      other.reviewerShortName == reviewerShortName &&
      other.publishedAt == publishedAt;

    @override
    int get hashCode =>
        id.hashCode +
        stars.hashCode +
        (comment == null ? 0 : comment.hashCode) +
        reviewerShortName.hashCode +
        publishedAt.hashCode;

  factory PublicReviewDto.fromJson(Map<String, dynamic> json) => _$PublicReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PublicReviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


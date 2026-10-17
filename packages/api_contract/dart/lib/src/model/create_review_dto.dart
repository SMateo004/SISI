//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_review_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateReviewDto {
  /// Returns a new [CreateReviewDto] instance.
  CreateReviewDto({

    required  this.stars,

     this.comment,
  });

          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final num stars;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateReviewDto &&
      other.stars == stars &&
      other.comment == comment;

    @override
    int get hashCode =>
        stars.hashCode +
        comment.hashCode;

  factory CreateReviewDto.fromJson(Map<String, dynamic> json) => _$CreateReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


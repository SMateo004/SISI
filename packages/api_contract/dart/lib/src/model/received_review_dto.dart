//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'received_review_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReceivedReviewDto {
  /// Returns a new [ReceivedReviewDto] instance.
  ReceivedReviewDto({

    required  this.stars,

    required  this.comment,
  });

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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReceivedReviewDto &&
      other.stars == stars &&
      other.comment == comment;

    @override
    int get hashCode =>
        stars.hashCode +
        (comment == null ? 0 : comment.hashCode);

  factory ReceivedReviewDto.fromJson(Map<String, dynamic> json) => _$ReceivedReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReceivedReviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


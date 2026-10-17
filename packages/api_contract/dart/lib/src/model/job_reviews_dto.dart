//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/received_review_dto.dart';
import 'package:sisi_api/src/model/my_review_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_reviews_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobReviewsDto {
  /// Returns a new [JobReviewsDto] instance.
  JobReviewsDto({

    required  this.canReview,

    required  this.deadline,

    required  this.mine,

    required  this.theirs,
  });

      /// Puedo calificar ahora
  @JsonKey(
    
    name: r'canReview',
    required: true,
    includeIfNull: false,
  )


  final bool canReview;



  @JsonKey(
    
    name: r'deadline',
    required: true,
    includeIfNull: true,
  )


  final DateTime? deadline;



  @JsonKey(
    
    name: r'mine',
    required: true,
    includeIfNull: true,
  )


  final MyReviewDto? mine;



  @JsonKey(
    
    name: r'theirs',
    required: true,
    includeIfNull: true,
  )


  final ReceivedReviewDto? theirs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobReviewsDto &&
      other.canReview == canReview &&
      other.deadline == deadline &&
      other.mine == mine &&
      other.theirs == theirs;

    @override
    int get hashCode =>
        canReview.hashCode +
        (deadline == null ? 0 : deadline.hashCode) +
        (mine == null ? 0 : mine.hashCode) +
        (theirs == null ? 0 : theirs.hashCode);

  factory JobReviewsDto.fromJson(Map<String, dynamic> json) => _$JobReviewsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobReviewsDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


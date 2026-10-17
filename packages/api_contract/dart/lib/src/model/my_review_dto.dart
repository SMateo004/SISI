//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_review_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MyReviewDto {
  /// Returns a new [MyReviewDto] instance.
  MyReviewDto({

    required  this.stars,

    required  this.comment,

    required  this.commentHeld,

    required  this.published,
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



      /// El comentario quedó retenido por moderación (no se publica)
  @JsonKey(
    
    name: r'commentHeld',
    required: true,
    includeIfNull: false,
  )


  final bool commentHeld;



      /// Ya es visible (calificaron ambos o venció el plazo)
  @JsonKey(
    
    name: r'published',
    required: true,
    includeIfNull: false,
  )


  final bool published;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MyReviewDto &&
      other.stars == stars &&
      other.comment == comment &&
      other.commentHeld == commentHeld &&
      other.published == published;

    @override
    int get hashCode =>
        stars.hashCode +
        (comment == null ? 0 : comment.hashCode) +
        commentHeld.hashCode +
        published.hashCode;

  factory MyReviewDto.fromJson(Map<String, dynamic> json) => _$MyReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MyReviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


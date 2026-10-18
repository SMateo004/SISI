//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RatingDto {
  /// Returns a new [RatingDto] instance.
  RatingDto({

    required  this.avg,

    required  this.count,
  });

  @JsonKey(
    
    name: r'avg',
    required: true,
    includeIfNull: false,
  )


  final String avg;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final num count;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RatingDto &&
      other.avg == avg &&
      other.count == count;

    @override
    int get hashCode =>
        avg.hashCode +
        count.hashCode;

  factory RatingDto.fromJson(Map<String, dynamic> json) => _$RatingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RatingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


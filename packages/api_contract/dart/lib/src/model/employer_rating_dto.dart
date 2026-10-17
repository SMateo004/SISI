//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employer_rating_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EmployerRatingDto {
  /// Returns a new [EmployerRatingDto] instance.
  EmployerRatingDto({

    required  this.ratingAvg,

    required  this.ratingCount,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is EmployerRatingDto &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount;

    @override
    int get hashCode =>
        ratingAvg.hashCode +
        ratingCount.hashCode;

  factory EmployerRatingDto.fromJson(Map<String, dynamic> json) => _$EmployerRatingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerRatingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


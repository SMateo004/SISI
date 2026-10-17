//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobCategoryDto {
  /// Returns a new [JobCategoryDto] instance.
  JobCategoryDto({

    required  this.slug,

    required  this.name,
  });

  @JsonKey(
    
    name: r'slug',
    required: true,
    includeIfNull: false,
  )


  final String slug;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobCategoryDto &&
      other.slug == slug &&
      other.name == name;

    @override
    int get hashCode =>
        slug.hashCode +
        name.hashCode;

  factory JobCategoryDto.fromJson(Map<String, dynamic> json) => _$JobCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobCategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestCategoryDto {
  /// Returns a new [RequestCategoryDto] instance.
  RequestCategoryDto({

    required  this.id,

    required  this.slug,

    required  this.name,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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
    bool operator ==(Object other) => identical(this, other) || other is RequestCategoryDto &&
      other.id == id &&
      other.slug == slug &&
      other.name == name;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        name.hashCode;

  factory RequestCategoryDto.fromJson(Map<String, dynamic> json) => _$RequestCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestCategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


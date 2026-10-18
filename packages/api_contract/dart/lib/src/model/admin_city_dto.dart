//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_city_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminCityDto {
  /// Returns a new [AdminCityDto] instance.
  AdminCityDto({

    required  this.id,

    required  this.slug,

    required  this.name,

    required  this.timezone,

    required  this.active,
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



  @JsonKey(
    
    name: r'timezone',
    required: true,
    includeIfNull: false,
  )


  final String timezone;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminCityDto &&
      other.id == id &&
      other.slug == slug &&
      other.name == name &&
      other.timezone == timezone &&
      other.active == active;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        name.hashCode +
        timezone.hashCode +
        active.hashCode;

  factory AdminCityDto.fromJson(Map<String, dynamic> json) => _$AdminCityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminCityDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


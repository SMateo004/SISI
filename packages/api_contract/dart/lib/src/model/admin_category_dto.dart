//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/admin_category_city_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminCategoryDto {
  /// Returns a new [AdminCategoryDto] instance.
  AdminCategoryDto({

    required  this.id,

    required  this.slug,

    required  this.name,

    required  this.description,

    required  this.priceMinBs,

    required  this.priceMaxBs,

    required  this.commissionPct,

    required  this.active,

    required  this.cities,
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
    
    name: r'description',
    required: true,
    includeIfNull: true,
  )


  final String? description;



  @JsonKey(
    
    name: r'priceMinBs',
    required: true,
    includeIfNull: false,
  )


  final String priceMinBs;



  @JsonKey(
    
    name: r'priceMaxBs',
    required: true,
    includeIfNull: false,
  )


  final String priceMaxBs;



  @JsonKey(
    
    name: r'commissionPct',
    required: true,
    includeIfNull: false,
  )


  final String commissionPct;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    
    name: r'cities',
    required: true,
    includeIfNull: false,
  )


  final List<AdminCategoryCityDto> cities;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminCategoryDto &&
      other.id == id &&
      other.slug == slug &&
      other.name == name &&
      other.description == description &&
      other.priceMinBs == priceMinBs &&
      other.priceMaxBs == priceMaxBs &&
      other.commissionPct == commissionPct &&
      other.active == active &&
      other.cities == cities;

    @override
    int get hashCode =>
        id.hashCode +
        slug.hashCode +
        name.hashCode +
        (description == null ? 0 : description.hashCode) +
        priceMinBs.hashCode +
        priceMaxBs.hashCode +
        commissionPct.hashCode +
        active.hashCode +
        cities.hashCode;

  factory AdminCategoryDto.fromJson(Map<String, dynamic> json) => _$AdminCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminCategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateCategoryDto {
  /// Returns a new [CreateCategoryDto] instance.
  CreateCategoryDto({

    required  this.slug,

    required  this.name,

     this.description,

    required  this.priceMinBs,

    required  this.priceMaxBs,

     this.commissionPct,

     this.extraRequirements,

     this.cityIds,

     this.reason,
  });

      /// Identificador estable: no cambia después
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
    required: false,
    includeIfNull: false,
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



      /// Por defecto 13 % (R2.2)
  @JsonKey(
    
    name: r'commissionPct',
    required: false,
    includeIfNull: false,
  )


  final String? commissionPct;



      /// Requisitos extra de verificación (claves en minúsculas, R2.2)
  @JsonKey(
    
    name: r'extraRequirements',
    required: false,
    includeIfNull: false,
  )


  final List<String>? extraRequirements;



      /// Ciudades donde queda activa
  @JsonKey(
    
    name: r'cityIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? cityIds;



      /// Motivo (queda en la auditoría)
  @JsonKey(
    
    name: r'reason',
    required: false,
    includeIfNull: false,
  )


  final String? reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateCategoryDto &&
      other.slug == slug &&
      other.name == name &&
      other.description == description &&
      other.priceMinBs == priceMinBs &&
      other.priceMaxBs == priceMaxBs &&
      other.commissionPct == commissionPct &&
      other.extraRequirements == extraRequirements &&
      other.cityIds == cityIds &&
      other.reason == reason;

    @override
    int get hashCode =>
        slug.hashCode +
        name.hashCode +
        (description == null ? 0 : description.hashCode) +
        priceMinBs.hashCode +
        priceMaxBs.hashCode +
        commissionPct.hashCode +
        extraRequirements.hashCode +
        cityIds.hashCode +
        reason.hashCode;

  factory CreateCategoryDto.fromJson(Map<String, dynamic> json) => _$CreateCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


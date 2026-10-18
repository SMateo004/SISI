//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateCategoryDto {
  /// Returns a new [UpdateCategoryDto] instance.
  UpdateCategoryDto({

     this.name,

     this.description,

     this.priceMinBs,

     this.priceMaxBs,

     this.commissionPct,

     this.active,

     this.extraRequirements,

     this.reason,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'priceMinBs',
    required: false,
    includeIfNull: false,
  )


  final String? priceMinBs;



  @JsonKey(
    
    name: r'priceMaxBs',
    required: false,
    includeIfNull: false,
  )


  final String? priceMaxBs;



  @JsonKey(
    
    name: r'commissionPct',
    required: false,
    includeIfNull: false,
  )


  final String? commissionPct;



  @JsonKey(
    
    name: r'active',
    required: false,
    includeIfNull: false,
  )


  final bool? active;



      /// Requisitos extra de verificación (claves en minúsculas, R2.2)
  @JsonKey(
    
    name: r'extraRequirements',
    required: false,
    includeIfNull: false,
  )


  final List<String>? extraRequirements;



      /// Motivo (queda en la auditoría)
  @JsonKey(
    
    name: r'reason',
    required: false,
    includeIfNull: false,
  )


  final String? reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateCategoryDto &&
      other.name == name &&
      other.description == description &&
      other.priceMinBs == priceMinBs &&
      other.priceMaxBs == priceMaxBs &&
      other.commissionPct == commissionPct &&
      other.active == active &&
      other.extraRequirements == extraRequirements &&
      other.reason == reason;

    @override
    int get hashCode =>
        name.hashCode +
        (description == null ? 0 : description.hashCode) +
        priceMinBs.hashCode +
        priceMaxBs.hashCode +
        commissionPct.hashCode +
        active.hashCode +
        extraRequirements.hashCode +
        reason.hashCode;

  factory UpdateCategoryDto.fromJson(Map<String, dynamic> json) => _$UpdateCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


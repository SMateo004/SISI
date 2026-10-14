//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_category_city_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminCategoryCityDto {
  /// Returns a new [AdminCategoryCityDto] instance.
  AdminCategoryCityDto({

    required  this.cityId,

    required  this.citySlug,

    required  this.active,

    required  this.priceMinBs,

    required  this.priceMaxBs,

    required  this.commissionPct,

    required  this.effectivePriceMinBs,

    required  this.effectivePriceMaxBs,

    required  this.effectiveCommissionPct,
  });

  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'citySlug',
    required: true,
    includeIfNull: false,
  )


  final String citySlug;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    
    name: r'priceMinBs',
    required: true,
    includeIfNull: true,
  )


  final String? priceMinBs;



  @JsonKey(
    
    name: r'priceMaxBs',
    required: true,
    includeIfNull: true,
  )


  final String? priceMaxBs;



  @JsonKey(
    
    name: r'commissionPct',
    required: true,
    includeIfNull: true,
  )


  final String? commissionPct;



      /// Mínimo efectivo en la ciudad
  @JsonKey(
    
    name: r'effectivePriceMinBs',
    required: true,
    includeIfNull: false,
  )


  final String effectivePriceMinBs;



  @JsonKey(
    
    name: r'effectivePriceMaxBs',
    required: true,
    includeIfNull: false,
  )


  final String effectivePriceMaxBs;



  @JsonKey(
    
    name: r'effectiveCommissionPct',
    required: true,
    includeIfNull: false,
  )


  final String effectiveCommissionPct;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminCategoryCityDto &&
      other.cityId == cityId &&
      other.citySlug == citySlug &&
      other.active == active &&
      other.priceMinBs == priceMinBs &&
      other.priceMaxBs == priceMaxBs &&
      other.commissionPct == commissionPct &&
      other.effectivePriceMinBs == effectivePriceMinBs &&
      other.effectivePriceMaxBs == effectivePriceMaxBs &&
      other.effectiveCommissionPct == effectiveCommissionPct;

    @override
    int get hashCode =>
        cityId.hashCode +
        citySlug.hashCode +
        active.hashCode +
        (priceMinBs == null ? 0 : priceMinBs.hashCode) +
        (priceMaxBs == null ? 0 : priceMaxBs.hashCode) +
        (commissionPct == null ? 0 : commissionPct.hashCode) +
        effectivePriceMinBs.hashCode +
        effectivePriceMaxBs.hashCode +
        effectiveCommissionPct.hashCode;

  factory AdminCategoryCityDto.fromJson(Map<String, dynamic> json) => _$AdminCategoryCityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminCategoryCityDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


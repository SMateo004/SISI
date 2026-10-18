//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upsert_category_city_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpsertCategoryCityDto {
  /// Returns a new [UpsertCategoryCityDto] instance.
  UpsertCategoryCityDto({

    required  this.active,

     this.priceMinBs,

     this.priceMaxBs,

     this.commissionPct,

     this.reason,
  });

      /// Disponible en la ciudad
  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



      /// null = usa el valor base
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



      /// Motivo (queda en la auditoría)
  @JsonKey(
    
    name: r'reason',
    required: false,
    includeIfNull: false,
  )


  final String? reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpsertCategoryCityDto &&
      other.active == active &&
      other.priceMinBs == priceMinBs &&
      other.priceMaxBs == priceMaxBs &&
      other.commissionPct == commissionPct &&
      other.reason == reason;

    @override
    int get hashCode =>
        active.hashCode +
        (priceMinBs == null ? 0 : priceMinBs.hashCode) +
        (priceMaxBs == null ? 0 : priceMaxBs.hashCode) +
        (commissionPct == null ? 0 : commissionPct.hashCode) +
        reason.hashCode;

  factory UpsertCategoryCityDto.fromJson(Map<String, dynamic> json) => _$UpsertCategoryCityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpsertCategoryCityDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'price_range_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PriceRangeDto {
  /// Returns a new [PriceRangeDto] instance.
  PriceRangeDto({

    required  this.minBs,

    required  this.maxBs,
  });

  @JsonKey(
    
    name: r'minBs',
    required: true,
    includeIfNull: false,
  )


  final String minBs;



  @JsonKey(
    
    name: r'maxBs',
    required: true,
    includeIfNull: false,
  )


  final String maxBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PriceRangeDto &&
      other.minBs == minBs &&
      other.maxBs == maxBs;

    @override
    int get hashCode =>
        minBs.hashCode +
        maxBs.hashCode;

  factory PriceRangeDto.fromJson(Map<String, dynamic> json) => _$PriceRangeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PriceRangeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


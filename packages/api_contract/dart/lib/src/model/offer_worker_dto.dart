//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_worker_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferWorkerDto {
  /// Returns a new [OfferWorkerDto] instance.
  OfferWorkerDto({

    required  this.shortName,

    required  this.ratingAvg,

    required  this.ratingCount,
  });

  @JsonKey(
    
    name: r'shortName',
    required: true,
    includeIfNull: false,
  )


  final String shortName;



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
    bool operator ==(Object other) => identical(this, other) || other is OfferWorkerDto &&
      other.shortName == shortName &&
      other.ratingAvg == ratingAvg &&
      other.ratingCount == ratingCount;

    @override
    int get hashCode =>
        shortName.hashCode +
        ratingAvg.hashCode +
        ratingCount.hashCode;

  factory OfferWorkerDto.fromJson(Map<String, dynamic> json) => _$OfferWorkerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OfferWorkerDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


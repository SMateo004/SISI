//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/rating_dto.dart';
import 'package:sisi_api/src/model/period_row_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'worker_summary_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkerSummaryDto {
  /// Returns a new [WorkerSummaryDto] instance.
  WorkerSummaryDto({

    required  this.status,

    required  this.statusChangedAt,

    required  this.rating,

    required  this.rejectionReason,

    required  this.moderationResolution,

    required  this.categories,

    required  this.transport,

    required  this.maxRadiusKm,

    required  this.balanceBs,

    required  this.periods,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'statusChangedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime statusChangedAt;



  @JsonKey(
    
    name: r'rating',
    required: true,
    includeIfNull: false,
  )


  final RatingDto rating;



  @JsonKey(
    
    name: r'rejectionReason',
    required: true,
    includeIfNull: true,
  )


  final String? rejectionReason;



  @JsonKey(
    
    name: r'moderationResolution',
    required: true,
    includeIfNull: true,
  )


  final String? moderationResolution;



  @JsonKey(
    
    name: r'categories',
    required: true,
    includeIfNull: false,
  )


  final List<String> categories;



  @JsonKey(
    
    name: r'transport',
    required: true,
    includeIfNull: true,
  )


  final String? transport;



  @JsonKey(
    
    name: r'maxRadiusKm',
    required: true,
    includeIfNull: true,
  )


  final num? maxRadiusKm;



      /// Saldo del ledger (positivo = debe)
  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;



      /// Últimos 8
  @JsonKey(
    
    name: r'periods',
    required: true,
    includeIfNull: false,
  )


  final List<PeriodRowDto> periods;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WorkerSummaryDto &&
      other.status == status &&
      other.statusChangedAt == statusChangedAt &&
      other.rating == rating &&
      other.rejectionReason == rejectionReason &&
      other.moderationResolution == moderationResolution &&
      other.categories == categories &&
      other.transport == transport &&
      other.maxRadiusKm == maxRadiusKm &&
      other.balanceBs == balanceBs &&
      other.periods == periods;

    @override
    int get hashCode =>
        status.hashCode +
        statusChangedAt.hashCode +
        rating.hashCode +
        (rejectionReason == null ? 0 : rejectionReason.hashCode) +
        (moderationResolution == null ? 0 : moderationResolution.hashCode) +
        categories.hashCode +
        (transport == null ? 0 : transport.hashCode) +
        (maxRadiusKm == null ? 0 : maxRadiusKm.hashCode) +
        balanceBs.hashCode +
        periods.hashCode;

  factory WorkerSummaryDto.fromJson(Map<String, dynamic> json) => _$WorkerSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerSummaryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


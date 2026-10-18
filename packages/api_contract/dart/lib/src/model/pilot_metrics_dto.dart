//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/pilot_funnel_dto.dart';
import 'package:sisi_api/src/model/pilot_week_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_metrics_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotMetricsDto {
  /// Returns a new [PilotMetricsDto] instance.
  PilotMetricsDto({

    required  this.cityId,

    required  this.cityName,

    required  this.startedAt,

    required  this.from,

    required  this.to,

    required  this.funnel,

    required  this.avgFirstOfferSec,

    required  this.expirationRatePct,

    required  this.collectionRatePct,

    required  this.weekly,
  });

  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: false,
  )


  final String cityName;



      /// Inicio del piloto (parámetro PILOT_STARTED_AT); sin él, las últimas 8 semanas
  @JsonKey(
    
    name: r'startedAt',
    required: true,
    includeIfNull: true,
  )


  final String? startedAt;



  @JsonKey(
    
    name: r'from',
    required: true,
    includeIfNull: false,
  )


  final DateTime from;



  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final DateTime to;



  @JsonKey(
    
    name: r'funnel',
    required: true,
    includeIfNull: false,
  )


  final PilotFunnelDto funnel;



  @JsonKey(
    
    name: r'avgFirstOfferSec',
    required: true,
    includeIfNull: true,
  )


  final num? avgFirstOfferSec;



  @JsonKey(
    
    name: r'expirationRatePct',
    required: true,
    includeIfNull: true,
  )


  final num? expirationRatePct;



      /// Comisión cobrada sobre generada, en el rango
  @JsonKey(
    
    name: r'collectionRatePct',
    required: true,
    includeIfNull: true,
  )


  final num? collectionRatePct;



      /// Hasta 8 semanas, la última es la actual
  @JsonKey(
    
    name: r'weekly',
    required: true,
    includeIfNull: false,
  )


  final List<PilotWeekDto> weekly;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotMetricsDto &&
      other.cityId == cityId &&
      other.cityName == cityName &&
      other.startedAt == startedAt &&
      other.from == from &&
      other.to == to &&
      other.funnel == funnel &&
      other.avgFirstOfferSec == avgFirstOfferSec &&
      other.expirationRatePct == expirationRatePct &&
      other.collectionRatePct == collectionRatePct &&
      other.weekly == weekly;

    @override
    int get hashCode =>
        cityId.hashCode +
        cityName.hashCode +
        (startedAt == null ? 0 : startedAt.hashCode) +
        from.hashCode +
        to.hashCode +
        funnel.hashCode +
        (avgFirstOfferSec == null ? 0 : avgFirstOfferSec.hashCode) +
        (expirationRatePct == null ? 0 : expirationRatePct.hashCode) +
        (collectionRatePct == null ? 0 : collectionRatePct.hashCode) +
        weekly.hashCode;

  factory PilotMetricsDto.fromJson(Map<String, dynamic> json) => _$PilotMetricsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotMetricsDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


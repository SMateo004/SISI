//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/counters_dto.dart';
import 'package:sisi_api/src/model/cancellation_count_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DashboardDto {
  /// Returns a new [DashboardDto] instance.
  DashboardDto({

    required  this.range,

    required  this.cityId,

    required  this.cityName,

    required  this.from,

    required  this.to,

    required  this.requestsCreated,

    required  this.assignmentRatePct,

    required  this.expirationRatePct,

    required  this.avgFirstOfferSec,

    required  this.jobsCompleted,

    required  this.cancellationsByReason,

    required  this.commissionGeneratedBs,

    required  this.commissionCollectedBs,

    required  this.overdueDebtBs,

    required  this.overdueWorkers,

    required  this.workersAvailableNow,

    required  this.queues,
  });

  @JsonKey(
    
    name: r'range',
    required: true,
    includeIfNull: false,
  )


  final DashboardDtoRangeEnum range;



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



      /// Publicadas en el rango (sin borradores)
  @JsonKey(
    
    name: r'requestsCreated',
    required: true,
    includeIfNull: false,
  )


  final num requestsCreated;



  @JsonKey(
    
    name: r'assignmentRatePct',
    required: true,
    includeIfNull: true,
  )


  final num? assignmentRatePct;



  @JsonKey(
    
    name: r'expirationRatePct',
    required: true,
    includeIfNull: true,
  )


  final num? expirationRatePct;



      /// Desde la publicación, en segundos
  @JsonKey(
    
    name: r'avgFirstOfferSec',
    required: true,
    includeIfNull: true,
  )


  final num? avgFirstOfferSec;



  @JsonKey(
    
    name: r'jobsCompleted',
    required: true,
    includeIfNull: false,
  )


  final num jobsCompleted;



  @JsonKey(
    
    name: r'cancellationsByReason',
    required: true,
    includeIfNull: false,
  )


  final List<CancellationCountDto> cancellationsByReason;



  @JsonKey(
    
    name: r'commissionGeneratedBs',
    required: true,
    includeIfNull: false,
  )


  final String commissionGeneratedBs;



  @JsonKey(
    
    name: r'commissionCollectedBs',
    required: true,
    includeIfNull: false,
  )


  final String commissionCollectedBs;



      /// Saldo de los periodos vencidos (ahora)
  @JsonKey(
    
    name: r'overdueDebtBs',
    required: true,
    includeIfNull: false,
  )


  final String overdueDebtBs;



  @JsonKey(
    
    name: r'overdueWorkers',
    required: true,
    includeIfNull: false,
  )


  final num overdueWorkers;



      /// Disponibles con ubicación reciente
  @JsonKey(
    
    name: r'workersAvailableNow',
    required: true,
    includeIfNull: false,
  )


  final num workersAvailableNow;



  @JsonKey(
    
    name: r'queues',
    required: true,
    includeIfNull: false,
  )


  final CountersDto queues;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DashboardDto &&
      other.range == range &&
      other.cityId == cityId &&
      other.cityName == cityName &&
      other.from == from &&
      other.to == to &&
      other.requestsCreated == requestsCreated &&
      other.assignmentRatePct == assignmentRatePct &&
      other.expirationRatePct == expirationRatePct &&
      other.avgFirstOfferSec == avgFirstOfferSec &&
      other.jobsCompleted == jobsCompleted &&
      other.cancellationsByReason == cancellationsByReason &&
      other.commissionGeneratedBs == commissionGeneratedBs &&
      other.commissionCollectedBs == commissionCollectedBs &&
      other.overdueDebtBs == overdueDebtBs &&
      other.overdueWorkers == overdueWorkers &&
      other.workersAvailableNow == workersAvailableNow &&
      other.queues == queues;

    @override
    int get hashCode =>
        range.hashCode +
        cityId.hashCode +
        cityName.hashCode +
        from.hashCode +
        to.hashCode +
        requestsCreated.hashCode +
        (assignmentRatePct == null ? 0 : assignmentRatePct.hashCode) +
        (expirationRatePct == null ? 0 : expirationRatePct.hashCode) +
        (avgFirstOfferSec == null ? 0 : avgFirstOfferSec.hashCode) +
        jobsCompleted.hashCode +
        cancellationsByReason.hashCode +
        commissionGeneratedBs.hashCode +
        commissionCollectedBs.hashCode +
        overdueDebtBs.hashCode +
        overdueWorkers.hashCode +
        workersAvailableNow.hashCode +
        queues.hashCode;

  factory DashboardDto.fromJson(Map<String, dynamic> json) => _$DashboardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DashboardDtoRangeEnum {
@JsonValue(r'day')
day(r'day'),
@JsonValue(r'week')
week(r'week');

const DashboardDtoRangeEnum(this.value);

final String value;

@override
String toString() => value;
}



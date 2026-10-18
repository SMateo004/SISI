//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_week_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotWeekDto {
  /// Returns a new [PilotWeekDto] instance.
  PilotWeekDto({

    required  this.weekStart,

    required  this.activeWorkers,

    required  this.activeEmployers,

    required  this.workerRetentionPct,

    required  this.employerRetentionPct,
  });

      /// Lunes de la semana (hora local)
  @JsonKey(
    
    name: r'weekStart',
    required: true,
    includeIfNull: false,
  )


  final String weekStart;



      /// Trabajadores que ofertaron esa semana
  @JsonKey(
    
    name: r'activeWorkers',
    required: true,
    includeIfNull: false,
  )


  final num activeWorkers;



      /// Empleadores que publicaron esa semana
  @JsonKey(
    
    name: r'activeEmployers',
    required: true,
    includeIfNull: false,
  )


  final num activeEmployers;



      /// % de los trabajadores activos la semana anterior que volvieron
  @JsonKey(
    
    name: r'workerRetentionPct',
    required: true,
    includeIfNull: true,
  )


  final num? workerRetentionPct;



  @JsonKey(
    
    name: r'employerRetentionPct',
    required: true,
    includeIfNull: true,
  )


  final num? employerRetentionPct;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotWeekDto &&
      other.weekStart == weekStart &&
      other.activeWorkers == activeWorkers &&
      other.activeEmployers == activeEmployers &&
      other.workerRetentionPct == workerRetentionPct &&
      other.employerRetentionPct == employerRetentionPct;

    @override
    int get hashCode =>
        weekStart.hashCode +
        activeWorkers.hashCode +
        activeEmployers.hashCode +
        (workerRetentionPct == null ? 0 : workerRetentionPct.hashCode) +
        (employerRetentionPct == null ? 0 : employerRetentionPct.hashCode);

  factory PilotWeekDto.fromJson(Map<String, dynamic> json) => _$PilotWeekDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotWeekDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/job_row_dto.dart';
import 'package:sisi_api/src/model/report_counts_dto.dart';
import 'package:sisi_api/src/model/report_row_dto.dart';
import 'package:sisi_api/src/model/rating_dto.dart';
import 'package:sisi_api/src/model/worker_summary_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserProfileDto {
  /// Returns a new [UserProfileDto] instance.
  UserProfileDto({

    required  this.id,

    required  this.phone,

    required  this.name,

    required  this.role,

    required  this.activeMode,

    required  this.cityName,

    required  this.workerStatus,

    required  this.flagged,

    required  this.createdAt,

    required  this.employerRating,

    required  this.cancellationsCount,

    required  this.flaggedAt,

    required  this.worker,

    required  this.reportCounts,

    required  this.reports,

    required  this.jobsCount,

    required  this.jobs,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: true,
  )


  final String? name;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final UserProfileDtoRoleEnum role;



  @JsonKey(
    
    name: r'activeMode',
    required: true,
    includeIfNull: false,
  )


  final UserProfileDtoActiveModeEnum activeMode;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: false,
  )


  final String cityName;



      /// Estado del perfil de trabajador
  @JsonKey(
    
    name: r'workerStatus',
    required: true,
    includeIfNull: true,
  )


  final String? workerStatus;



      /// Empleador marcado para revisión (3 reportes válidos)
  @JsonKey(
    
    name: r'flagged',
    required: true,
    includeIfNull: false,
  )


  final bool flagged;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// Como empleador
  @JsonKey(
    
    name: r'employerRating',
    required: true,
    includeIfNull: false,
  )


  final RatingDto employerRating;



  @JsonKey(
    
    name: r'cancellationsCount',
    required: true,
    includeIfNull: false,
  )


  final num cancellationsCount;



  @JsonKey(
    
    name: r'flaggedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? flaggedAt;



  @JsonKey(
    
    name: r'worker',
    required: true,
    includeIfNull: true,
  )


  final WorkerSummaryDto? worker;



      /// Reportes recibidos
  @JsonKey(
    
    name: r'reportCounts',
    required: true,
    includeIfNull: false,
  )


  final ReportCountsDto reportCounts;



      /// Últimos 10 recibidos
  @JsonKey(
    
    name: r'reports',
    required: true,
    includeIfNull: false,
  )


  final List<ReportRowDto> reports;



      /// Trabajos como trabajador o empleador
  @JsonKey(
    
    name: r'jobsCount',
    required: true,
    includeIfNull: false,
  )


  final num jobsCount;



      /// Últimos 10
  @JsonKey(
    
    name: r'jobs',
    required: true,
    includeIfNull: false,
  )


  final List<JobRowDto> jobs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserProfileDto &&
      other.id == id &&
      other.phone == phone &&
      other.name == name &&
      other.role == role &&
      other.activeMode == activeMode &&
      other.cityName == cityName &&
      other.workerStatus == workerStatus &&
      other.flagged == flagged &&
      other.createdAt == createdAt &&
      other.employerRating == employerRating &&
      other.cancellationsCount == cancellationsCount &&
      other.flaggedAt == flaggedAt &&
      other.worker == worker &&
      other.reportCounts == reportCounts &&
      other.reports == reports &&
      other.jobsCount == jobsCount &&
      other.jobs == jobs;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (name == null ? 0 : name.hashCode) +
        role.hashCode +
        activeMode.hashCode +
        cityName.hashCode +
        (workerStatus == null ? 0 : workerStatus.hashCode) +
        flagged.hashCode +
        createdAt.hashCode +
        employerRating.hashCode +
        cancellationsCount.hashCode +
        (flaggedAt == null ? 0 : flaggedAt.hashCode) +
        (worker == null ? 0 : worker.hashCode) +
        reportCounts.hashCode +
        reports.hashCode +
        jobsCount.hashCode +
        jobs.hashCode;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => _$UserProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UserProfileDtoRoleEnum {
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'admin')
admin(r'admin');

const UserProfileDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum UserProfileDtoActiveModeEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const UserProfileDtoActiveModeEnum(this.value);

final String value;

@override
String toString() => value;
}



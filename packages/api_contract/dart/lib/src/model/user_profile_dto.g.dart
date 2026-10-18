// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserProfileDtoCWProxy {
  UserProfileDto id(String id);

  UserProfileDto phone(String phone);

  UserProfileDto name(String? name);

  UserProfileDto role(UserProfileDtoRoleEnum role);

  UserProfileDto activeMode(UserProfileDtoActiveModeEnum activeMode);

  UserProfileDto cityName(String cityName);

  UserProfileDto workerStatus(String? workerStatus);

  UserProfileDto flagged(bool flagged);

  UserProfileDto createdAt(DateTime createdAt);

  UserProfileDto employerRating(RatingDto employerRating);

  UserProfileDto cancellationsCount(num cancellationsCount);

  UserProfileDto flaggedAt(DateTime? flaggedAt);

  UserProfileDto worker(WorkerSummaryDto? worker);

  UserProfileDto reportCounts(ReportCountsDto reportCounts);

  UserProfileDto reports(List<ReportRowDto> reports);

  UserProfileDto jobsCount(num jobsCount);

  UserProfileDto jobs(List<JobRowDto> jobs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileDto call({
    String id,
    String phone,
    String? name,
    UserProfileDtoRoleEnum role,
    UserProfileDtoActiveModeEnum activeMode,
    String cityName,
    String? workerStatus,
    bool flagged,
    DateTime createdAt,
    RatingDto employerRating,
    num cancellationsCount,
    DateTime? flaggedAt,
    WorkerSummaryDto? worker,
    ReportCountsDto reportCounts,
    List<ReportRowDto> reports,
    num jobsCount,
    List<JobRowDto> jobs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserProfileDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserProfileDto.copyWith.fieldName(...)`
class _$UserProfileDtoCWProxyImpl implements _$UserProfileDtoCWProxy {
  const _$UserProfileDtoCWProxyImpl(this._value);

  final UserProfileDto _value;

  @override
  UserProfileDto id(String id) => this(id: id);

  @override
  UserProfileDto phone(String phone) => this(phone: phone);

  @override
  UserProfileDto name(String? name) => this(name: name);

  @override
  UserProfileDto role(UserProfileDtoRoleEnum role) => this(role: role);

  @override
  UserProfileDto activeMode(UserProfileDtoActiveModeEnum activeMode) =>
      this(activeMode: activeMode);

  @override
  UserProfileDto cityName(String cityName) => this(cityName: cityName);

  @override
  UserProfileDto workerStatus(String? workerStatus) =>
      this(workerStatus: workerStatus);

  @override
  UserProfileDto flagged(bool flagged) => this(flagged: flagged);

  @override
  UserProfileDto createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  UserProfileDto employerRating(RatingDto employerRating) =>
      this(employerRating: employerRating);

  @override
  UserProfileDto cancellationsCount(num cancellationsCount) =>
      this(cancellationsCount: cancellationsCount);

  @override
  UserProfileDto flaggedAt(DateTime? flaggedAt) => this(flaggedAt: flaggedAt);

  @override
  UserProfileDto worker(WorkerSummaryDto? worker) => this(worker: worker);

  @override
  UserProfileDto reportCounts(ReportCountsDto reportCounts) =>
      this(reportCounts: reportCounts);

  @override
  UserProfileDto reports(List<ReportRowDto> reports) => this(reports: reports);

  @override
  UserProfileDto jobsCount(num jobsCount) => this(jobsCount: jobsCount);

  @override
  UserProfileDto jobs(List<JobRowDto> jobs) => this(jobs: jobs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileDto(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? activeMode = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? workerStatus = const $CopyWithPlaceholder(),
    Object? flagged = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? employerRating = const $CopyWithPlaceholder(),
    Object? cancellationsCount = const $CopyWithPlaceholder(),
    Object? flaggedAt = const $CopyWithPlaceholder(),
    Object? worker = const $CopyWithPlaceholder(),
    Object? reportCounts = const $CopyWithPlaceholder(),
    Object? reports = const $CopyWithPlaceholder(),
    Object? jobsCount = const $CopyWithPlaceholder(),
    Object? jobs = const $CopyWithPlaceholder(),
  }) {
    return UserProfileDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as UserProfileDtoRoleEnum,
      activeMode: activeMode == const $CopyWithPlaceholder()
          ? _value.activeMode
          // ignore: cast_nullable_to_non_nullable
          : activeMode as UserProfileDtoActiveModeEnum,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      workerStatus: workerStatus == const $CopyWithPlaceholder()
          ? _value.workerStatus
          // ignore: cast_nullable_to_non_nullable
          : workerStatus as String?,
      flagged: flagged == const $CopyWithPlaceholder()
          ? _value.flagged
          // ignore: cast_nullable_to_non_nullable
          : flagged as bool,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      employerRating: employerRating == const $CopyWithPlaceholder()
          ? _value.employerRating
          // ignore: cast_nullable_to_non_nullable
          : employerRating as RatingDto,
      cancellationsCount: cancellationsCount == const $CopyWithPlaceholder()
          ? _value.cancellationsCount
          // ignore: cast_nullable_to_non_nullable
          : cancellationsCount as num,
      flaggedAt: flaggedAt == const $CopyWithPlaceholder()
          ? _value.flaggedAt
          // ignore: cast_nullable_to_non_nullable
          : flaggedAt as DateTime?,
      worker: worker == const $CopyWithPlaceholder()
          ? _value.worker
          // ignore: cast_nullable_to_non_nullable
          : worker as WorkerSummaryDto?,
      reportCounts: reportCounts == const $CopyWithPlaceholder()
          ? _value.reportCounts
          // ignore: cast_nullable_to_non_nullable
          : reportCounts as ReportCountsDto,
      reports: reports == const $CopyWithPlaceholder()
          ? _value.reports
          // ignore: cast_nullable_to_non_nullable
          : reports as List<ReportRowDto>,
      jobsCount: jobsCount == const $CopyWithPlaceholder()
          ? _value.jobsCount
          // ignore: cast_nullable_to_non_nullable
          : jobsCount as num,
      jobs: jobs == const $CopyWithPlaceholder()
          ? _value.jobs
          // ignore: cast_nullable_to_non_nullable
          : jobs as List<JobRowDto>,
    );
  }
}

extension $UserProfileDtoCopyWith on UserProfileDto {
  /// Returns a callable class that can be used as follows: `instanceOfUserProfileDto.copyWith(...)` or like so:`instanceOfUserProfileDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserProfileDtoCWProxy get copyWith => _$UserProfileDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileDto _$UserProfileDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('UserProfileDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'phone',
      'name',
      'role',
      'activeMode',
      'cityName',
      'workerStatus',
      'flagged',
      'createdAt',
      'employerRating',
      'cancellationsCount',
      'flaggedAt',
      'worker',
      'reportCounts',
      'reports',
      'jobsCount',
      'jobs',
    ],
  );
  final val = UserProfileDto(
    id: $checkedConvert('id', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    name: $checkedConvert('name', (v) => v as String?),
    role: $checkedConvert(
      'role',
      (v) => $enumDecode(_$UserProfileDtoRoleEnumEnumMap, v),
    ),
    activeMode: $checkedConvert(
      'activeMode',
      (v) => $enumDecode(_$UserProfileDtoActiveModeEnumEnumMap, v),
    ),
    cityName: $checkedConvert('cityName', (v) => v as String),
    workerStatus: $checkedConvert('workerStatus', (v) => v as String?),
    flagged: $checkedConvert('flagged', (v) => v as bool),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    employerRating: $checkedConvert(
      'employerRating',
      (v) => RatingDto.fromJson(v as Map<String, dynamic>),
    ),
    cancellationsCount: $checkedConvert('cancellationsCount', (v) => v as num),
    flaggedAt: $checkedConvert(
      'flaggedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    worker: $checkedConvert(
      'worker',
      (v) => v == null
          ? null
          : WorkerSummaryDto.fromJson(v as Map<String, dynamic>),
    ),
    reportCounts: $checkedConvert(
      'reportCounts',
      (v) => ReportCountsDto.fromJson(v as Map<String, dynamic>),
    ),
    reports: $checkedConvert(
      'reports',
      (v) => (v as List<dynamic>)
          .map((e) => ReportRowDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    jobsCount: $checkedConvert('jobsCount', (v) => v as num),
    jobs: $checkedConvert(
      'jobs',
      (v) => (v as List<dynamic>)
          .map((e) => JobRowDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$UserProfileDtoToJson(UserProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'role': _$UserProfileDtoRoleEnumEnumMap[instance.role]!,
      'activeMode': _$UserProfileDtoActiveModeEnumEnumMap[instance.activeMode]!,
      'cityName': instance.cityName,
      'workerStatus': instance.workerStatus,
      'flagged': instance.flagged,
      'createdAt': instance.createdAt.toIso8601String(),
      'employerRating': instance.employerRating.toJson(),
      'cancellationsCount': instance.cancellationsCount,
      'flaggedAt': instance.flaggedAt?.toIso8601String(),
      'worker': instance.worker?.toJson(),
      'reportCounts': instance.reportCounts.toJson(),
      'reports': instance.reports.map((e) => e.toJson()).toList(),
      'jobsCount': instance.jobsCount,
      'jobs': instance.jobs.map((e) => e.toJson()).toList(),
    };

const _$UserProfileDtoRoleEnumEnumMap = {
  UserProfileDtoRoleEnum.user: 'user',
  UserProfileDtoRoleEnum.admin: 'admin',
};

const _$UserProfileDtoActiveModeEnumEnumMap = {
  UserProfileDtoActiveModeEnum.employer: 'employer',
  UserProfileDtoActiveModeEnum.worker: 'worker',
};

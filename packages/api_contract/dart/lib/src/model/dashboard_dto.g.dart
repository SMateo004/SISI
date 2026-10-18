// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DashboardDtoCWProxy {
  DashboardDto range(DashboardDtoRangeEnum range);

  DashboardDto cityId(String cityId);

  DashboardDto cityName(String cityName);

  DashboardDto from(DateTime from);

  DashboardDto to(DateTime to);

  DashboardDto requestsCreated(num requestsCreated);

  DashboardDto assignmentRatePct(num? assignmentRatePct);

  DashboardDto expirationRatePct(num? expirationRatePct);

  DashboardDto avgFirstOfferSec(num? avgFirstOfferSec);

  DashboardDto jobsCompleted(num jobsCompleted);

  DashboardDto cancellationsByReason(
    List<CancellationCountDto> cancellationsByReason,
  );

  DashboardDto commissionGeneratedBs(String commissionGeneratedBs);

  DashboardDto commissionCollectedBs(String commissionCollectedBs);

  DashboardDto overdueDebtBs(String overdueDebtBs);

  DashboardDto overdueWorkers(num overdueWorkers);

  DashboardDto workersAvailableNow(num workersAvailableNow);

  DashboardDto queues(CountersDto queues);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardDto call({
    DashboardDtoRangeEnum range,
    String cityId,
    String cityName,
    DateTime from,
    DateTime to,
    num requestsCreated,
    num? assignmentRatePct,
    num? expirationRatePct,
    num? avgFirstOfferSec,
    num jobsCompleted,
    List<CancellationCountDto> cancellationsByReason,
    String commissionGeneratedBs,
    String commissionCollectedBs,
    String overdueDebtBs,
    num overdueWorkers,
    num workersAvailableNow,
    CountersDto queues,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDashboardDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDashboardDto.copyWith.fieldName(...)`
class _$DashboardDtoCWProxyImpl implements _$DashboardDtoCWProxy {
  const _$DashboardDtoCWProxyImpl(this._value);

  final DashboardDto _value;

  @override
  DashboardDto range(DashboardDtoRangeEnum range) => this(range: range);

  @override
  DashboardDto cityId(String cityId) => this(cityId: cityId);

  @override
  DashboardDto cityName(String cityName) => this(cityName: cityName);

  @override
  DashboardDto from(DateTime from) => this(from: from);

  @override
  DashboardDto to(DateTime to) => this(to: to);

  @override
  DashboardDto requestsCreated(num requestsCreated) =>
      this(requestsCreated: requestsCreated);

  @override
  DashboardDto assignmentRatePct(num? assignmentRatePct) =>
      this(assignmentRatePct: assignmentRatePct);

  @override
  DashboardDto expirationRatePct(num? expirationRatePct) =>
      this(expirationRatePct: expirationRatePct);

  @override
  DashboardDto avgFirstOfferSec(num? avgFirstOfferSec) =>
      this(avgFirstOfferSec: avgFirstOfferSec);

  @override
  DashboardDto jobsCompleted(num jobsCompleted) =>
      this(jobsCompleted: jobsCompleted);

  @override
  DashboardDto cancellationsByReason(
    List<CancellationCountDto> cancellationsByReason,
  ) => this(cancellationsByReason: cancellationsByReason);

  @override
  DashboardDto commissionGeneratedBs(String commissionGeneratedBs) =>
      this(commissionGeneratedBs: commissionGeneratedBs);

  @override
  DashboardDto commissionCollectedBs(String commissionCollectedBs) =>
      this(commissionCollectedBs: commissionCollectedBs);

  @override
  DashboardDto overdueDebtBs(String overdueDebtBs) =>
      this(overdueDebtBs: overdueDebtBs);

  @override
  DashboardDto overdueWorkers(num overdueWorkers) =>
      this(overdueWorkers: overdueWorkers);

  @override
  DashboardDto workersAvailableNow(num workersAvailableNow) =>
      this(workersAvailableNow: workersAvailableNow);

  @override
  DashboardDto queues(CountersDto queues) => this(queues: queues);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardDto(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardDto call({
    Object? range = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? requestsCreated = const $CopyWithPlaceholder(),
    Object? assignmentRatePct = const $CopyWithPlaceholder(),
    Object? expirationRatePct = const $CopyWithPlaceholder(),
    Object? avgFirstOfferSec = const $CopyWithPlaceholder(),
    Object? jobsCompleted = const $CopyWithPlaceholder(),
    Object? cancellationsByReason = const $CopyWithPlaceholder(),
    Object? commissionGeneratedBs = const $CopyWithPlaceholder(),
    Object? commissionCollectedBs = const $CopyWithPlaceholder(),
    Object? overdueDebtBs = const $CopyWithPlaceholder(),
    Object? overdueWorkers = const $CopyWithPlaceholder(),
    Object? workersAvailableNow = const $CopyWithPlaceholder(),
    Object? queues = const $CopyWithPlaceholder(),
  }) {
    return DashboardDto(
      range: range == const $CopyWithPlaceholder()
          ? _value.range
          // ignore: cast_nullable_to_non_nullable
          : range as DashboardDtoRangeEnum,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime,
      requestsCreated: requestsCreated == const $CopyWithPlaceholder()
          ? _value.requestsCreated
          // ignore: cast_nullable_to_non_nullable
          : requestsCreated as num,
      assignmentRatePct: assignmentRatePct == const $CopyWithPlaceholder()
          ? _value.assignmentRatePct
          // ignore: cast_nullable_to_non_nullable
          : assignmentRatePct as num?,
      expirationRatePct: expirationRatePct == const $CopyWithPlaceholder()
          ? _value.expirationRatePct
          // ignore: cast_nullable_to_non_nullable
          : expirationRatePct as num?,
      avgFirstOfferSec: avgFirstOfferSec == const $CopyWithPlaceholder()
          ? _value.avgFirstOfferSec
          // ignore: cast_nullable_to_non_nullable
          : avgFirstOfferSec as num?,
      jobsCompleted: jobsCompleted == const $CopyWithPlaceholder()
          ? _value.jobsCompleted
          // ignore: cast_nullable_to_non_nullable
          : jobsCompleted as num,
      cancellationsByReason:
          cancellationsByReason == const $CopyWithPlaceholder()
          ? _value.cancellationsByReason
          // ignore: cast_nullable_to_non_nullable
          : cancellationsByReason as List<CancellationCountDto>,
      commissionGeneratedBs:
          commissionGeneratedBs == const $CopyWithPlaceholder()
          ? _value.commissionGeneratedBs
          // ignore: cast_nullable_to_non_nullable
          : commissionGeneratedBs as String,
      commissionCollectedBs:
          commissionCollectedBs == const $CopyWithPlaceholder()
          ? _value.commissionCollectedBs
          // ignore: cast_nullable_to_non_nullable
          : commissionCollectedBs as String,
      overdueDebtBs: overdueDebtBs == const $CopyWithPlaceholder()
          ? _value.overdueDebtBs
          // ignore: cast_nullable_to_non_nullable
          : overdueDebtBs as String,
      overdueWorkers: overdueWorkers == const $CopyWithPlaceholder()
          ? _value.overdueWorkers
          // ignore: cast_nullable_to_non_nullable
          : overdueWorkers as num,
      workersAvailableNow: workersAvailableNow == const $CopyWithPlaceholder()
          ? _value.workersAvailableNow
          // ignore: cast_nullable_to_non_nullable
          : workersAvailableNow as num,
      queues: queues == const $CopyWithPlaceholder()
          ? _value.queues
          // ignore: cast_nullable_to_non_nullable
          : queues as CountersDto,
    );
  }
}

extension $DashboardDtoCopyWith on DashboardDto {
  /// Returns a callable class that can be used as follows: `instanceOfDashboardDto.copyWith(...)` or like so:`instanceOfDashboardDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DashboardDtoCWProxy get copyWith => _$DashboardDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDto _$DashboardDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DashboardDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'range',
      'cityId',
      'cityName',
      'from',
      'to',
      'requestsCreated',
      'assignmentRatePct',
      'expirationRatePct',
      'avgFirstOfferSec',
      'jobsCompleted',
      'cancellationsByReason',
      'commissionGeneratedBs',
      'commissionCollectedBs',
      'overdueDebtBs',
      'overdueWorkers',
      'workersAvailableNow',
      'queues',
    ],
  );
  final val = DashboardDto(
    range: $checkedConvert(
      'range',
      (v) => $enumDecode(_$DashboardDtoRangeEnumEnumMap, v),
    ),
    cityId: $checkedConvert('cityId', (v) => v as String),
    cityName: $checkedConvert('cityName', (v) => v as String),
    from: $checkedConvert('from', (v) => DateTime.parse(v as String)),
    to: $checkedConvert('to', (v) => DateTime.parse(v as String)),
    requestsCreated: $checkedConvert('requestsCreated', (v) => v as num),
    assignmentRatePct: $checkedConvert('assignmentRatePct', (v) => v as num?),
    expirationRatePct: $checkedConvert('expirationRatePct', (v) => v as num?),
    avgFirstOfferSec: $checkedConvert('avgFirstOfferSec', (v) => v as num?),
    jobsCompleted: $checkedConvert('jobsCompleted', (v) => v as num),
    cancellationsByReason: $checkedConvert(
      'cancellationsByReason',
      (v) => (v as List<dynamic>)
          .map((e) => CancellationCountDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    commissionGeneratedBs: $checkedConvert(
      'commissionGeneratedBs',
      (v) => v as String,
    ),
    commissionCollectedBs: $checkedConvert(
      'commissionCollectedBs',
      (v) => v as String,
    ),
    overdueDebtBs: $checkedConvert('overdueDebtBs', (v) => v as String),
    overdueWorkers: $checkedConvert('overdueWorkers', (v) => v as num),
    workersAvailableNow: $checkedConvert(
      'workersAvailableNow',
      (v) => v as num,
    ),
    queues: $checkedConvert(
      'queues',
      (v) => CountersDto.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$DashboardDtoToJson(DashboardDto instance) =>
    <String, dynamic>{
      'range': _$DashboardDtoRangeEnumEnumMap[instance.range]!,
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
      'requestsCreated': instance.requestsCreated,
      'assignmentRatePct': instance.assignmentRatePct,
      'expirationRatePct': instance.expirationRatePct,
      'avgFirstOfferSec': instance.avgFirstOfferSec,
      'jobsCompleted': instance.jobsCompleted,
      'cancellationsByReason': instance.cancellationsByReason
          .map((e) => e.toJson())
          .toList(),
      'commissionGeneratedBs': instance.commissionGeneratedBs,
      'commissionCollectedBs': instance.commissionCollectedBs,
      'overdueDebtBs': instance.overdueDebtBs,
      'overdueWorkers': instance.overdueWorkers,
      'workersAvailableNow': instance.workersAvailableNow,
      'queues': instance.queues.toJson(),
    };

const _$DashboardDtoRangeEnumEnumMap = {
  DashboardDtoRangeEnum.day: 'day',
  DashboardDtoRangeEnum.week: 'week',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilot_metrics_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PilotMetricsDtoCWProxy {
  PilotMetricsDto cityId(String cityId);

  PilotMetricsDto cityName(String cityName);

  PilotMetricsDto startedAt(String? startedAt);

  PilotMetricsDto from(DateTime from);

  PilotMetricsDto to(DateTime to);

  PilotMetricsDto funnel(PilotFunnelDto funnel);

  PilotMetricsDto avgFirstOfferSec(num? avgFirstOfferSec);

  PilotMetricsDto expirationRatePct(num? expirationRatePct);

  PilotMetricsDto collectionRatePct(num? collectionRatePct);

  PilotMetricsDto weekly(List<PilotWeekDto> weekly);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotMetricsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotMetricsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotMetricsDto call({
    String cityId,
    String cityName,
    String? startedAt,
    DateTime from,
    DateTime to,
    PilotFunnelDto funnel,
    num? avgFirstOfferSec,
    num? expirationRatePct,
    num? collectionRatePct,
    List<PilotWeekDto> weekly,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPilotMetricsDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPilotMetricsDto.copyWith.fieldName(...)`
class _$PilotMetricsDtoCWProxyImpl implements _$PilotMetricsDtoCWProxy {
  const _$PilotMetricsDtoCWProxyImpl(this._value);

  final PilotMetricsDto _value;

  @override
  PilotMetricsDto cityId(String cityId) => this(cityId: cityId);

  @override
  PilotMetricsDto cityName(String cityName) => this(cityName: cityName);

  @override
  PilotMetricsDto startedAt(String? startedAt) => this(startedAt: startedAt);

  @override
  PilotMetricsDto from(DateTime from) => this(from: from);

  @override
  PilotMetricsDto to(DateTime to) => this(to: to);

  @override
  PilotMetricsDto funnel(PilotFunnelDto funnel) => this(funnel: funnel);

  @override
  PilotMetricsDto avgFirstOfferSec(num? avgFirstOfferSec) =>
      this(avgFirstOfferSec: avgFirstOfferSec);

  @override
  PilotMetricsDto expirationRatePct(num? expirationRatePct) =>
      this(expirationRatePct: expirationRatePct);

  @override
  PilotMetricsDto collectionRatePct(num? collectionRatePct) =>
      this(collectionRatePct: collectionRatePct);

  @override
  PilotMetricsDto weekly(List<PilotWeekDto> weekly) => this(weekly: weekly);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PilotMetricsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PilotMetricsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  PilotMetricsDto call({
    Object? cityId = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? funnel = const $CopyWithPlaceholder(),
    Object? avgFirstOfferSec = const $CopyWithPlaceholder(),
    Object? expirationRatePct = const $CopyWithPlaceholder(),
    Object? collectionRatePct = const $CopyWithPlaceholder(),
    Object? weekly = const $CopyWithPlaceholder(),
  }) {
    return PilotMetricsDto(
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as String?,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime,
      funnel: funnel == const $CopyWithPlaceholder()
          ? _value.funnel
          // ignore: cast_nullable_to_non_nullable
          : funnel as PilotFunnelDto,
      avgFirstOfferSec: avgFirstOfferSec == const $CopyWithPlaceholder()
          ? _value.avgFirstOfferSec
          // ignore: cast_nullable_to_non_nullable
          : avgFirstOfferSec as num?,
      expirationRatePct: expirationRatePct == const $CopyWithPlaceholder()
          ? _value.expirationRatePct
          // ignore: cast_nullable_to_non_nullable
          : expirationRatePct as num?,
      collectionRatePct: collectionRatePct == const $CopyWithPlaceholder()
          ? _value.collectionRatePct
          // ignore: cast_nullable_to_non_nullable
          : collectionRatePct as num?,
      weekly: weekly == const $CopyWithPlaceholder()
          ? _value.weekly
          // ignore: cast_nullable_to_non_nullable
          : weekly as List<PilotWeekDto>,
    );
  }
}

extension $PilotMetricsDtoCopyWith on PilotMetricsDto {
  /// Returns a callable class that can be used as follows: `instanceOfPilotMetricsDto.copyWith(...)` or like so:`instanceOfPilotMetricsDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PilotMetricsDtoCWProxy get copyWith => _$PilotMetricsDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PilotMetricsDto _$PilotMetricsDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PilotMetricsDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'cityId',
      'cityName',
      'startedAt',
      'from',
      'to',
      'funnel',
      'avgFirstOfferSec',
      'expirationRatePct',
      'collectionRatePct',
      'weekly',
    ],
  );
  final val = PilotMetricsDto(
    cityId: $checkedConvert('cityId', (v) => v as String),
    cityName: $checkedConvert('cityName', (v) => v as String),
    startedAt: $checkedConvert('startedAt', (v) => v as String?),
    from: $checkedConvert('from', (v) => DateTime.parse(v as String)),
    to: $checkedConvert('to', (v) => DateTime.parse(v as String)),
    funnel: $checkedConvert(
      'funnel',
      (v) => PilotFunnelDto.fromJson(v as Map<String, dynamic>),
    ),
    avgFirstOfferSec: $checkedConvert('avgFirstOfferSec', (v) => v as num?),
    expirationRatePct: $checkedConvert('expirationRatePct', (v) => v as num?),
    collectionRatePct: $checkedConvert('collectionRatePct', (v) => v as num?),
    weekly: $checkedConvert(
      'weekly',
      (v) => (v as List<dynamic>)
          .map((e) => PilotWeekDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PilotMetricsDtoToJson(PilotMetricsDto instance) =>
    <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'startedAt': instance.startedAt,
      'from': instance.from.toIso8601String(),
      'to': instance.to.toIso8601String(),
      'funnel': instance.funnel.toJson(),
      'avgFirstOfferSec': instance.avgFirstOfferSec,
      'expirationRatePct': instance.expirationRatePct,
      'collectionRatePct': instance.collectionRatePct,
      'weekly': instance.weekly.map((e) => e.toJson()).toList(),
    };

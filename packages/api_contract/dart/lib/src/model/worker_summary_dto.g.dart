// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_summary_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WorkerSummaryDtoCWProxy {
  WorkerSummaryDto status(String status);

  WorkerSummaryDto statusChangedAt(DateTime statusChangedAt);

  WorkerSummaryDto rating(RatingDto rating);

  WorkerSummaryDto rejectionReason(String? rejectionReason);

  WorkerSummaryDto moderationResolution(String? moderationResolution);

  WorkerSummaryDto categories(List<String> categories);

  WorkerSummaryDto transport(String? transport);

  WorkerSummaryDto maxRadiusKm(num? maxRadiusKm);

  WorkerSummaryDto balanceBs(String balanceBs);

  WorkerSummaryDto periods(List<PeriodRowDto> periods);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerSummaryDto call({
    String status,
    DateTime statusChangedAt,
    RatingDto rating,
    String? rejectionReason,
    String? moderationResolution,
    List<String> categories,
    String? transport,
    num? maxRadiusKm,
    String balanceBs,
    List<PeriodRowDto> periods,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWorkerSummaryDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWorkerSummaryDto.copyWith.fieldName(...)`
class _$WorkerSummaryDtoCWProxyImpl implements _$WorkerSummaryDtoCWProxy {
  const _$WorkerSummaryDtoCWProxyImpl(this._value);

  final WorkerSummaryDto _value;

  @override
  WorkerSummaryDto status(String status) => this(status: status);

  @override
  WorkerSummaryDto statusChangedAt(DateTime statusChangedAt) =>
      this(statusChangedAt: statusChangedAt);

  @override
  WorkerSummaryDto rating(RatingDto rating) => this(rating: rating);

  @override
  WorkerSummaryDto rejectionReason(String? rejectionReason) =>
      this(rejectionReason: rejectionReason);

  @override
  WorkerSummaryDto moderationResolution(String? moderationResolution) =>
      this(moderationResolution: moderationResolution);

  @override
  WorkerSummaryDto categories(List<String> categories) =>
      this(categories: categories);

  @override
  WorkerSummaryDto transport(String? transport) => this(transport: transport);

  @override
  WorkerSummaryDto maxRadiusKm(num? maxRadiusKm) =>
      this(maxRadiusKm: maxRadiusKm);

  @override
  WorkerSummaryDto balanceBs(String balanceBs) => this(balanceBs: balanceBs);

  @override
  WorkerSummaryDto periods(List<PeriodRowDto> periods) =>
      this(periods: periods);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WorkerSummaryDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WorkerSummaryDto(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkerSummaryDto call({
    Object? status = const $CopyWithPlaceholder(),
    Object? statusChangedAt = const $CopyWithPlaceholder(),
    Object? rating = const $CopyWithPlaceholder(),
    Object? rejectionReason = const $CopyWithPlaceholder(),
    Object? moderationResolution = const $CopyWithPlaceholder(),
    Object? categories = const $CopyWithPlaceholder(),
    Object? transport = const $CopyWithPlaceholder(),
    Object? maxRadiusKm = const $CopyWithPlaceholder(),
    Object? balanceBs = const $CopyWithPlaceholder(),
    Object? periods = const $CopyWithPlaceholder(),
  }) {
    return WorkerSummaryDto(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      statusChangedAt: statusChangedAt == const $CopyWithPlaceholder()
          ? _value.statusChangedAt
          // ignore: cast_nullable_to_non_nullable
          : statusChangedAt as DateTime,
      rating: rating == const $CopyWithPlaceholder()
          ? _value.rating
          // ignore: cast_nullable_to_non_nullable
          : rating as RatingDto,
      rejectionReason: rejectionReason == const $CopyWithPlaceholder()
          ? _value.rejectionReason
          // ignore: cast_nullable_to_non_nullable
          : rejectionReason as String?,
      moderationResolution: moderationResolution == const $CopyWithPlaceholder()
          ? _value.moderationResolution
          // ignore: cast_nullable_to_non_nullable
          : moderationResolution as String?,
      categories: categories == const $CopyWithPlaceholder()
          ? _value.categories
          // ignore: cast_nullable_to_non_nullable
          : categories as List<String>,
      transport: transport == const $CopyWithPlaceholder()
          ? _value.transport
          // ignore: cast_nullable_to_non_nullable
          : transport as String?,
      maxRadiusKm: maxRadiusKm == const $CopyWithPlaceholder()
          ? _value.maxRadiusKm
          // ignore: cast_nullable_to_non_nullable
          : maxRadiusKm as num?,
      balanceBs: balanceBs == const $CopyWithPlaceholder()
          ? _value.balanceBs
          // ignore: cast_nullable_to_non_nullable
          : balanceBs as String,
      periods: periods == const $CopyWithPlaceholder()
          ? _value.periods
          // ignore: cast_nullable_to_non_nullable
          : periods as List<PeriodRowDto>,
    );
  }
}

extension $WorkerSummaryDtoCopyWith on WorkerSummaryDto {
  /// Returns a callable class that can be used as follows: `instanceOfWorkerSummaryDto.copyWith(...)` or like so:`instanceOfWorkerSummaryDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WorkerSummaryDtoCWProxy get copyWith => _$WorkerSummaryDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkerSummaryDto _$WorkerSummaryDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WorkerSummaryDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'status',
          'statusChangedAt',
          'rating',
          'rejectionReason',
          'moderationResolution',
          'categories',
          'transport',
          'maxRadiusKm',
          'balanceBs',
          'periods',
        ],
      );
      final val = WorkerSummaryDto(
        status: $checkedConvert('status', (v) => v as String),
        statusChangedAt: $checkedConvert(
          'statusChangedAt',
          (v) => DateTime.parse(v as String),
        ),
        rating: $checkedConvert(
          'rating',
          (v) => RatingDto.fromJson(v as Map<String, dynamic>),
        ),
        rejectionReason: $checkedConvert(
          'rejectionReason',
          (v) => v as String?,
        ),
        moderationResolution: $checkedConvert(
          'moderationResolution',
          (v) => v as String?,
        ),
        categories: $checkedConvert(
          'categories',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        transport: $checkedConvert('transport', (v) => v as String?),
        maxRadiusKm: $checkedConvert('maxRadiusKm', (v) => v as num?),
        balanceBs: $checkedConvert('balanceBs', (v) => v as String),
        periods: $checkedConvert(
          'periods',
          (v) => (v as List<dynamic>)
              .map((e) => PeriodRowDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WorkerSummaryDtoToJson(WorkerSummaryDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'statusChangedAt': instance.statusChangedAt.toIso8601String(),
      'rating': instance.rating.toJson(),
      'rejectionReason': instance.rejectionReason,
      'moderationResolution': instance.moderationResolution,
      'categories': instance.categories,
      'transport': instance.transport,
      'maxRadiusKm': instance.maxRadiusKm,
      'balanceBs': instance.balanceBs,
      'periods': instance.periods.map((e) => e.toJson()).toList(),
    };

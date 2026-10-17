// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobDtoCWProxy {
  JobDto id(String id);

  JobDto requestId(String requestId);

  JobDto status(JobDtoStatusEnum status);

  JobDto myRole(JobDtoMyRoleEnum myRole);

  JobDto category(JobCategoryDto category);

  JobDto description(String description);

  JobDto counterpart(JobCounterpartDto counterpart);

  JobDto finalPriceBs(String finalPriceBs);

  JobDto commissionBs(String? commissionBs);

  JobDto netBs(String? netBs);

  JobDto timeline(JobTimelineDto timeline);

  JobDto autoConfirmed(bool autoConfirmed);

  JobDto autoConfirmAt(DateTime? autoConfirmAt);

  JobDto cancellation(JobCancellationDto? cancellation);

  JobDto reviews(JobReviewsDto reviews);

  JobDto allowedActions(List<JobDtoAllowedActionsEnum> allowedActions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobDto call({
    String id,
    String requestId,
    JobDtoStatusEnum status,
    JobDtoMyRoleEnum myRole,
    JobCategoryDto category,
    String description,
    JobCounterpartDto counterpart,
    String finalPriceBs,
    String? commissionBs,
    String? netBs,
    JobTimelineDto timeline,
    bool autoConfirmed,
    DateTime? autoConfirmAt,
    JobCancellationDto? cancellation,
    JobReviewsDto reviews,
    List<JobDtoAllowedActionsEnum> allowedActions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobDto.copyWith.fieldName(...)`
class _$JobDtoCWProxyImpl implements _$JobDtoCWProxy {
  const _$JobDtoCWProxyImpl(this._value);

  final JobDto _value;

  @override
  JobDto id(String id) => this(id: id);

  @override
  JobDto requestId(String requestId) => this(requestId: requestId);

  @override
  JobDto status(JobDtoStatusEnum status) => this(status: status);

  @override
  JobDto myRole(JobDtoMyRoleEnum myRole) => this(myRole: myRole);

  @override
  JobDto category(JobCategoryDto category) => this(category: category);

  @override
  JobDto description(String description) => this(description: description);

  @override
  JobDto counterpart(JobCounterpartDto counterpart) =>
      this(counterpart: counterpart);

  @override
  JobDto finalPriceBs(String finalPriceBs) => this(finalPriceBs: finalPriceBs);

  @override
  JobDto commissionBs(String? commissionBs) => this(commissionBs: commissionBs);

  @override
  JobDto netBs(String? netBs) => this(netBs: netBs);

  @override
  JobDto timeline(JobTimelineDto timeline) => this(timeline: timeline);

  @override
  JobDto autoConfirmed(bool autoConfirmed) =>
      this(autoConfirmed: autoConfirmed);

  @override
  JobDto autoConfirmAt(DateTime? autoConfirmAt) =>
      this(autoConfirmAt: autoConfirmAt);

  @override
  JobDto cancellation(JobCancellationDto? cancellation) =>
      this(cancellation: cancellation);

  @override
  JobDto reviews(JobReviewsDto reviews) => this(reviews: reviews);

  @override
  JobDto allowedActions(List<JobDtoAllowedActionsEnum> allowedActions) =>
      this(allowedActions: allowedActions);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? requestId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? myRole = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? counterpart = const $CopyWithPlaceholder(),
    Object? finalPriceBs = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
    Object? netBs = const $CopyWithPlaceholder(),
    Object? timeline = const $CopyWithPlaceholder(),
    Object? autoConfirmed = const $CopyWithPlaceholder(),
    Object? autoConfirmAt = const $CopyWithPlaceholder(),
    Object? cancellation = const $CopyWithPlaceholder(),
    Object? reviews = const $CopyWithPlaceholder(),
    Object? allowedActions = const $CopyWithPlaceholder(),
  }) {
    return JobDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      requestId: requestId == const $CopyWithPlaceholder()
          ? _value.requestId
          // ignore: cast_nullable_to_non_nullable
          : requestId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as JobDtoStatusEnum,
      myRole: myRole == const $CopyWithPlaceholder()
          ? _value.myRole
          // ignore: cast_nullable_to_non_nullable
          : myRole as JobDtoMyRoleEnum,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as JobCategoryDto,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String,
      counterpart: counterpart == const $CopyWithPlaceholder()
          ? _value.counterpart
          // ignore: cast_nullable_to_non_nullable
          : counterpart as JobCounterpartDto,
      finalPriceBs: finalPriceBs == const $CopyWithPlaceholder()
          ? _value.finalPriceBs
          // ignore: cast_nullable_to_non_nullable
          : finalPriceBs as String,
      commissionBs: commissionBs == const $CopyWithPlaceholder()
          ? _value.commissionBs
          // ignore: cast_nullable_to_non_nullable
          : commissionBs as String?,
      netBs: netBs == const $CopyWithPlaceholder()
          ? _value.netBs
          // ignore: cast_nullable_to_non_nullable
          : netBs as String?,
      timeline: timeline == const $CopyWithPlaceholder()
          ? _value.timeline
          // ignore: cast_nullable_to_non_nullable
          : timeline as JobTimelineDto,
      autoConfirmed: autoConfirmed == const $CopyWithPlaceholder()
          ? _value.autoConfirmed
          // ignore: cast_nullable_to_non_nullable
          : autoConfirmed as bool,
      autoConfirmAt: autoConfirmAt == const $CopyWithPlaceholder()
          ? _value.autoConfirmAt
          // ignore: cast_nullable_to_non_nullable
          : autoConfirmAt as DateTime?,
      cancellation: cancellation == const $CopyWithPlaceholder()
          ? _value.cancellation
          // ignore: cast_nullable_to_non_nullable
          : cancellation as JobCancellationDto?,
      reviews: reviews == const $CopyWithPlaceholder()
          ? _value.reviews
          // ignore: cast_nullable_to_non_nullable
          : reviews as JobReviewsDto,
      allowedActions: allowedActions == const $CopyWithPlaceholder()
          ? _value.allowedActions
          // ignore: cast_nullable_to_non_nullable
          : allowedActions as List<JobDtoAllowedActionsEnum>,
    );
  }
}

extension $JobDtoCopyWith on JobDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobDto.copyWith(...)` or like so:`instanceOfJobDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobDtoCWProxy get copyWith => _$JobDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDto _$JobDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'requestId',
          'status',
          'myRole',
          'category',
          'description',
          'counterpart',
          'finalPriceBs',
          'commissionBs',
          'netBs',
          'timeline',
          'autoConfirmed',
          'autoConfirmAt',
          'cancellation',
          'reviews',
          'allowedActions',
        ],
      );
      final val = JobDto(
        id: $checkedConvert('id', (v) => v as String),
        requestId: $checkedConvert('requestId', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$JobDtoStatusEnumEnumMap, v),
        ),
        myRole: $checkedConvert(
          'myRole',
          (v) => $enumDecode(_$JobDtoMyRoleEnumEnumMap, v),
        ),
        category: $checkedConvert(
          'category',
          (v) => JobCategoryDto.fromJson(v as Map<String, dynamic>),
        ),
        description: $checkedConvert('description', (v) => v as String),
        counterpart: $checkedConvert(
          'counterpart',
          (v) => JobCounterpartDto.fromJson(v as Map<String, dynamic>),
        ),
        finalPriceBs: $checkedConvert('finalPriceBs', (v) => v as String),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String?),
        netBs: $checkedConvert('netBs', (v) => v as String?),
        timeline: $checkedConvert(
          'timeline',
          (v) => JobTimelineDto.fromJson(v as Map<String, dynamic>),
        ),
        autoConfirmed: $checkedConvert('autoConfirmed', (v) => v as bool),
        autoConfirmAt: $checkedConvert(
          'autoConfirmAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        cancellation: $checkedConvert(
          'cancellation',
          (v) => v == null
              ? null
              : JobCancellationDto.fromJson(v as Map<String, dynamic>),
        ),
        reviews: $checkedConvert(
          'reviews',
          (v) => JobReviewsDto.fromJson(v as Map<String, dynamic>),
        ),
        allowedActions: $checkedConvert(
          'allowedActions',
          (v) => (v as List<dynamic>)
              .map((e) => $enumDecode(_$JobDtoAllowedActionsEnumEnumMap, e))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JobDtoToJson(JobDto instance) => <String, dynamic>{
  'id': instance.id,
  'requestId': instance.requestId,
  'status': _$JobDtoStatusEnumEnumMap[instance.status]!,
  'myRole': _$JobDtoMyRoleEnumEnumMap[instance.myRole]!,
  'category': instance.category.toJson(),
  'description': instance.description,
  'counterpart': instance.counterpart.toJson(),
  'finalPriceBs': instance.finalPriceBs,
  'commissionBs': instance.commissionBs,
  'netBs': instance.netBs,
  'timeline': instance.timeline.toJson(),
  'autoConfirmed': instance.autoConfirmed,
  'autoConfirmAt': instance.autoConfirmAt?.toIso8601String(),
  'cancellation': instance.cancellation?.toJson(),
  'reviews': instance.reviews.toJson(),
  'allowedActions': instance.allowedActions
      .map((e) => _$JobDtoAllowedActionsEnumEnumMap[e]!)
      .toList(),
};

const _$JobDtoStatusEnumEnumMap = {
  JobDtoStatusEnum.asignado: 'asignado',
  JobDtoStatusEnum.enCamino: 'en_camino',
  JobDtoStatusEnum.enCurso: 'en_curso',
  JobDtoStatusEnum.terminado: 'terminado',
  JobDtoStatusEnum.cancelado: 'cancelado',
};

const _$JobDtoMyRoleEnumEnumMap = {
  JobDtoMyRoleEnum.worker: 'worker',
  JobDtoMyRoleEnum.employer: 'employer',
};

const _$JobDtoAllowedActionsEnumEnumMap = {
  JobDtoAllowedActionsEnum.START_TRIP: 'START_TRIP',
  JobDtoAllowedActionsEnum.START_WORK: 'START_WORK',
  JobDtoAllowedActionsEnum.FINISH: 'FINISH',
  JobDtoAllowedActionsEnum.CONFIRM: 'CONFIRM',
  JobDtoAllowedActionsEnum.AUTO_CONFIRM: 'AUTO_CONFIRM',
  JobDtoAllowedActionsEnum.DISPUTE: 'DISPUTE',
  JobDtoAllowedActionsEnum.RESOLVE_CONFIRM: 'RESOLVE_CONFIRM',
  JobDtoAllowedActionsEnum.RESOLVE_CANCEL: 'RESOLVE_CANCEL',
  JobDtoAllowedActionsEnum.CANCEL: 'CANCEL',
};

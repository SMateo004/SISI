// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_disputed_job_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminDisputedJobDtoCWProxy {
  AdminDisputedJobDto id(String id);

  AdminDisputedJobDto requestId(String requestId);

  AdminDisputedJobDto workerId(String workerId);

  AdminDisputedJobDto employerId(String employerId);

  AdminDisputedJobDto category(JobCategoryDto category);

  AdminDisputedJobDto finalPriceBs(String finalPriceBs);

  AdminDisputedJobDto workerFinishedAt(DateTime workerFinishedAt);

  AdminDisputedJobDto disputedAt(DateTime disputedAt);

  AdminDisputedJobDto disputeNote(String? disputeNote);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminDisputedJobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminDisputedJobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminDisputedJobDto call({
    String id,
    String requestId,
    String workerId,
    String employerId,
    JobCategoryDto category,
    String finalPriceBs,
    DateTime workerFinishedAt,
    DateTime disputedAt,
    String? disputeNote,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminDisputedJobDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminDisputedJobDto.copyWith.fieldName(...)`
class _$AdminDisputedJobDtoCWProxyImpl implements _$AdminDisputedJobDtoCWProxy {
  const _$AdminDisputedJobDtoCWProxyImpl(this._value);

  final AdminDisputedJobDto _value;

  @override
  AdminDisputedJobDto id(String id) => this(id: id);

  @override
  AdminDisputedJobDto requestId(String requestId) => this(requestId: requestId);

  @override
  AdminDisputedJobDto workerId(String workerId) => this(workerId: workerId);

  @override
  AdminDisputedJobDto employerId(String employerId) =>
      this(employerId: employerId);

  @override
  AdminDisputedJobDto category(JobCategoryDto category) =>
      this(category: category);

  @override
  AdminDisputedJobDto finalPriceBs(String finalPriceBs) =>
      this(finalPriceBs: finalPriceBs);

  @override
  AdminDisputedJobDto workerFinishedAt(DateTime workerFinishedAt) =>
      this(workerFinishedAt: workerFinishedAt);

  @override
  AdminDisputedJobDto disputedAt(DateTime disputedAt) =>
      this(disputedAt: disputedAt);

  @override
  AdminDisputedJobDto disputeNote(String? disputeNote) =>
      this(disputeNote: disputeNote);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminDisputedJobDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminDisputedJobDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminDisputedJobDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? requestId = const $CopyWithPlaceholder(),
    Object? workerId = const $CopyWithPlaceholder(),
    Object? employerId = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? finalPriceBs = const $CopyWithPlaceholder(),
    Object? workerFinishedAt = const $CopyWithPlaceholder(),
    Object? disputedAt = const $CopyWithPlaceholder(),
    Object? disputeNote = const $CopyWithPlaceholder(),
  }) {
    return AdminDisputedJobDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      requestId: requestId == const $CopyWithPlaceholder()
          ? _value.requestId
          // ignore: cast_nullable_to_non_nullable
          : requestId as String,
      workerId: workerId == const $CopyWithPlaceholder()
          ? _value.workerId
          // ignore: cast_nullable_to_non_nullable
          : workerId as String,
      employerId: employerId == const $CopyWithPlaceholder()
          ? _value.employerId
          // ignore: cast_nullable_to_non_nullable
          : employerId as String,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as JobCategoryDto,
      finalPriceBs: finalPriceBs == const $CopyWithPlaceholder()
          ? _value.finalPriceBs
          // ignore: cast_nullable_to_non_nullable
          : finalPriceBs as String,
      workerFinishedAt: workerFinishedAt == const $CopyWithPlaceholder()
          ? _value.workerFinishedAt
          // ignore: cast_nullable_to_non_nullable
          : workerFinishedAt as DateTime,
      disputedAt: disputedAt == const $CopyWithPlaceholder()
          ? _value.disputedAt
          // ignore: cast_nullable_to_non_nullable
          : disputedAt as DateTime,
      disputeNote: disputeNote == const $CopyWithPlaceholder()
          ? _value.disputeNote
          // ignore: cast_nullable_to_non_nullable
          : disputeNote as String?,
    );
  }
}

extension $AdminDisputedJobDtoCopyWith on AdminDisputedJobDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminDisputedJobDto.copyWith(...)` or like so:`instanceOfAdminDisputedJobDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminDisputedJobDtoCWProxy get copyWith =>
      _$AdminDisputedJobDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminDisputedJobDto _$AdminDisputedJobDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminDisputedJobDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'requestId',
          'workerId',
          'employerId',
          'category',
          'finalPriceBs',
          'workerFinishedAt',
          'disputedAt',
          'disputeNote',
        ],
      );
      final val = AdminDisputedJobDto(
        id: $checkedConvert('id', (v) => v as String),
        requestId: $checkedConvert('requestId', (v) => v as String),
        workerId: $checkedConvert('workerId', (v) => v as String),
        employerId: $checkedConvert('employerId', (v) => v as String),
        category: $checkedConvert(
          'category',
          (v) => JobCategoryDto.fromJson(v as Map<String, dynamic>),
        ),
        finalPriceBs: $checkedConvert('finalPriceBs', (v) => v as String),
        workerFinishedAt: $checkedConvert(
          'workerFinishedAt',
          (v) => DateTime.parse(v as String),
        ),
        disputedAt: $checkedConvert(
          'disputedAt',
          (v) => DateTime.parse(v as String),
        ),
        disputeNote: $checkedConvert('disputeNote', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminDisputedJobDtoToJson(
  AdminDisputedJobDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'requestId': instance.requestId,
  'workerId': instance.workerId,
  'employerId': instance.employerId,
  'category': instance.category.toJson(),
  'finalPriceBs': instance.finalPriceBs,
  'workerFinishedAt': instance.workerFinishedAt.toIso8601String(),
  'disputedAt': instance.disputedAt.toIso8601String(),
  'disputeNote': instance.disputeNote,
};

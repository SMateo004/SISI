// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_reviews_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobReviewsDtoCWProxy {
  JobReviewsDto canReview(bool canReview);

  JobReviewsDto deadline(DateTime? deadline);

  JobReviewsDto mine(MyReviewDto? mine);

  JobReviewsDto theirs(ReceivedReviewDto? theirs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobReviewsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobReviewsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobReviewsDto call({
    bool canReview,
    DateTime? deadline,
    MyReviewDto? mine,
    ReceivedReviewDto? theirs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobReviewsDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobReviewsDto.copyWith.fieldName(...)`
class _$JobReviewsDtoCWProxyImpl implements _$JobReviewsDtoCWProxy {
  const _$JobReviewsDtoCWProxyImpl(this._value);

  final JobReviewsDto _value;

  @override
  JobReviewsDto canReview(bool canReview) => this(canReview: canReview);

  @override
  JobReviewsDto deadline(DateTime? deadline) => this(deadline: deadline);

  @override
  JobReviewsDto mine(MyReviewDto? mine) => this(mine: mine);

  @override
  JobReviewsDto theirs(ReceivedReviewDto? theirs) => this(theirs: theirs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobReviewsDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobReviewsDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobReviewsDto call({
    Object? canReview = const $CopyWithPlaceholder(),
    Object? deadline = const $CopyWithPlaceholder(),
    Object? mine = const $CopyWithPlaceholder(),
    Object? theirs = const $CopyWithPlaceholder(),
  }) {
    return JobReviewsDto(
      canReview: canReview == const $CopyWithPlaceholder()
          ? _value.canReview
          // ignore: cast_nullable_to_non_nullable
          : canReview as bool,
      deadline: deadline == const $CopyWithPlaceholder()
          ? _value.deadline
          // ignore: cast_nullable_to_non_nullable
          : deadline as DateTime?,
      mine: mine == const $CopyWithPlaceholder()
          ? _value.mine
          // ignore: cast_nullable_to_non_nullable
          : mine as MyReviewDto?,
      theirs: theirs == const $CopyWithPlaceholder()
          ? _value.theirs
          // ignore: cast_nullable_to_non_nullable
          : theirs as ReceivedReviewDto?,
    );
  }
}

extension $JobReviewsDtoCopyWith on JobReviewsDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobReviewsDto.copyWith(...)` or like so:`instanceOfJobReviewsDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobReviewsDtoCWProxy get copyWith => _$JobReviewsDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobReviewsDto _$JobReviewsDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobReviewsDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['canReview', 'deadline', 'mine', 'theirs'],
      );
      final val = JobReviewsDto(
        canReview: $checkedConvert('canReview', (v) => v as bool),
        deadline: $checkedConvert(
          'deadline',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        mine: $checkedConvert(
          'mine',
          (v) => v == null
              ? null
              : MyReviewDto.fromJson(v as Map<String, dynamic>),
        ),
        theirs: $checkedConvert(
          'theirs',
          (v) => v == null
              ? null
              : ReceivedReviewDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JobReviewsDtoToJson(JobReviewsDto instance) =>
    <String, dynamic>{
      'canReview': instance.canReview,
      'deadline': instance.deadline?.toIso8601String(),
      'mine': instance.mine?.toJson(),
      'theirs': instance.theirs?.toJson(),
    };

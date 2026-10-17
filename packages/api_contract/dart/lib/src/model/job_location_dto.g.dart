// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_location_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobLocationDtoCWProxy {
  JobLocationDto jobId(String jobId);

  JobLocationDto location(TrackedPointDto? location);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobLocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobLocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobLocationDto call({String jobId, TrackedPointDto? location});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobLocationDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobLocationDto.copyWith.fieldName(...)`
class _$JobLocationDtoCWProxyImpl implements _$JobLocationDtoCWProxy {
  const _$JobLocationDtoCWProxyImpl(this._value);

  final JobLocationDto _value;

  @override
  JobLocationDto jobId(String jobId) => this(jobId: jobId);

  @override
  JobLocationDto location(TrackedPointDto? location) =>
      this(location: location);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobLocationDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobLocationDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobLocationDto call({
    Object? jobId = const $CopyWithPlaceholder(),
    Object? location = const $CopyWithPlaceholder(),
  }) {
    return JobLocationDto(
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String,
      location: location == const $CopyWithPlaceholder()
          ? _value.location
          // ignore: cast_nullable_to_non_nullable
          : location as TrackedPointDto?,
    );
  }
}

extension $JobLocationDtoCopyWith on JobLocationDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobLocationDto.copyWith(...)` or like so:`instanceOfJobLocationDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobLocationDtoCWProxy get copyWith => _$JobLocationDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobLocationDto _$JobLocationDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobLocationDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['jobId', 'location']);
      final val = JobLocationDto(
        jobId: $checkedConvert('jobId', (v) => v as String),
        location: $checkedConvert(
          'location',
          (v) => v == null
              ? null
              : TrackedPointDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$JobLocationDtoToJson(JobLocationDto instance) =>
    <String, dynamic>{
      'jobId': instance.jobId,
      'location': instance.location?.toJson(),
    };

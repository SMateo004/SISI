// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_counterpart_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobCounterpartDtoCWProxy {
  JobCounterpartDto userId(String userId);

  JobCounterpartDto shortName(String shortName);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCounterpartDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCounterpartDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCounterpartDto call({String userId, String shortName});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobCounterpartDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobCounterpartDto.copyWith.fieldName(...)`
class _$JobCounterpartDtoCWProxyImpl implements _$JobCounterpartDtoCWProxy {
  const _$JobCounterpartDtoCWProxyImpl(this._value);

  final JobCounterpartDto _value;

  @override
  JobCounterpartDto userId(String userId) => this(userId: userId);

  @override
  JobCounterpartDto shortName(String shortName) => this(shortName: shortName);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCounterpartDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCounterpartDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCounterpartDto call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? shortName = const $CopyWithPlaceholder(),
  }) {
    return JobCounterpartDto(
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      shortName: shortName == const $CopyWithPlaceholder()
          ? _value.shortName
          // ignore: cast_nullable_to_non_nullable
          : shortName as String,
    );
  }
}

extension $JobCounterpartDtoCopyWith on JobCounterpartDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobCounterpartDto.copyWith(...)` or like so:`instanceOfJobCounterpartDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobCounterpartDtoCWProxy get copyWith =>
      _$JobCounterpartDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobCounterpartDto _$JobCounterpartDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobCounterpartDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['userId', 'shortName']);
      final val = JobCounterpartDto(
        userId: $checkedConvert('userId', (v) => v as String),
        shortName: $checkedConvert('shortName', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$JobCounterpartDtoToJson(JobCounterpartDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'shortName': instance.shortName,
    };

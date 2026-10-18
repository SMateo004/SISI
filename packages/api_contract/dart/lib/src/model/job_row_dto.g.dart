// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobRowDtoCWProxy {
  JobRowDto id(String id);

  JobRowDto as_(JobRowDtoAs_Enum as_);

  JobRowDto status(String status);

  JobRowDto categoryName(String categoryName);

  JobRowDto finalPriceBs(String finalPriceBs);

  JobRowDto assignedAt(DateTime assignedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobRowDto call({
    String id,
    JobRowDtoAs_Enum as_,
    String status,
    String categoryName,
    String finalPriceBs,
    DateTime assignedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobRowDto.copyWith.fieldName(...)`
class _$JobRowDtoCWProxyImpl implements _$JobRowDtoCWProxy {
  const _$JobRowDtoCWProxyImpl(this._value);

  final JobRowDto _value;

  @override
  JobRowDto id(String id) => this(id: id);

  @override
  JobRowDto as_(JobRowDtoAs_Enum as_) => this(as_: as_);

  @override
  JobRowDto status(String status) => this(status: status);

  @override
  JobRowDto categoryName(String categoryName) =>
      this(categoryName: categoryName);

  @override
  JobRowDto finalPriceBs(String finalPriceBs) =>
      this(finalPriceBs: finalPriceBs);

  @override
  JobRowDto assignedAt(DateTime assignedAt) => this(assignedAt: assignedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobRowDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? as_ = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? categoryName = const $CopyWithPlaceholder(),
    Object? finalPriceBs = const $CopyWithPlaceholder(),
    Object? assignedAt = const $CopyWithPlaceholder(),
  }) {
    return JobRowDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      as_: as_ == const $CopyWithPlaceholder()
          ? _value.as_
          // ignore: cast_nullable_to_non_nullable
          : as_ as JobRowDtoAs_Enum,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      categoryName: categoryName == const $CopyWithPlaceholder()
          ? _value.categoryName
          // ignore: cast_nullable_to_non_nullable
          : categoryName as String,
      finalPriceBs: finalPriceBs == const $CopyWithPlaceholder()
          ? _value.finalPriceBs
          // ignore: cast_nullable_to_non_nullable
          : finalPriceBs as String,
      assignedAt: assignedAt == const $CopyWithPlaceholder()
          ? _value.assignedAt
          // ignore: cast_nullable_to_non_nullable
          : assignedAt as DateTime,
    );
  }
}

extension $JobRowDtoCopyWith on JobRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobRowDto.copyWith(...)` or like so:`instanceOfJobRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobRowDtoCWProxy get copyWith => _$JobRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobRowDto _$JobRowDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobRowDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'as',
          'status',
          'categoryName',
          'finalPriceBs',
          'assignedAt',
        ],
      );
      final val = JobRowDto(
        id: $checkedConvert('id', (v) => v as String),
        as_: $checkedConvert(
          'as',
          (v) => $enumDecode(_$JobRowDtoAs_EnumEnumMap, v),
        ),
        status: $checkedConvert('status', (v) => v as String),
        categoryName: $checkedConvert('categoryName', (v) => v as String),
        finalPriceBs: $checkedConvert('finalPriceBs', (v) => v as String),
        assignedAt: $checkedConvert(
          'assignedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    }, fieldKeyMap: const {'as_': 'as'});

Map<String, dynamic> _$JobRowDtoToJson(JobRowDto instance) => <String, dynamic>{
  'id': instance.id,
  'as': _$JobRowDtoAs_EnumEnumMap[instance.as_]!,
  'status': instance.status,
  'categoryName': instance.categoryName,
  'finalPriceBs': instance.finalPriceBs,
  'assignedAt': instance.assignedAt.toIso8601String(),
};

const _$JobRowDtoAs_EnumEnumMap = {
  JobRowDtoAs_Enum.worker: 'worker',
  JobRowDtoAs_Enum.employer: 'employer',
};

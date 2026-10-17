// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_page_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobPageDtoCWProxy {
  JobPageDto items(List<JobDto> items);

  JobPageDto nextCursor(String? nextCursor);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobPageDto call({List<JobDto> items, String? nextCursor});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobPageDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobPageDto.copyWith.fieldName(...)`
class _$JobPageDtoCWProxyImpl implements _$JobPageDtoCWProxy {
  const _$JobPageDtoCWProxyImpl(this._value);

  final JobPageDto _value;

  @override
  JobPageDto items(List<JobDto> items) => this(items: items);

  @override
  JobPageDto nextCursor(String? nextCursor) => this(nextCursor: nextCursor);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobPageDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobPageDto(...).copyWith(id: 12, name: "My name")
  /// ````
  JobPageDto call({
    Object? items = const $CopyWithPlaceholder(),
    Object? nextCursor = const $CopyWithPlaceholder(),
  }) {
    return JobPageDto(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<JobDto>,
      nextCursor: nextCursor == const $CopyWithPlaceholder()
          ? _value.nextCursor
          // ignore: cast_nullable_to_non_nullable
          : nextCursor as String?,
    );
  }
}

extension $JobPageDtoCopyWith on JobPageDto {
  /// Returns a callable class that can be used as follows: `instanceOfJobPageDto.copyWith(...)` or like so:`instanceOfJobPageDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobPageDtoCWProxy get copyWith => _$JobPageDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobPageDto _$JobPageDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobPageDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items', 'nextCursor']);
      final val = JobPageDto(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => JobDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        nextCursor: $checkedConvert('nextCursor', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$JobPageDtoToJson(JobPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'nextCursor': instance.nextCursor,
    };

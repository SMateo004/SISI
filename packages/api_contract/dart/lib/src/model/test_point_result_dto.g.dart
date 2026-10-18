// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_point_result_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TestPointResultDtoCWProxy {
  TestPointResultDto inside(bool inside);

  TestPointResultDto by(TestPointResultDtoByEnum by);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestPointResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestPointResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TestPointResultDto call({bool inside, TestPointResultDtoByEnum by});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTestPointResultDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTestPointResultDto.copyWith.fieldName(...)`
class _$TestPointResultDtoCWProxyImpl implements _$TestPointResultDtoCWProxy {
  const _$TestPointResultDtoCWProxyImpl(this._value);

  final TestPointResultDto _value;

  @override
  TestPointResultDto inside(bool inside) => this(inside: inside);

  @override
  TestPointResultDto by(TestPointResultDtoByEnum by) => this(by: by);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestPointResultDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestPointResultDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TestPointResultDto call({
    Object? inside = const $CopyWithPlaceholder(),
    Object? by = const $CopyWithPlaceholder(),
  }) {
    return TestPointResultDto(
      inside: inside == const $CopyWithPlaceholder()
          ? _value.inside
          // ignore: cast_nullable_to_non_nullable
          : inside as bool,
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as TestPointResultDtoByEnum,
    );
  }
}

extension $TestPointResultDtoCopyWith on TestPointResultDto {
  /// Returns a callable class that can be used as follows: `instanceOfTestPointResultDto.copyWith(...)` or like so:`instanceOfTestPointResultDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TestPointResultDtoCWProxy get copyWith =>
      _$TestPointResultDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestPointResultDto _$TestPointResultDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TestPointResultDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['inside', 'by']);
      final val = TestPointResultDto(
        inside: $checkedConvert('inside', (v) => v as bool),
        by: $checkedConvert(
          'by',
          (v) => $enumDecode(_$TestPointResultDtoByEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TestPointResultDtoToJson(TestPointResultDto instance) =>
    <String, dynamic>{
      'inside': instance.inside,
      'by': _$TestPointResultDtoByEnumEnumMap[instance.by]!,
    };

const _$TestPointResultDtoByEnumEnumMap = {
  TestPointResultDtoByEnum.polygon: 'polygon',
  TestPointResultDtoByEnum.radius: 'radius',
  TestPointResultDtoByEnum.none: 'none',
};

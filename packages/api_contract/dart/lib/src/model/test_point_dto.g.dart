// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_point_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TestPointDtoCWProxy {
  TestPointDto lat(num lat);

  TestPointDto lng(num lng);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestPointDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestPointDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TestPointDto call({num lat, num lng});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTestPointDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTestPointDto.copyWith.fieldName(...)`
class _$TestPointDtoCWProxyImpl implements _$TestPointDtoCWProxy {
  const _$TestPointDtoCWProxyImpl(this._value);

  final TestPointDto _value;

  @override
  TestPointDto lat(num lat) => this(lat: lat);

  @override
  TestPointDto lng(num lng) => this(lng: lng);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestPointDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestPointDto(...).copyWith(id: 12, name: "My name")
  /// ````
  TestPointDto call({
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
  }) {
    return TestPointDto(
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as num,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as num,
    );
  }
}

extension $TestPointDtoCopyWith on TestPointDto {
  /// Returns a callable class that can be used as follows: `instanceOfTestPointDto.copyWith(...)` or like so:`instanceOfTestPointDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TestPointDtoCWProxy get copyWith => _$TestPointDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestPointDto _$TestPointDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TestPointDto', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['lat', 'lng']);
      final val = TestPointDto(
        lat: $checkedConvert('lat', (v) => v as num),
        lng: $checkedConvert('lng', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$TestPointDtoToJson(TestPointDto instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

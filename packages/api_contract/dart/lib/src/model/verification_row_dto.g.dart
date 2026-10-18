// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_row_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationRowDtoCWProxy {
  VerificationRowDto userId(String userId);

  VerificationRowDto name(String? name);

  VerificationRowDto phone(String phone);

  VerificationRowDto cityName(String cityName);

  VerificationRowDto submittedAt(DateTime submittedAt);

  VerificationRowDto categories(List<String> categories);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationRowDto call({
    String userId,
    String? name,
    String phone,
    String cityName,
    DateTime submittedAt,
    List<String> categories,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationRowDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationRowDto.copyWith.fieldName(...)`
class _$VerificationRowDtoCWProxyImpl implements _$VerificationRowDtoCWProxy {
  const _$VerificationRowDtoCWProxyImpl(this._value);

  final VerificationRowDto _value;

  @override
  VerificationRowDto userId(String userId) => this(userId: userId);

  @override
  VerificationRowDto name(String? name) => this(name: name);

  @override
  VerificationRowDto phone(String phone) => this(phone: phone);

  @override
  VerificationRowDto cityName(String cityName) => this(cityName: cityName);

  @override
  VerificationRowDto submittedAt(DateTime submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  VerificationRowDto categories(List<String> categories) =>
      this(categories: categories);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationRowDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationRowDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationRowDto call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? categories = const $CopyWithPlaceholder(),
  }) {
    return VerificationRowDto(
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      cityName: cityName == const $CopyWithPlaceholder()
          ? _value.cityName
          // ignore: cast_nullable_to_non_nullable
          : cityName as String,
      submittedAt: submittedAt == const $CopyWithPlaceholder()
          ? _value.submittedAt
          // ignore: cast_nullable_to_non_nullable
          : submittedAt as DateTime,
      categories: categories == const $CopyWithPlaceholder()
          ? _value.categories
          // ignore: cast_nullable_to_non_nullable
          : categories as List<String>,
    );
  }
}

extension $VerificationRowDtoCopyWith on VerificationRowDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationRowDto.copyWith(...)` or like so:`instanceOfVerificationRowDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationRowDtoCWProxy get copyWith =>
      _$VerificationRowDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationRowDto _$VerificationRowDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VerificationRowDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'userId',
          'name',
          'phone',
          'cityName',
          'submittedAt',
          'categories',
        ],
      );
      final val = VerificationRowDto(
        userId: $checkedConvert('userId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String),
        cityName: $checkedConvert('cityName', (v) => v as String),
        submittedAt: $checkedConvert(
          'submittedAt',
          (v) => DateTime.parse(v as String),
        ),
        categories: $checkedConvert(
          'categories',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$VerificationRowDtoToJson(VerificationRowDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'cityName': instance.cityName,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'categories': instance.categories,
    };

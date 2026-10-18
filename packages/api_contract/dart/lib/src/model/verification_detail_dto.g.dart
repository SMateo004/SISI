// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_detail_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerificationDetailDtoCWProxy {
  VerificationDetailDto userId(String userId);

  VerificationDetailDto name(String? name);

  VerificationDetailDto phone(String phone);

  VerificationDetailDto cityName(String cityName);

  VerificationDetailDto submittedAt(DateTime submittedAt);

  VerificationDetailDto categories(List<String> categories);

  VerificationDetailDto status(String status);

  VerificationDetailDto birthDate(DateTime? birthDate);

  VerificationDetailDto age(num? age);

  VerificationDetailDto transport(String? transport);

  VerificationDetailDto maxRadiusKm(num? maxRadiusKm);

  VerificationDetailDto categoryDetails(
    List<VerificationCategoryDto> categoryDetails,
  );

  VerificationDetailDto documents(List<VerificationDocumentDto> documents);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDetailDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDetailDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDetailDto call({
    String userId,
    String? name,
    String phone,
    String cityName,
    DateTime submittedAt,
    List<String> categories,
    String status,
    DateTime? birthDate,
    num? age,
    String? transport,
    num? maxRadiusKm,
    List<VerificationCategoryDto> categoryDetails,
    List<VerificationDocumentDto> documents,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerificationDetailDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerificationDetailDto.copyWith.fieldName(...)`
class _$VerificationDetailDtoCWProxyImpl
    implements _$VerificationDetailDtoCWProxy {
  const _$VerificationDetailDtoCWProxyImpl(this._value);

  final VerificationDetailDto _value;

  @override
  VerificationDetailDto userId(String userId) => this(userId: userId);

  @override
  VerificationDetailDto name(String? name) => this(name: name);

  @override
  VerificationDetailDto phone(String phone) => this(phone: phone);

  @override
  VerificationDetailDto cityName(String cityName) => this(cityName: cityName);

  @override
  VerificationDetailDto submittedAt(DateTime submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  VerificationDetailDto categories(List<String> categories) =>
      this(categories: categories);

  @override
  VerificationDetailDto status(String status) => this(status: status);

  @override
  VerificationDetailDto birthDate(DateTime? birthDate) =>
      this(birthDate: birthDate);

  @override
  VerificationDetailDto age(num? age) => this(age: age);

  @override
  VerificationDetailDto transport(String? transport) =>
      this(transport: transport);

  @override
  VerificationDetailDto maxRadiusKm(num? maxRadiusKm) =>
      this(maxRadiusKm: maxRadiusKm);

  @override
  VerificationDetailDto categoryDetails(
    List<VerificationCategoryDto> categoryDetails,
  ) => this(categoryDetails: categoryDetails);

  @override
  VerificationDetailDto documents(List<VerificationDocumentDto> documents) =>
      this(documents: documents);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerificationDetailDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerificationDetailDto(...).copyWith(id: 12, name: "My name")
  /// ````
  VerificationDetailDto call({
    Object? userId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? cityName = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? categories = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? birthDate = const $CopyWithPlaceholder(),
    Object? age = const $CopyWithPlaceholder(),
    Object? transport = const $CopyWithPlaceholder(),
    Object? maxRadiusKm = const $CopyWithPlaceholder(),
    Object? categoryDetails = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
  }) {
    return VerificationDetailDto(
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
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      birthDate: birthDate == const $CopyWithPlaceholder()
          ? _value.birthDate
          // ignore: cast_nullable_to_non_nullable
          : birthDate as DateTime?,
      age: age == const $CopyWithPlaceholder()
          ? _value.age
          // ignore: cast_nullable_to_non_nullable
          : age as num?,
      transport: transport == const $CopyWithPlaceholder()
          ? _value.transport
          // ignore: cast_nullable_to_non_nullable
          : transport as String?,
      maxRadiusKm: maxRadiusKm == const $CopyWithPlaceholder()
          ? _value.maxRadiusKm
          // ignore: cast_nullable_to_non_nullable
          : maxRadiusKm as num?,
      categoryDetails: categoryDetails == const $CopyWithPlaceholder()
          ? _value.categoryDetails
          // ignore: cast_nullable_to_non_nullable
          : categoryDetails as List<VerificationCategoryDto>,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<VerificationDocumentDto>,
    );
  }
}

extension $VerificationDetailDtoCopyWith on VerificationDetailDto {
  /// Returns a callable class that can be used as follows: `instanceOfVerificationDetailDto.copyWith(...)` or like so:`instanceOfVerificationDetailDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerificationDetailDtoCWProxy get copyWith =>
      _$VerificationDetailDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationDetailDto _$VerificationDetailDtoFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerificationDetailDto', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'userId',
      'name',
      'phone',
      'cityName',
      'submittedAt',
      'categories',
      'status',
      'birthDate',
      'age',
      'transport',
      'maxRadiusKm',
      'categoryDetails',
      'documents',
    ],
  );
  final val = VerificationDetailDto(
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
    status: $checkedConvert('status', (v) => v as String),
    birthDate: $checkedConvert(
      'birthDate',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    age: $checkedConvert('age', (v) => v as num?),
    transport: $checkedConvert('transport', (v) => v as String?),
    maxRadiusKm: $checkedConvert('maxRadiusKm', (v) => v as num?),
    categoryDetails: $checkedConvert(
      'categoryDetails',
      (v) => (v as List<dynamic>)
          .map(
            (e) => VerificationCategoryDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map(
            (e) => VerificationDocumentDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$VerificationDetailDtoToJson(
  VerificationDetailDto instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'name': instance.name,
  'phone': instance.phone,
  'cityName': instance.cityName,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'categories': instance.categories,
  'status': instance.status,
  'birthDate': instance.birthDate?.toIso8601String(),
  'age': instance.age,
  'transport': instance.transport,
  'maxRadiusKm': instance.maxRadiusKm,
  'categoryDetails': instance.categoryDetails.map((e) => e.toJson()).toList(),
  'documents': instance.documents.map((e) => e.toJson()).toList(),
};

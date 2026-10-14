// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CreateRequestDtoCWProxy {
  CreateRequestDto categoryId(String categoryId);

  CreateRequestDto description(String description);

  CreateRequestDto latitude(num latitude);

  CreateRequestDto longitude(num longitude);

  CreateRequestDto address(String address);

  CreateRequestDto proposedPriceBs(String proposedPriceBs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateRequestDto call({
    String categoryId,
    String description,
    num latitude,
    num longitude,
    String address,
    String proposedPriceBs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCreateRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCreateRequestDto.copyWith.fieldName(...)`
class _$CreateRequestDtoCWProxyImpl implements _$CreateRequestDtoCWProxy {
  const _$CreateRequestDtoCWProxyImpl(this._value);

  final CreateRequestDto _value;

  @override
  CreateRequestDto categoryId(String categoryId) =>
      this(categoryId: categoryId);

  @override
  CreateRequestDto description(String description) =>
      this(description: description);

  @override
  CreateRequestDto latitude(num latitude) => this(latitude: latitude);

  @override
  CreateRequestDto longitude(num longitude) => this(longitude: longitude);

  @override
  CreateRequestDto address(String address) => this(address: address);

  @override
  CreateRequestDto proposedPriceBs(String proposedPriceBs) =>
      this(proposedPriceBs: proposedPriceBs);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CreateRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CreateRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  CreateRequestDto call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? latitude = const $CopyWithPlaceholder(),
    Object? longitude = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? proposedPriceBs = const $CopyWithPlaceholder(),
  }) {
    return CreateRequestDto(
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as String,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String,
      latitude: latitude == const $CopyWithPlaceholder()
          ? _value.latitude
          // ignore: cast_nullable_to_non_nullable
          : latitude as num,
      longitude: longitude == const $CopyWithPlaceholder()
          ? _value.longitude
          // ignore: cast_nullable_to_non_nullable
          : longitude as num,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      proposedPriceBs: proposedPriceBs == const $CopyWithPlaceholder()
          ? _value.proposedPriceBs
          // ignore: cast_nullable_to_non_nullable
          : proposedPriceBs as String,
    );
  }
}

extension $CreateRequestDtoCopyWith on CreateRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfCreateRequestDto.copyWith(...)` or like so:`instanceOfCreateRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CreateRequestDtoCWProxy get copyWith => _$CreateRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRequestDto _$CreateRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CreateRequestDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'categoryId',
          'description',
          'latitude',
          'longitude',
          'address',
          'proposedPriceBs',
        ],
      );
      final val = CreateRequestDto(
        categoryId: $checkedConvert('categoryId', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        latitude: $checkedConvert('latitude', (v) => v as num),
        longitude: $checkedConvert('longitude', (v) => v as num),
        address: $checkedConvert('address', (v) => v as String),
        proposedPriceBs: $checkedConvert('proposedPriceBs', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CreateRequestDtoToJson(CreateRequestDto instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'proposedPriceBs': instance.proposedPriceBs,
    };

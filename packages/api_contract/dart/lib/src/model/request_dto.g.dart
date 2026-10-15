// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RequestDtoCWProxy {
  RequestDto id(String id);

  RequestDto status(RequestDtoStatusEnum status);

  RequestDto statusMessage(String? statusMessage);

  RequestDto category(RequestCategoryDto category);

  RequestDto cityId(String cityId);

  RequestDto description(String description);

  RequestDto latitude(num latitude);

  RequestDto longitude(num longitude);

  RequestDto address(String address);

  RequestDto proposedPriceBs(String proposedPriceBs);

  RequestDto photos(List<RequestPhotoDto> photos);

  RequestDto createdAt(String createdAt);

  RequestDto publishedAt(String? publishedAt);

  RequestDto cancelledAt(String? cancelledAt);

  RequestDto ring(num? ring);

  RequestDto totalRings(num totalRings);

  RequestDto jobId(String? jobId);

  RequestDto expiresAt(String? expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestDto call({
    String id,
    RequestDtoStatusEnum status,
    String? statusMessage,
    RequestCategoryDto category,
    String cityId,
    String description,
    num latitude,
    num longitude,
    String address,
    String proposedPriceBs,
    List<RequestPhotoDto> photos,
    String createdAt,
    String? publishedAt,
    String? cancelledAt,
    num? ring,
    num totalRings,
    String? jobId,
    String? expiresAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRequestDto.copyWith.fieldName(...)`
class _$RequestDtoCWProxyImpl implements _$RequestDtoCWProxy {
  const _$RequestDtoCWProxyImpl(this._value);

  final RequestDto _value;

  @override
  RequestDto id(String id) => this(id: id);

  @override
  RequestDto status(RequestDtoStatusEnum status) => this(status: status);

  @override
  RequestDto statusMessage(String? statusMessage) =>
      this(statusMessage: statusMessage);

  @override
  RequestDto category(RequestCategoryDto category) => this(category: category);

  @override
  RequestDto cityId(String cityId) => this(cityId: cityId);

  @override
  RequestDto description(String description) => this(description: description);

  @override
  RequestDto latitude(num latitude) => this(latitude: latitude);

  @override
  RequestDto longitude(num longitude) => this(longitude: longitude);

  @override
  RequestDto address(String address) => this(address: address);

  @override
  RequestDto proposedPriceBs(String proposedPriceBs) =>
      this(proposedPriceBs: proposedPriceBs);

  @override
  RequestDto photos(List<RequestPhotoDto> photos) => this(photos: photos);

  @override
  RequestDto createdAt(String createdAt) => this(createdAt: createdAt);

  @override
  RequestDto publishedAt(String? publishedAt) => this(publishedAt: publishedAt);

  @override
  RequestDto cancelledAt(String? cancelledAt) => this(cancelledAt: cancelledAt);

  @override
  RequestDto ring(num? ring) => this(ring: ring);

  @override
  RequestDto totalRings(num totalRings) => this(totalRings: totalRings);

  @override
  RequestDto jobId(String? jobId) => this(jobId: jobId);

  @override
  RequestDto expiresAt(String? expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  RequestDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? statusMessage = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? cityId = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? latitude = const $CopyWithPlaceholder(),
    Object? longitude = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? proposedPriceBs = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? publishedAt = const $CopyWithPlaceholder(),
    Object? cancelledAt = const $CopyWithPlaceholder(),
    Object? ring = const $CopyWithPlaceholder(),
    Object? totalRings = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return RequestDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as RequestDtoStatusEnum,
      statusMessage: statusMessage == const $CopyWithPlaceholder()
          ? _value.statusMessage
          // ignore: cast_nullable_to_non_nullable
          : statusMessage as String?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as RequestCategoryDto,
      cityId: cityId == const $CopyWithPlaceholder()
          ? _value.cityId
          // ignore: cast_nullable_to_non_nullable
          : cityId as String,
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
      photos: photos == const $CopyWithPlaceholder()
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<RequestPhotoDto>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as String,
      publishedAt: publishedAt == const $CopyWithPlaceholder()
          ? _value.publishedAt
          // ignore: cast_nullable_to_non_nullable
          : publishedAt as String?,
      cancelledAt: cancelledAt == const $CopyWithPlaceholder()
          ? _value.cancelledAt
          // ignore: cast_nullable_to_non_nullable
          : cancelledAt as String?,
      ring: ring == const $CopyWithPlaceholder()
          ? _value.ring
          // ignore: cast_nullable_to_non_nullable
          : ring as num?,
      totalRings: totalRings == const $CopyWithPlaceholder()
          ? _value.totalRings
          // ignore: cast_nullable_to_non_nullable
          : totalRings as num,
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String?,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as String?,
    );
  }
}

extension $RequestDtoCopyWith on RequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfRequestDto.copyWith(...)` or like so:`instanceOfRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RequestDtoCWProxy get copyWith => _$RequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDto _$RequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RequestDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'status',
          'category',
          'cityId',
          'description',
          'latitude',
          'longitude',
          'address',
          'proposedPriceBs',
          'photos',
          'createdAt',
          'ring',
          'totalRings',
          'jobId',
          'expiresAt',
        ],
      );
      final val = RequestDto(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$RequestDtoStatusEnumEnumMap, v),
        ),
        statusMessage: $checkedConvert('statusMessage', (v) => v as String?),
        category: $checkedConvert(
          'category',
          (v) => RequestCategoryDto.fromJson(v as Map<String, dynamic>),
        ),
        cityId: $checkedConvert('cityId', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
        latitude: $checkedConvert('latitude', (v) => v as num),
        longitude: $checkedConvert('longitude', (v) => v as num),
        address: $checkedConvert('address', (v) => v as String),
        proposedPriceBs: $checkedConvert('proposedPriceBs', (v) => v as String),
        photos: $checkedConvert(
          'photos',
          (v) => (v as List<dynamic>)
              .map((e) => RequestPhotoDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        createdAt: $checkedConvert('createdAt', (v) => v as String),
        publishedAt: $checkedConvert('publishedAt', (v) => v as String?),
        cancelledAt: $checkedConvert('cancelledAt', (v) => v as String?),
        ring: $checkedConvert('ring', (v) => v as num?),
        totalRings: $checkedConvert('totalRings', (v) => v as num),
        jobId: $checkedConvert('jobId', (v) => v as String?),
        expiresAt: $checkedConvert('expiresAt', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$RequestDtoToJson(RequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$RequestDtoStatusEnumEnumMap[instance.status]!,
      'statusMessage': ?instance.statusMessage,
      'category': instance.category.toJson(),
      'cityId': instance.cityId,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'proposedPriceBs': instance.proposedPriceBs,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'publishedAt': ?instance.publishedAt,
      'cancelledAt': ?instance.cancelledAt,
      'ring': instance.ring,
      'totalRings': instance.totalRings,
      'jobId': instance.jobId,
      'expiresAt': instance.expiresAt,
    };

const _$RequestDtoStatusEnumEnumMap = {
  RequestDtoStatusEnum.borrador: 'borrador',
  RequestDtoStatusEnum.retenida: 'retenida',
  RequestDtoStatusEnum.buscando: 'buscando',
  RequestDtoStatusEnum.conOfertas: 'con_ofertas',
  RequestDtoStatusEnum.asignada: 'asignada',
  RequestDtoStatusEnum.cancelada: 'cancelada',
  RequestDtoStatusEnum.expirada: 'expirada',
};

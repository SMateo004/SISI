// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_held_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminHeldRequestDtoCWProxy {
  AdminHeldRequestDto id(String id);

  AdminHeldRequestDto status(AdminHeldRequestDtoStatusEnum status);

  AdminHeldRequestDto statusMessage(String? statusMessage);

  AdminHeldRequestDto category(RequestCategoryDto category);

  AdminHeldRequestDto cityId(String cityId);

  AdminHeldRequestDto description(String description);

  AdminHeldRequestDto latitude(num latitude);

  AdminHeldRequestDto longitude(num longitude);

  AdminHeldRequestDto address(String address);

  AdminHeldRequestDto proposedPriceBs(String proposedPriceBs);

  AdminHeldRequestDto photos(List<RequestPhotoDto> photos);

  AdminHeldRequestDto createdAt(String createdAt);

  AdminHeldRequestDto publishedAt(String? publishedAt);

  AdminHeldRequestDto cancelledAt(String? cancelledAt);

  AdminHeldRequestDto ring(num? ring);

  AdminHeldRequestDto totalRings(num totalRings);

  AdminHeldRequestDto jobId(String? jobId);

  AdminHeldRequestDto expiresAt(String? expiresAt);

  AdminHeldRequestDto matches(Object matches);

  AdminHeldRequestDto employerId(String employerId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHeldRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHeldRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHeldRequestDto call({
    String id,
    AdminHeldRequestDtoStatusEnum status,
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
    Object matches,
    String employerId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminHeldRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminHeldRequestDto.copyWith.fieldName(...)`
class _$AdminHeldRequestDtoCWProxyImpl implements _$AdminHeldRequestDtoCWProxy {
  const _$AdminHeldRequestDtoCWProxyImpl(this._value);

  final AdminHeldRequestDto _value;

  @override
  AdminHeldRequestDto id(String id) => this(id: id);

  @override
  AdminHeldRequestDto status(AdminHeldRequestDtoStatusEnum status) =>
      this(status: status);

  @override
  AdminHeldRequestDto statusMessage(String? statusMessage) =>
      this(statusMessage: statusMessage);

  @override
  AdminHeldRequestDto category(RequestCategoryDto category) =>
      this(category: category);

  @override
  AdminHeldRequestDto cityId(String cityId) => this(cityId: cityId);

  @override
  AdminHeldRequestDto description(String description) =>
      this(description: description);

  @override
  AdminHeldRequestDto latitude(num latitude) => this(latitude: latitude);

  @override
  AdminHeldRequestDto longitude(num longitude) => this(longitude: longitude);

  @override
  AdminHeldRequestDto address(String address) => this(address: address);

  @override
  AdminHeldRequestDto proposedPriceBs(String proposedPriceBs) =>
      this(proposedPriceBs: proposedPriceBs);

  @override
  AdminHeldRequestDto photos(List<RequestPhotoDto> photos) =>
      this(photos: photos);

  @override
  AdminHeldRequestDto createdAt(String createdAt) => this(createdAt: createdAt);

  @override
  AdminHeldRequestDto publishedAt(String? publishedAt) =>
      this(publishedAt: publishedAt);

  @override
  AdminHeldRequestDto cancelledAt(String? cancelledAt) =>
      this(cancelledAt: cancelledAt);

  @override
  AdminHeldRequestDto ring(num? ring) => this(ring: ring);

  @override
  AdminHeldRequestDto totalRings(num totalRings) =>
      this(totalRings: totalRings);

  @override
  AdminHeldRequestDto jobId(String? jobId) => this(jobId: jobId);

  @override
  AdminHeldRequestDto expiresAt(String? expiresAt) =>
      this(expiresAt: expiresAt);

  @override
  AdminHeldRequestDto matches(Object matches) => this(matches: matches);

  @override
  AdminHeldRequestDto employerId(String employerId) =>
      this(employerId: employerId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminHeldRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminHeldRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminHeldRequestDto call({
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
    Object? matches = const $CopyWithPlaceholder(),
    Object? employerId = const $CopyWithPlaceholder(),
  }) {
    return AdminHeldRequestDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AdminHeldRequestDtoStatusEnum,
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
      matches: matches == const $CopyWithPlaceholder()
          ? _value.matches
          // ignore: cast_nullable_to_non_nullable
          : matches as Object,
      employerId: employerId == const $CopyWithPlaceholder()
          ? _value.employerId
          // ignore: cast_nullable_to_non_nullable
          : employerId as String,
    );
  }
}

extension $AdminHeldRequestDtoCopyWith on AdminHeldRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminHeldRequestDto.copyWith(...)` or like so:`instanceOfAdminHeldRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminHeldRequestDtoCWProxy get copyWith =>
      _$AdminHeldRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminHeldRequestDto _$AdminHeldRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminHeldRequestDto', json, ($checkedConvert) {
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
          'matches',
          'employerId',
        ],
      );
      final val = AdminHeldRequestDto(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$AdminHeldRequestDtoStatusEnumEnumMap, v),
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
        matches: $checkedConvert('matches', (v) => v as Object),
        employerId: $checkedConvert('employerId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminHeldRequestDtoToJson(
  AdminHeldRequestDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': _$AdminHeldRequestDtoStatusEnumEnumMap[instance.status]!,
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
  'matches': instance.matches,
  'employerId': instance.employerId,
};

const _$AdminHeldRequestDtoStatusEnumEnumMap = {
  AdminHeldRequestDtoStatusEnum.borrador: 'borrador',
  AdminHeldRequestDtoStatusEnum.retenida: 'retenida',
  AdminHeldRequestDtoStatusEnum.buscando: 'buscando',
  AdminHeldRequestDtoStatusEnum.conOfertas: 'con_ofertas',
  AdminHeldRequestDtoStatusEnum.asignada: 'asignada',
  AdminHeldRequestDtoStatusEnum.cancelada: 'cancelada',
  AdminHeldRequestDtoStatusEnum.expirada: 'expirada',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_request_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IncomingRequestDtoCWProxy {
  IncomingRequestDto requestId(String requestId);

  IncomingRequestDto outcome(IncomingRequestDtoOutcomeEnum outcome);

  IncomingRequestDto category(Object category);

  IncomingRequestDto description(String description);

  IncomingRequestDto distanceM(num distanceM);

  IncomingRequestDto proposedPriceBs(String proposedPriceBs);

  IncomingRequestDto referenceRange(PriceRangeDto referenceRange);

  IncomingRequestDto maxCounterBs(String maxCounterBs);

  IncomingRequestDto photos(List<IncomingPhotoDto> photos);

  IncomingRequestDto ring(num ring);

  IncomingRequestDto respondBy(DateTime respondBy);

  IncomingRequestDto myOffer(MyOfferDto? myOffer);

  IncomingRequestDto jobId(String? jobId);

  IncomingRequestDto notifiedAt(DateTime notifiedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncomingRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncomingRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  IncomingRequestDto call({
    String requestId,
    IncomingRequestDtoOutcomeEnum outcome,
    Object category,
    String description,
    num distanceM,
    String proposedPriceBs,
    PriceRangeDto referenceRange,
    String maxCounterBs,
    List<IncomingPhotoDto> photos,
    num ring,
    DateTime respondBy,
    MyOfferDto? myOffer,
    String? jobId,
    DateTime notifiedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIncomingRequestDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIncomingRequestDto.copyWith.fieldName(...)`
class _$IncomingRequestDtoCWProxyImpl implements _$IncomingRequestDtoCWProxy {
  const _$IncomingRequestDtoCWProxyImpl(this._value);

  final IncomingRequestDto _value;

  @override
  IncomingRequestDto requestId(String requestId) => this(requestId: requestId);

  @override
  IncomingRequestDto outcome(IncomingRequestDtoOutcomeEnum outcome) =>
      this(outcome: outcome);

  @override
  IncomingRequestDto category(Object category) => this(category: category);

  @override
  IncomingRequestDto description(String description) =>
      this(description: description);

  @override
  IncomingRequestDto distanceM(num distanceM) => this(distanceM: distanceM);

  @override
  IncomingRequestDto proposedPriceBs(String proposedPriceBs) =>
      this(proposedPriceBs: proposedPriceBs);

  @override
  IncomingRequestDto referenceRange(PriceRangeDto referenceRange) =>
      this(referenceRange: referenceRange);

  @override
  IncomingRequestDto maxCounterBs(String maxCounterBs) =>
      this(maxCounterBs: maxCounterBs);

  @override
  IncomingRequestDto photos(List<IncomingPhotoDto> photos) =>
      this(photos: photos);

  @override
  IncomingRequestDto ring(num ring) => this(ring: ring);

  @override
  IncomingRequestDto respondBy(DateTime respondBy) =>
      this(respondBy: respondBy);

  @override
  IncomingRequestDto myOffer(MyOfferDto? myOffer) => this(myOffer: myOffer);

  @override
  IncomingRequestDto jobId(String? jobId) => this(jobId: jobId);

  @override
  IncomingRequestDto notifiedAt(DateTime notifiedAt) =>
      this(notifiedAt: notifiedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IncomingRequestDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IncomingRequestDto(...).copyWith(id: 12, name: "My name")
  /// ````
  IncomingRequestDto call({
    Object? requestId = const $CopyWithPlaceholder(),
    Object? outcome = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? distanceM = const $CopyWithPlaceholder(),
    Object? proposedPriceBs = const $CopyWithPlaceholder(),
    Object? referenceRange = const $CopyWithPlaceholder(),
    Object? maxCounterBs = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? ring = const $CopyWithPlaceholder(),
    Object? respondBy = const $CopyWithPlaceholder(),
    Object? myOffer = const $CopyWithPlaceholder(),
    Object? jobId = const $CopyWithPlaceholder(),
    Object? notifiedAt = const $CopyWithPlaceholder(),
  }) {
    return IncomingRequestDto(
      requestId: requestId == const $CopyWithPlaceholder()
          ? _value.requestId
          // ignore: cast_nullable_to_non_nullable
          : requestId as String,
      outcome: outcome == const $CopyWithPlaceholder()
          ? _value.outcome
          // ignore: cast_nullable_to_non_nullable
          : outcome as IncomingRequestDtoOutcomeEnum,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as Object,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String,
      distanceM: distanceM == const $CopyWithPlaceholder()
          ? _value.distanceM
          // ignore: cast_nullable_to_non_nullable
          : distanceM as num,
      proposedPriceBs: proposedPriceBs == const $CopyWithPlaceholder()
          ? _value.proposedPriceBs
          // ignore: cast_nullable_to_non_nullable
          : proposedPriceBs as String,
      referenceRange: referenceRange == const $CopyWithPlaceholder()
          ? _value.referenceRange
          // ignore: cast_nullable_to_non_nullable
          : referenceRange as PriceRangeDto,
      maxCounterBs: maxCounterBs == const $CopyWithPlaceholder()
          ? _value.maxCounterBs
          // ignore: cast_nullable_to_non_nullable
          : maxCounterBs as String,
      photos: photos == const $CopyWithPlaceholder()
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<IncomingPhotoDto>,
      ring: ring == const $CopyWithPlaceholder()
          ? _value.ring
          // ignore: cast_nullable_to_non_nullable
          : ring as num,
      respondBy: respondBy == const $CopyWithPlaceholder()
          ? _value.respondBy
          // ignore: cast_nullable_to_non_nullable
          : respondBy as DateTime,
      myOffer: myOffer == const $CopyWithPlaceholder()
          ? _value.myOffer
          // ignore: cast_nullable_to_non_nullable
          : myOffer as MyOfferDto?,
      jobId: jobId == const $CopyWithPlaceholder()
          ? _value.jobId
          // ignore: cast_nullable_to_non_nullable
          : jobId as String?,
      notifiedAt: notifiedAt == const $CopyWithPlaceholder()
          ? _value.notifiedAt
          // ignore: cast_nullable_to_non_nullable
          : notifiedAt as DateTime,
    );
  }
}

extension $IncomingRequestDtoCopyWith on IncomingRequestDto {
  /// Returns a callable class that can be used as follows: `instanceOfIncomingRequestDto.copyWith(...)` or like so:`instanceOfIncomingRequestDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IncomingRequestDtoCWProxy get copyWith =>
      _$IncomingRequestDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingRequestDto _$IncomingRequestDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IncomingRequestDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'requestId',
          'outcome',
          'category',
          'description',
          'distanceM',
          'proposedPriceBs',
          'referenceRange',
          'maxCounterBs',
          'photos',
          'ring',
          'respondBy',
          'myOffer',
          'jobId',
          'notifiedAt',
        ],
      );
      final val = IncomingRequestDto(
        requestId: $checkedConvert('requestId', (v) => v as String),
        outcome: $checkedConvert(
          'outcome',
          (v) => $enumDecode(_$IncomingRequestDtoOutcomeEnumEnumMap, v),
        ),
        category: $checkedConvert('category', (v) => v as Object),
        description: $checkedConvert('description', (v) => v as String),
        distanceM: $checkedConvert('distanceM', (v) => v as num),
        proposedPriceBs: $checkedConvert('proposedPriceBs', (v) => v as String),
        referenceRange: $checkedConvert(
          'referenceRange',
          (v) => PriceRangeDto.fromJson(v as Map<String, dynamic>),
        ),
        maxCounterBs: $checkedConvert('maxCounterBs', (v) => v as String),
        photos: $checkedConvert(
          'photos',
          (v) => (v as List<dynamic>)
              .map((e) => IncomingPhotoDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        ring: $checkedConvert('ring', (v) => v as num),
        respondBy: $checkedConvert(
          'respondBy',
          (v) => DateTime.parse(v as String),
        ),
        myOffer: $checkedConvert(
          'myOffer',
          (v) =>
              v == null ? null : MyOfferDto.fromJson(v as Map<String, dynamic>),
        ),
        jobId: $checkedConvert('jobId', (v) => v as String?),
        notifiedAt: $checkedConvert(
          'notifiedAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$IncomingRequestDtoToJson(IncomingRequestDto instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'outcome': _$IncomingRequestDtoOutcomeEnumEnumMap[instance.outcome]!,
      'category': instance.category,
      'description': instance.description,
      'distanceM': instance.distanceM,
      'proposedPriceBs': instance.proposedPriceBs,
      'referenceRange': instance.referenceRange.toJson(),
      'maxCounterBs': instance.maxCounterBs,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'ring': instance.ring,
      'respondBy': instance.respondBy.toIso8601String(),
      'myOffer': instance.myOffer?.toJson(),
      'jobId': instance.jobId,
      'notifiedAt': instance.notifiedAt.toIso8601String(),
    };

const _$IncomingRequestDtoOutcomeEnumEnumMap = {
  IncomingRequestDtoOutcomeEnum.abierta: 'abierta',
  IncomingRequestDtoOutcomeEnum.elegido: 'elegido',
  IncomingRequestDtoOutcomeEnum.elegidaOtra: 'elegida_otra',
  IncomingRequestDtoOutcomeEnum.cancelada: 'cancelada',
  IncomingRequestDtoOutcomeEnum.expirada: 'expirada',
};

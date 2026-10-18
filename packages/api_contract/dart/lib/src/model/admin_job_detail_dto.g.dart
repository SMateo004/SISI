// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_job_detail_dto.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminJobDetailDtoCWProxy {
  AdminJobDetailDto id(String id);

  AdminJobDetailDto requestId(String requestId);

  AdminJobDetailDto status(String status);

  AdminJobDetailDto category(JobCategoryDto category);

  AdminJobDetailDto description(String description);

  AdminJobDetailDto address(String address);

  AdminJobDetailDto proposedPriceBs(String proposedPriceBs);

  AdminJobDetailDto finalPriceBs(String finalPriceBs);

  AdminJobDetailDto commissionPct(String commissionPct);

  AdminJobDetailDto commissionBs(String? commissionBs);

  AdminJobDetailDto worker(AdminJobPartyDto worker);

  AdminJobDetailDto employer(AdminJobPartyDto employer);

  AdminJobDetailDto disputedAt(DateTime? disputedAt);

  AdminJobDetailDto disputeNote(String? disputeNote);

  AdminJobDetailDto timeline(List<AdminJobEventDto> timeline);

  AdminJobDetailDto chat(List<AdminJobMessageDto> chat);

  AdminJobDetailDto offers(List<AdminJobOfferDto> offers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobDetailDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobDetailDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobDetailDto call({
    String id,
    String requestId,
    String status,
    JobCategoryDto category,
    String description,
    String address,
    String proposedPriceBs,
    String finalPriceBs,
    String commissionPct,
    String? commissionBs,
    AdminJobPartyDto worker,
    AdminJobPartyDto employer,
    DateTime? disputedAt,
    String? disputeNote,
    List<AdminJobEventDto> timeline,
    List<AdminJobMessageDto> chat,
    List<AdminJobOfferDto> offers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminJobDetailDto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminJobDetailDto.copyWith.fieldName(...)`
class _$AdminJobDetailDtoCWProxyImpl implements _$AdminJobDetailDtoCWProxy {
  const _$AdminJobDetailDtoCWProxyImpl(this._value);

  final AdminJobDetailDto _value;

  @override
  AdminJobDetailDto id(String id) => this(id: id);

  @override
  AdminJobDetailDto requestId(String requestId) => this(requestId: requestId);

  @override
  AdminJobDetailDto status(String status) => this(status: status);

  @override
  AdminJobDetailDto category(JobCategoryDto category) =>
      this(category: category);

  @override
  AdminJobDetailDto description(String description) =>
      this(description: description);

  @override
  AdminJobDetailDto address(String address) => this(address: address);

  @override
  AdminJobDetailDto proposedPriceBs(String proposedPriceBs) =>
      this(proposedPriceBs: proposedPriceBs);

  @override
  AdminJobDetailDto finalPriceBs(String finalPriceBs) =>
      this(finalPriceBs: finalPriceBs);

  @override
  AdminJobDetailDto commissionPct(String commissionPct) =>
      this(commissionPct: commissionPct);

  @override
  AdminJobDetailDto commissionBs(String? commissionBs) =>
      this(commissionBs: commissionBs);

  @override
  AdminJobDetailDto worker(AdminJobPartyDto worker) => this(worker: worker);

  @override
  AdminJobDetailDto employer(AdminJobPartyDto employer) =>
      this(employer: employer);

  @override
  AdminJobDetailDto disputedAt(DateTime? disputedAt) =>
      this(disputedAt: disputedAt);

  @override
  AdminJobDetailDto disputeNote(String? disputeNote) =>
      this(disputeNote: disputeNote);

  @override
  AdminJobDetailDto timeline(List<AdminJobEventDto> timeline) =>
      this(timeline: timeline);

  @override
  AdminJobDetailDto chat(List<AdminJobMessageDto> chat) => this(chat: chat);

  @override
  AdminJobDetailDto offers(List<AdminJobOfferDto> offers) =>
      this(offers: offers);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminJobDetailDto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminJobDetailDto(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminJobDetailDto call({
    Object? id = const $CopyWithPlaceholder(),
    Object? requestId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? proposedPriceBs = const $CopyWithPlaceholder(),
    Object? finalPriceBs = const $CopyWithPlaceholder(),
    Object? commissionPct = const $CopyWithPlaceholder(),
    Object? commissionBs = const $CopyWithPlaceholder(),
    Object? worker = const $CopyWithPlaceholder(),
    Object? employer = const $CopyWithPlaceholder(),
    Object? disputedAt = const $CopyWithPlaceholder(),
    Object? disputeNote = const $CopyWithPlaceholder(),
    Object? timeline = const $CopyWithPlaceholder(),
    Object? chat = const $CopyWithPlaceholder(),
    Object? offers = const $CopyWithPlaceholder(),
  }) {
    return AdminJobDetailDto(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      requestId: requestId == const $CopyWithPlaceholder()
          ? _value.requestId
          // ignore: cast_nullable_to_non_nullable
          : requestId as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as JobCategoryDto,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      proposedPriceBs: proposedPriceBs == const $CopyWithPlaceholder()
          ? _value.proposedPriceBs
          // ignore: cast_nullable_to_non_nullable
          : proposedPriceBs as String,
      finalPriceBs: finalPriceBs == const $CopyWithPlaceholder()
          ? _value.finalPriceBs
          // ignore: cast_nullable_to_non_nullable
          : finalPriceBs as String,
      commissionPct: commissionPct == const $CopyWithPlaceholder()
          ? _value.commissionPct
          // ignore: cast_nullable_to_non_nullable
          : commissionPct as String,
      commissionBs: commissionBs == const $CopyWithPlaceholder()
          ? _value.commissionBs
          // ignore: cast_nullable_to_non_nullable
          : commissionBs as String?,
      worker: worker == const $CopyWithPlaceholder()
          ? _value.worker
          // ignore: cast_nullable_to_non_nullable
          : worker as AdminJobPartyDto,
      employer: employer == const $CopyWithPlaceholder()
          ? _value.employer
          // ignore: cast_nullable_to_non_nullable
          : employer as AdminJobPartyDto,
      disputedAt: disputedAt == const $CopyWithPlaceholder()
          ? _value.disputedAt
          // ignore: cast_nullable_to_non_nullable
          : disputedAt as DateTime?,
      disputeNote: disputeNote == const $CopyWithPlaceholder()
          ? _value.disputeNote
          // ignore: cast_nullable_to_non_nullable
          : disputeNote as String?,
      timeline: timeline == const $CopyWithPlaceholder()
          ? _value.timeline
          // ignore: cast_nullable_to_non_nullable
          : timeline as List<AdminJobEventDto>,
      chat: chat == const $CopyWithPlaceholder()
          ? _value.chat
          // ignore: cast_nullable_to_non_nullable
          : chat as List<AdminJobMessageDto>,
      offers: offers == const $CopyWithPlaceholder()
          ? _value.offers
          // ignore: cast_nullable_to_non_nullable
          : offers as List<AdminJobOfferDto>,
    );
  }
}

extension $AdminJobDetailDtoCopyWith on AdminJobDetailDto {
  /// Returns a callable class that can be used as follows: `instanceOfAdminJobDetailDto.copyWith(...)` or like so:`instanceOfAdminJobDetailDto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminJobDetailDtoCWProxy get copyWith =>
      _$AdminJobDetailDtoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminJobDetailDto _$AdminJobDetailDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminJobDetailDto', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'requestId',
          'status',
          'category',
          'description',
          'address',
          'proposedPriceBs',
          'finalPriceBs',
          'commissionPct',
          'commissionBs',
          'worker',
          'employer',
          'disputedAt',
          'disputeNote',
          'timeline',
          'chat',
          'offers',
        ],
      );
      final val = AdminJobDetailDto(
        id: $checkedConvert('id', (v) => v as String),
        requestId: $checkedConvert('requestId', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        category: $checkedConvert(
          'category',
          (v) => JobCategoryDto.fromJson(v as Map<String, dynamic>),
        ),
        description: $checkedConvert('description', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        proposedPriceBs: $checkedConvert('proposedPriceBs', (v) => v as String),
        finalPriceBs: $checkedConvert('finalPriceBs', (v) => v as String),
        commissionPct: $checkedConvert('commissionPct', (v) => v as String),
        commissionBs: $checkedConvert('commissionBs', (v) => v as String?),
        worker: $checkedConvert(
          'worker',
          (v) => AdminJobPartyDto.fromJson(v as Map<String, dynamic>),
        ),
        employer: $checkedConvert(
          'employer',
          (v) => AdminJobPartyDto.fromJson(v as Map<String, dynamic>),
        ),
        disputedAt: $checkedConvert(
          'disputedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        disputeNote: $checkedConvert('disputeNote', (v) => v as String?),
        timeline: $checkedConvert(
          'timeline',
          (v) => (v as List<dynamic>)
              .map((e) => AdminJobEventDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        chat: $checkedConvert(
          'chat',
          (v) => (v as List<dynamic>)
              .map(
                (e) => AdminJobMessageDto.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        offers: $checkedConvert(
          'offers',
          (v) => (v as List<dynamic>)
              .map((e) => AdminJobOfferDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminJobDetailDtoToJson(AdminJobDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'status': instance.status,
      'category': instance.category.toJson(),
      'description': instance.description,
      'address': instance.address,
      'proposedPriceBs': instance.proposedPriceBs,
      'finalPriceBs': instance.finalPriceBs,
      'commissionPct': instance.commissionPct,
      'commissionBs': instance.commissionBs,
      'worker': instance.worker.toJson(),
      'employer': instance.employer.toJson(),
      'disputedAt': instance.disputedAt?.toIso8601String(),
      'disputeNote': instance.disputeNote,
      'timeline': instance.timeline.map((e) => e.toJson()).toList(),
      'chat': instance.chat.map((e) => e.toJson()).toList(),
      'offers': instance.offers.map((e) => e.toJson()).toList(),
    };

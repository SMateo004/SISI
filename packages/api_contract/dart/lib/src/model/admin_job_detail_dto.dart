//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/admin_job_party_dto.dart';
import 'package:sisi_api/src/model/admin_job_offer_dto.dart';
import 'package:sisi_api/src/model/admin_job_event_dto.dart';
import 'package:sisi_api/src/model/admin_job_message_dto.dart';
import 'package:sisi_api/src/model/job_category_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_job_detail_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminJobDetailDto {
  /// Returns a new [AdminJobDetailDto] instance.
  AdminJobDetailDto({

    required  this.id,

    required  this.requestId,

    required  this.status,

    required  this.category,

    required  this.description,

    required  this.address,

    required  this.proposedPriceBs,

    required  this.finalPriceBs,

    required  this.commissionPct,

    required  this.commissionBs,

    required  this.worker,

    required  this.employer,

    required  this.disputedAt,

    required  this.disputeNote,

    required  this.timeline,

    required  this.chat,

    required  this.offers,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'requestId',
    required: true,
    includeIfNull: false,
  )


  final String requestId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final JobCategoryDto category;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



  @JsonKey(
    
    name: r'proposedPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String proposedPriceBs;



  @JsonKey(
    
    name: r'finalPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String finalPriceBs;



  @JsonKey(
    
    name: r'commissionPct',
    required: true,
    includeIfNull: false,
  )


  final String commissionPct;



  @JsonKey(
    
    name: r'commissionBs',
    required: true,
    includeIfNull: true,
  )


  final String? commissionBs;



  @JsonKey(
    
    name: r'worker',
    required: true,
    includeIfNull: false,
  )


  final AdminJobPartyDto worker;



  @JsonKey(
    
    name: r'employer',
    required: true,
    includeIfNull: false,
  )


  final AdminJobPartyDto employer;



  @JsonKey(
    
    name: r'disputedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? disputedAt;



  @JsonKey(
    
    name: r'disputeNote',
    required: true,
    includeIfNull: true,
  )


  final String? disputeNote;



      /// job_events
  @JsonKey(
    
    name: r'timeline',
    required: true,
    includeIfNull: false,
  )


  final List<AdminJobEventDto> timeline;



      /// Todo el chat
  @JsonKey(
    
    name: r'chat',
    required: true,
    includeIfNull: false,
  )


  final List<AdminJobMessageDto> chat;



  @JsonKey(
    
    name: r'offers',
    required: true,
    includeIfNull: false,
  )


  final List<AdminJobOfferDto> offers;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminJobDetailDto &&
      other.id == id &&
      other.requestId == requestId &&
      other.status == status &&
      other.category == category &&
      other.description == description &&
      other.address == address &&
      other.proposedPriceBs == proposedPriceBs &&
      other.finalPriceBs == finalPriceBs &&
      other.commissionPct == commissionPct &&
      other.commissionBs == commissionBs &&
      other.worker == worker &&
      other.employer == employer &&
      other.disputedAt == disputedAt &&
      other.disputeNote == disputeNote &&
      other.timeline == timeline &&
      other.chat == chat &&
      other.offers == offers;

    @override
    int get hashCode =>
        id.hashCode +
        requestId.hashCode +
        status.hashCode +
        category.hashCode +
        description.hashCode +
        address.hashCode +
        proposedPriceBs.hashCode +
        finalPriceBs.hashCode +
        commissionPct.hashCode +
        (commissionBs == null ? 0 : commissionBs.hashCode) +
        worker.hashCode +
        employer.hashCode +
        (disputedAt == null ? 0 : disputedAt.hashCode) +
        (disputeNote == null ? 0 : disputeNote.hashCode) +
        timeline.hashCode +
        chat.hashCode +
        offers.hashCode;

  factory AdminJobDetailDto.fromJson(Map<String, dynamic> json) => _$AdminJobDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminJobDetailDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


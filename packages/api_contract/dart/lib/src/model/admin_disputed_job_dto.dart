//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/job_category_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_disputed_job_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminDisputedJobDto {
  /// Returns a new [AdminDisputedJobDto] instance.
  AdminDisputedJobDto({

    required  this.id,

    required  this.requestId,

    required  this.workerId,

    required  this.employerId,

    required  this.category,

    required  this.finalPriceBs,

    required  this.workerFinishedAt,

    required  this.disputedAt,

    required  this.disputeNote,
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
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



  @JsonKey(
    
    name: r'employerId',
    required: true,
    includeIfNull: false,
  )


  final String employerId;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final JobCategoryDto category;



  @JsonKey(
    
    name: r'finalPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String finalPriceBs;



  @JsonKey(
    
    name: r'workerFinishedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime workerFinishedAt;



  @JsonKey(
    
    name: r'disputedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime disputedAt;



  @JsonKey(
    
    name: r'disputeNote',
    required: true,
    includeIfNull: true,
  )


  final String? disputeNote;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminDisputedJobDto &&
      other.id == id &&
      other.requestId == requestId &&
      other.workerId == workerId &&
      other.employerId == employerId &&
      other.category == category &&
      other.finalPriceBs == finalPriceBs &&
      other.workerFinishedAt == workerFinishedAt &&
      other.disputedAt == disputedAt &&
      other.disputeNote == disputeNote;

    @override
    int get hashCode =>
        id.hashCode +
        requestId.hashCode +
        workerId.hashCode +
        employerId.hashCode +
        category.hashCode +
        finalPriceBs.hashCode +
        workerFinishedAt.hashCode +
        disputedAt.hashCode +
        (disputeNote == null ? 0 : disputeNote.hashCode);

  factory AdminDisputedJobDto.fromJson(Map<String, dynamic> json) => _$AdminDisputedJobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDisputedJobDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


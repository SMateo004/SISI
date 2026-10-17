//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_timeline_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobTimelineDto {
  /// Returns a new [JobTimelineDto] instance.
  JobTimelineDto({

    required  this.assignedAt,

    required  this.onTheWayAt,

    required  this.startedAt,

    required  this.workerFinishedAt,

    required  this.disputedAt,

    required  this.completedAt,

    required  this.cancelledAt,
  });

  @JsonKey(
    
    name: r'assignedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime assignedAt;



  @JsonKey(
    
    name: r'onTheWayAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? onTheWayAt;



  @JsonKey(
    
    name: r'startedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? startedAt;



      /// El trabajador marcó \"Terminé\"
  @JsonKey(
    
    name: r'workerFinishedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? workerFinishedAt;



  @JsonKey(
    
    name: r'disputedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? disputedAt;



  @JsonKey(
    
    name: r'completedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? completedAt;



  @JsonKey(
    
    name: r'cancelledAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? cancelledAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobTimelineDto &&
      other.assignedAt == assignedAt &&
      other.onTheWayAt == onTheWayAt &&
      other.startedAt == startedAt &&
      other.workerFinishedAt == workerFinishedAt &&
      other.disputedAt == disputedAt &&
      other.completedAt == completedAt &&
      other.cancelledAt == cancelledAt;

    @override
    int get hashCode =>
        assignedAt.hashCode +
        (onTheWayAt == null ? 0 : onTheWayAt.hashCode) +
        (startedAt == null ? 0 : startedAt.hashCode) +
        (workerFinishedAt == null ? 0 : workerFinishedAt.hashCode) +
        (disputedAt == null ? 0 : disputedAt.hashCode) +
        (completedAt == null ? 0 : completedAt.hashCode) +
        (cancelledAt == null ? 0 : cancelledAt.hashCode);

  factory JobTimelineDto.fromJson(Map<String, dynamic> json) => _$JobTimelineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobTimelineDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


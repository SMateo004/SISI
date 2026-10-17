//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/tracked_point_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_location_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobLocationDto {
  /// Returns a new [JobLocationDto] instance.
  JobLocationDto({

    required  this.jobId,

    required  this.location,
  });

  @JsonKey(
    
    name: r'jobId',
    required: true,
    includeIfNull: false,
  )


  final String jobId;



      /// null si todavía no envió su ubicación
  @JsonKey(
    
    name: r'location',
    required: true,
    includeIfNull: true,
  )


  final TrackedPointDto? location;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobLocationDto &&
      other.jobId == jobId &&
      other.location == location;

    @override
    int get hashCode =>
        jobId.hashCode +
        (location == null ? 0 : location.hashCode);

  factory JobLocationDto.fromJson(Map<String, dynamic> json) => _$JobLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobLocationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


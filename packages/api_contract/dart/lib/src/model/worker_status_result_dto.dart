//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'worker_status_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WorkerStatusResultDto {
  /// Returns a new [WorkerStatusResultDto] instance.
  WorkerStatusResultDto({

    required  this.userId,

    required  this.status,

    required  this.modeForcedToEmployer,
  });

  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'modeForcedToEmployer',
    required: true,
    includeIfNull: false,
  )


  final bool modeForcedToEmployer;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WorkerStatusResultDto &&
      other.userId == userId &&
      other.status == status &&
      other.modeForcedToEmployer == modeForcedToEmployer;

    @override
    int get hashCode =>
        userId.hashCode +
        status.hashCode +
        modeForcedToEmployer.hashCode;

  factory WorkerStatusResultDto.fromJson(Map<String, dynamic> json) => _$WorkerStatusResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerStatusResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


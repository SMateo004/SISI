//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dispute_job_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DisputeJobDto {
  /// Returns a new [DisputeJobDto] instance.
  DisputeJobDto({

     this.note,
  });

  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DisputeJobDto &&
      other.note == note;

    @override
    int get hashCode =>
        note.hashCode;

  factory DisputeJobDto.fromJson(Map<String, dynamic> json) => _$DisputeJobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DisputeJobDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


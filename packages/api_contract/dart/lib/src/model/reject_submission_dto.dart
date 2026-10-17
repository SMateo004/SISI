//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reject_submission_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RejectSubmissionDto {
  /// Returns a new [RejectSubmissionDto] instance.
  RejectSubmissionDto({

    required  this.note,
  });

  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RejectSubmissionDto &&
      other.note == note;

    @override
    int get hashCode =>
        note.hashCode;

  factory RejectSubmissionDto.fromJson(Map<String, dynamic> json) => _$RejectSubmissionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RejectSubmissionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


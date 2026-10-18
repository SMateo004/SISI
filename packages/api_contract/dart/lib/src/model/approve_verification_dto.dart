//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'approve_verification_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApproveVerificationDto {
  /// Returns a new [ApproveVerificationDto] instance.
  ApproveVerificationDto({

     this.note,
  });

  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApproveVerificationDto &&
      other.note == note;

    @override
    int get hashCode =>
        note.hashCode;

  factory ApproveVerificationDto.fromJson(Map<String, dynamic> json) => _$ApproveVerificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApproveVerificationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


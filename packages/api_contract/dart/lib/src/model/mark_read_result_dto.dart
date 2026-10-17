//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mark_read_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MarkReadResultDto {
  /// Returns a new [MarkReadResultDto] instance.
  MarkReadResultDto({

    required  this.updated,
  });

  @JsonKey(
    
    name: r'updated',
    required: true,
    includeIfNull: false,
  )


  final num updated;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MarkReadResultDto &&
      other.updated == updated;

    @override
    int get hashCode =>
        updated.hashCode;

  factory MarkReadResultDto.fromJson(Map<String, dynamic> json) => _$MarkReadResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MarkReadResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


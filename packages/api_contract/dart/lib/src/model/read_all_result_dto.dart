//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'read_all_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReadAllResultDto {
  /// Returns a new [ReadAllResultDto] instance.
  ReadAllResultDto({

    required  this.updated,
  });

  @JsonKey(
    
    name: r'updated',
    required: true,
    includeIfNull: false,
  )


  final num updated;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReadAllResultDto &&
      other.updated == updated;

    @override
    int get hashCode =>
        updated.hashCode;

  factory ReadAllResultDto.fromJson(Map<String, dynamic> json) => _$ReadAllResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReadAllResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


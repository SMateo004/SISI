//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_me_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateMeDto {
  /// Returns a new [UpdateMeDto] instance.
  UpdateMeDto({

     this.name,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateMeDto &&
      other.name == name;

    @override
    int get hashCode =>
        name.hashCode;

  factory UpdateMeDto.fromJson(Map<String, dynamic> json) => _$UpdateMeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


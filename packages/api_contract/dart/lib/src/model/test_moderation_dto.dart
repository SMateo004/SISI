//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_moderation_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TestModerationDto {
  /// Returns a new [TestModerationDto] instance.
  TestModerationDto({

    required  this.text,
  });

  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TestModerationDto &&
      other.text == text;

    @override
    int get hashCode =>
        text.hashCode;

  factory TestModerationDto.fromJson(Map<String, dynamic> json) => _$TestModerationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TestModerationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


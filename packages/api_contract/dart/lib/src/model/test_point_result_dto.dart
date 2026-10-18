//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_point_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TestPointResultDto {
  /// Returns a new [TestPointResultDto] instance.
  TestPointResultDto({

    required  this.inside,

    required  this.by,
  });

  @JsonKey(
    
    name: r'inside',
    required: true,
    includeIfNull: false,
  )


  final bool inside;



  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final TestPointResultDtoByEnum by;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TestPointResultDto &&
      other.inside == inside &&
      other.by == by;

    @override
    int get hashCode =>
        inside.hashCode +
        by.hashCode;

  factory TestPointResultDto.fromJson(Map<String, dynamic> json) => _$TestPointResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TestPointResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TestPointResultDtoByEnum {
@JsonValue(r'polygon')
polygon(r'polygon'),
@JsonValue(r'radius')
radius(r'radius'),
@JsonValue(r'none')
none(r'none');

const TestPointResultDtoByEnum(this.value);

final String value;

@override
String toString() => value;
}



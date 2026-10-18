//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_pilot_phones_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddPilotPhonesResultDto {
  /// Returns a new [AddPilotPhonesResultDto] instance.
  AddPilotPhonesResultDto({

    required  this.added,

    required  this.alreadyListed,

    required  this.invalid,
  });

  @JsonKey(
    
    name: r'added',
    required: true,
    includeIfNull: false,
  )


  final List<String> added;



  @JsonKey(
    
    name: r'alreadyListed',
    required: true,
    includeIfNull: false,
  )


  final List<String> alreadyListed;



  @JsonKey(
    
    name: r'invalid',
    required: true,
    includeIfNull: false,
  )


  final List<String> invalid;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddPilotPhonesResultDto &&
      other.added == added &&
      other.alreadyListed == alreadyListed &&
      other.invalid == invalid;

    @override
    int get hashCode =>
        added.hashCode +
        alreadyListed.hashCode +
        invalid.hashCode;

  factory AddPilotPhonesResultDto.fromJson(Map<String, dynamic> json) => _$AddPilotPhonesResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddPilotPhonesResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


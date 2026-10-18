//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationCategoryDto {
  /// Returns a new [VerificationCategoryDto] instance.
  VerificationCategoryDto({

    required  this.id,

    required  this.name,

    required  this.extraRequirements,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



      /// Requisitos extra de verificación (R2.2)
  @JsonKey(
    
    name: r'extraRequirements',
    required: true,
    includeIfNull: false,
  )


  final List<String> extraRequirements;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationCategoryDto &&
      other.id == id &&
      other.name == name &&
      other.extraRequirements == extraRequirements;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        extraRequirements.hashCode;

  factory VerificationCategoryDto.fromJson(Map<String, dynamic> json) => _$VerificationCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationCategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


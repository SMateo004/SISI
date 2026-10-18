//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationRowDto {
  /// Returns a new [VerificationRowDto] instance.
  VerificationRowDto({

    required  this.userId,

    required  this.name,

    required  this.phone,

    required  this.cityName,

    required  this.submittedAt,

    required  this.categories,
  });

  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: true,
  )


  final String? name;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: false,
  )


  final String cityName;



  @JsonKey(
    
    name: r'submittedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime submittedAt;



  @JsonKey(
    
    name: r'categories',
    required: true,
    includeIfNull: false,
  )


  final List<String> categories;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationRowDto &&
      other.userId == userId &&
      other.name == name &&
      other.phone == phone &&
      other.cityName == cityName &&
      other.submittedAt == submittedAt &&
      other.categories == categories;

    @override
    int get hashCode =>
        userId.hashCode +
        (name == null ? 0 : name.hashCode) +
        phone.hashCode +
        cityName.hashCode +
        submittedAt.hashCode +
        categories.hashCode;

  factory VerificationRowDto.fromJson(Map<String, dynamic> json) => _$VerificationRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


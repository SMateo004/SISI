//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/verification_category_dto.dart';
import 'package:sisi_api/src/model/verification_document_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_detail_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationDetailDto {
  /// Returns a new [VerificationDetailDto] instance.
  VerificationDetailDto({

    required  this.userId,

    required  this.name,

    required  this.phone,

    required  this.cityName,

    required  this.submittedAt,

    required  this.categories,

    required  this.status,

    required  this.birthDate,

    required  this.age,

    required  this.transport,

    required  this.maxRadiusKm,

    required  this.categoryDetails,

    required  this.documents,
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



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'birthDate',
    required: true,
    includeIfNull: true,
  )


  final DateTime? birthDate;



      /// Edad en la zona de su ciudad
  @JsonKey(
    
    name: r'age',
    required: true,
    includeIfNull: true,
  )


  final num? age;



  @JsonKey(
    
    name: r'transport',
    required: true,
    includeIfNull: true,
  )


  final String? transport;



  @JsonKey(
    
    name: r'maxRadiusKm',
    required: true,
    includeIfNull: true,
  )


  final num? maxRadiusKm;



  @JsonKey(
    
    name: r'categoryDetails',
    required: true,
    includeIfNull: false,
  )


  final List<VerificationCategoryDto> categoryDetails;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<VerificationDocumentDto> documents;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationDetailDto &&
      other.userId == userId &&
      other.name == name &&
      other.phone == phone &&
      other.cityName == cityName &&
      other.submittedAt == submittedAt &&
      other.categories == categories &&
      other.status == status &&
      other.birthDate == birthDate &&
      other.age == age &&
      other.transport == transport &&
      other.maxRadiusKm == maxRadiusKm &&
      other.categoryDetails == categoryDetails &&
      other.documents == documents;

    @override
    int get hashCode =>
        userId.hashCode +
        (name == null ? 0 : name.hashCode) +
        phone.hashCode +
        cityName.hashCode +
        submittedAt.hashCode +
        categories.hashCode +
        status.hashCode +
        (birthDate == null ? 0 : birthDate.hashCode) +
        (age == null ? 0 : age.hashCode) +
        (transport == null ? 0 : transport.hashCode) +
        (maxRadiusKm == null ? 0 : maxRadiusKm.hashCode) +
        categoryDetails.hashCode +
        documents.hashCode;

  factory VerificationDetailDto.fromJson(Map<String, dynamic> json) => _$VerificationDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationDetailDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


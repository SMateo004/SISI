//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_contact_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobContactDto {
  /// Returns a new [JobContactDto] instance.
  JobContactDto({

    required  this.jobId,

    required  this.role,

    required  this.name,

    required  this.phone,

    required  this.address,

    required  this.finalPriceBs,
  });

  @JsonKey(
    
    name: r'jobId',
    required: true,
    includeIfNull: false,
  )


  final String jobId;



      /// Rol de la contraparte
  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final JobContactDtoRoleEnum role;



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



      /// Dirección del trabajo (solo para el trabajador)
  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: true,
  )


  final String? address;



  @JsonKey(
    
    name: r'finalPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String finalPriceBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobContactDto &&
      other.jobId == jobId &&
      other.role == role &&
      other.name == name &&
      other.phone == phone &&
      other.address == address &&
      other.finalPriceBs == finalPriceBs;

    @override
    int get hashCode =>
        jobId.hashCode +
        role.hashCode +
        (name == null ? 0 : name.hashCode) +
        phone.hashCode +
        (address == null ? 0 : address.hashCode) +
        finalPriceBs.hashCode;

  factory JobContactDto.fromJson(Map<String, dynamic> json) => _$JobContactDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobContactDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Rol de la contraparte
enum JobContactDtoRoleEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const JobContactDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}



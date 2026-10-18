//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_interest_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotInterestRowDto {
  /// Returns a new [PilotInterestRowDto] instance.
  PilotInterestRowDto({

    required  this.id,

    required  this.phone,

    required  this.role,

    required  this.categoryName,

    required  this.zone,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final PilotInterestRowDtoRoleEnum role;



  @JsonKey(
    
    name: r'categoryName',
    required: true,
    includeIfNull: true,
  )


  final String? categoryName;



  @JsonKey(
    
    name: r'zone',
    required: true,
    includeIfNull: true,
  )


  final String? zone;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotInterestRowDto &&
      other.id == id &&
      other.phone == phone &&
      other.role == role &&
      other.categoryName == categoryName &&
      other.zone == zone &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        role.hashCode +
        (categoryName == null ? 0 : categoryName.hashCode) +
        (zone == null ? 0 : zone.hashCode) +
        createdAt.hashCode;

  factory PilotInterestRowDto.fromJson(Map<String, dynamic> json) => _$PilotInterestRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotInterestRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PilotInterestRowDtoRoleEnum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'ambos')
ambos(r'ambos');

const PilotInterestRowDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}



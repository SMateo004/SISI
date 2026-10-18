//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_interest_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotInterestDto {
  /// Returns a new [PilotInterestDto] instance.
  PilotInterestDto({

    required  this.phone,

    required  this.role,

     this.categoryId,

     this.zone,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



      /// Quiere trabajar, contratar o las dos
  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final PilotInterestDtoRoleEnum role;



      /// Categoría que le interesa
  @JsonKey(
    
    name: r'categoryId',
    required: false,
    includeIfNull: false,
  )


  final String? categoryId;



      /// Barrio o zona
  @JsonKey(
    
    name: r'zone',
    required: false,
    includeIfNull: false,
  )


  final String? zone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotInterestDto &&
      other.phone == phone &&
      other.role == role &&
      other.categoryId == categoryId &&
      other.zone == zone;

    @override
    int get hashCode =>
        phone.hashCode +
        role.hashCode +
        categoryId.hashCode +
        zone.hashCode;

  factory PilotInterestDto.fromJson(Map<String, dynamic> json) => _$PilotInterestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotInterestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Quiere trabajar, contratar o las dos
enum PilotInterestDtoRoleEnum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'ambos')
ambos(r'ambos');

const PilotInterestDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserRowDto {
  /// Returns a new [UserRowDto] instance.
  UserRowDto({

    required  this.id,

    required  this.phone,

    required  this.name,

    required  this.role,

    required  this.activeMode,

    required  this.cityName,

    required  this.workerStatus,

    required  this.flagged,

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
    
    name: r'name',
    required: true,
    includeIfNull: true,
  )


  final String? name;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final UserRowDtoRoleEnum role;



  @JsonKey(
    
    name: r'activeMode',
    required: true,
    includeIfNull: false,
  )


  final UserRowDtoActiveModeEnum activeMode;



  @JsonKey(
    
    name: r'cityName',
    required: true,
    includeIfNull: false,
  )


  final String cityName;



      /// Estado del perfil de trabajador
  @JsonKey(
    
    name: r'workerStatus',
    required: true,
    includeIfNull: true,
  )


  final String? workerStatus;



      /// Empleador marcado para revisión (3 reportes válidos)
  @JsonKey(
    
    name: r'flagged',
    required: true,
    includeIfNull: false,
  )


  final bool flagged;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserRowDto &&
      other.id == id &&
      other.phone == phone &&
      other.name == name &&
      other.role == role &&
      other.activeMode == activeMode &&
      other.cityName == cityName &&
      other.workerStatus == workerStatus &&
      other.flagged == flagged &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (name == null ? 0 : name.hashCode) +
        role.hashCode +
        activeMode.hashCode +
        cityName.hashCode +
        (workerStatus == null ? 0 : workerStatus.hashCode) +
        flagged.hashCode +
        createdAt.hashCode;

  factory UserRowDto.fromJson(Map<String, dynamic> json) => _$UserRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UserRowDtoRoleEnum {
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'admin')
admin(r'admin');

const UserRowDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum UserRowDtoActiveModeEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const UserRowDtoActiveModeEnum(this.value);

final String value;

@override
String toString() => value;
}



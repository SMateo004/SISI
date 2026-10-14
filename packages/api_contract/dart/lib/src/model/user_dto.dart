//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserDto {
  /// Returns a new [UserDto] instance.
  UserDto({

    required  this.id,

    required  this.phone,

    required  this.name,

    required  this.photoUrl,

    required  this.role,

    required  this.activeMode,

    required  this.cityId,

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



      /// URL temporal de la foto de perfil
  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final UserDtoRoleEnum role;



  @JsonKey(
    
    name: r'activeMode',
    required: true,
    includeIfNull: false,
  )


  final UserDtoActiveModeEnum activeMode;



  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final String createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserDto &&
      other.id == id &&
      other.phone == phone &&
      other.name == name &&
      other.photoUrl == photoUrl &&
      other.role == role &&
      other.activeMode == activeMode &&
      other.cityId == cityId &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (name == null ? 0 : name.hashCode) +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        role.hashCode +
        activeMode.hashCode +
        cityId.hashCode +
        createdAt.hashCode;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UserDtoRoleEnum {
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'admin')
admin(r'admin');

const UserDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum UserDtoActiveModeEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const UserDtoActiveModeEnum(this.value);

final String value;

@override
String toString() => value;
}



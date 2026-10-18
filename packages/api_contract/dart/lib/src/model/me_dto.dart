//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MeDto {
  /// Returns a new [MeDto] instance.
  MeDto({

    required  this.id,

    required  this.phone,

    required  this.name,

    required  this.photoUrl,

    required  this.role,

    required  this.activeMode,

    required  this.cityId,

    required  this.createdAt,

    required  this.legalPending,
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


  final MeDtoRoleEnum role;



  @JsonKey(
    
    name: r'activeMode',
    required: true,
    includeIfNull: false,
  )


  final MeDtoActiveModeEnum activeMode;



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



  @JsonKey(
    
    name: r'legalPending',
    required: true,
    includeIfNull: false,
  )


  final List<MeDtoLegalPendingEnum> legalPending;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MeDto &&
      other.id == id &&
      other.phone == phone &&
      other.name == name &&
      other.photoUrl == photoUrl &&
      other.role == role &&
      other.activeMode == activeMode &&
      other.cityId == cityId &&
      other.createdAt == createdAt &&
      other.legalPending == legalPending;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (name == null ? 0 : name.hashCode) +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        role.hashCode +
        activeMode.hashCode +
        cityId.hashCode +
        createdAt.hashCode +
        legalPending.hashCode;

  factory MeDto.fromJson(Map<String, dynamic> json) => _$MeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum MeDtoRoleEnum {
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'admin')
admin(r'admin');

const MeDtoRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum MeDtoActiveModeEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const MeDtoActiveModeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum MeDtoLegalPendingEnum {
@JsonValue(r'terms')
terms(r'terms'),
@JsonValue(r'privacy')
privacy(r'privacy');

const MeDtoLegalPendingEnum(this.value);

final String value;

@override
String toString() => value;
}



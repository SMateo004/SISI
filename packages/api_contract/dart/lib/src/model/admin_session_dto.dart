//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/user_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_session_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminSessionDto {
  /// Returns a new [AdminSessionDto] instance.
  AdminSessionDto({

    required  this.accessToken,

    required  this.tokenType,

    required  this.expiresIn,

    required  this.sessionExpiresAt,

    required  this.user,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'tokenType',
    required: true,
    includeIfNull: false,
  )


  final AdminSessionDtoTokenTypeEnum tokenType;



      /// Vida del token de acceso, en segundos
  @JsonKey(
    
    name: r'expiresIn',
    required: true,
    includeIfNull: false,
  )


  final num expiresIn;



      /// Fin de la sesión (8 h desde el login); después hay que volver a ingresar
  @JsonKey(
    
    name: r'sessionExpiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime sessionExpiresAt;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final UserDto user;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminSessionDto &&
      other.accessToken == accessToken &&
      other.tokenType == tokenType &&
      other.expiresIn == expiresIn &&
      other.sessionExpiresAt == sessionExpiresAt &&
      other.user == user;

    @override
    int get hashCode =>
        accessToken.hashCode +
        tokenType.hashCode +
        expiresIn.hashCode +
        sessionExpiresAt.hashCode +
        user.hashCode;

  factory AdminSessionDto.fromJson(Map<String, dynamic> json) => _$AdminSessionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminSessionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminSessionDtoTokenTypeEnum {
@JsonValue(r'Bearer')
bearer(r'Bearer');

const AdminSessionDtoTokenTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



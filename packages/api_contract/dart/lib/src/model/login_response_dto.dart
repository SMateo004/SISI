//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/user_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LoginResponseDto {
  /// Returns a new [LoginResponseDto] instance.
  LoginResponseDto({

    required  this.accessToken,

    required  this.refreshToken,

    required  this.tokenType,

    required  this.expiresIn,

    required  this.refreshExpiresIn,

    required  this.user,

    required  this.isNewUser,
  });

  @JsonKey(
    
    name: r'accessToken',
    required: true,
    includeIfNull: false,
  )


  final String accessToken;



  @JsonKey(
    
    name: r'refreshToken',
    required: true,
    includeIfNull: false,
  )


  final String refreshToken;



  @JsonKey(
    
    name: r'tokenType',
    required: true,
    includeIfNull: false,
  )


  final LoginResponseDtoTokenTypeEnum tokenType;



      /// Vida del token de acceso, en segundos
  @JsonKey(
    
    name: r'expiresIn',
    required: true,
    includeIfNull: false,
  )


  final num expiresIn;



      /// Vida del refresh token, en segundos
  @JsonKey(
    
    name: r'refreshExpiresIn',
    required: true,
    includeIfNull: false,
  )


  final num refreshExpiresIn;



  @JsonKey(
    
    name: r'user',
    required: true,
    includeIfNull: false,
  )


  final UserDto user;



      /// La cuenta se creó en este login
  @JsonKey(
    
    name: r'isNewUser',
    required: true,
    includeIfNull: false,
  )


  final bool isNewUser;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LoginResponseDto &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.tokenType == tokenType &&
      other.expiresIn == expiresIn &&
      other.refreshExpiresIn == refreshExpiresIn &&
      other.user == user &&
      other.isNewUser == isNewUser;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        tokenType.hashCode +
        expiresIn.hashCode +
        refreshExpiresIn.hashCode +
        user.hashCode +
        isNewUser.hashCode;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LoginResponseDtoTokenTypeEnum {
@JsonValue(r'Bearer')
bearer(r'Bearer');

const LoginResponseDtoTokenTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



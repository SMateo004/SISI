//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokens_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TokensDto {
  /// Returns a new [TokensDto] instance.
  TokensDto({

    required  this.accessToken,

    required  this.refreshToken,

    required  this.tokenType,

    required  this.expiresIn,

    required  this.refreshExpiresIn,
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


  final TokensDtoTokenTypeEnum tokenType;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is TokensDto &&
      other.accessToken == accessToken &&
      other.refreshToken == refreshToken &&
      other.tokenType == tokenType &&
      other.expiresIn == expiresIn &&
      other.refreshExpiresIn == refreshExpiresIn;

    @override
    int get hashCode =>
        accessToken.hashCode +
        refreshToken.hashCode +
        tokenType.hashCode +
        expiresIn.hashCode +
        refreshExpiresIn.hashCode;

  factory TokensDto.fromJson(Map<String, dynamic> json) => _$TokensDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TokensDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum TokensDtoTokenTypeEnum {
@JsonValue(r'Bearer')
bearer(r'Bearer');

const TokensDtoTokenTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



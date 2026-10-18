//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'accept_legal_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AcceptLegalDto {
  /// Returns a new [AcceptLegalDto] instance.
  AcceptLegalDto({

    required  this.termsVersion,

    required  this.privacyVersion,

    required  this.adult,

     this.appVersion,

     this.platform,
  });

      /// Versión de los términos que se muestran
  @JsonKey(
    
    name: r'termsVersion',
    required: true,
    includeIfNull: false,
  )


  final num termsVersion;



      /// Versión de la política de privacidad que se muestra
  @JsonKey(
    
    name: r'privacyVersion',
    required: true,
    includeIfNull: false,
  )


  final num privacyVersion;



      /// Declaro ser mayor de 18 años
  @JsonKey(
    
    name: r'adult',
    required: true,
    includeIfNull: false,
  )


  final bool adult;



  @JsonKey(
    
    name: r'appVersion',
    required: false,
    includeIfNull: false,
  )


  final String? appVersion;



  @JsonKey(
    
    name: r'platform',
    required: false,
    includeIfNull: false,
  )


  final AcceptLegalDtoPlatformEnum? platform;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AcceptLegalDto &&
      other.termsVersion == termsVersion &&
      other.privacyVersion == privacyVersion &&
      other.adult == adult &&
      other.appVersion == appVersion &&
      other.platform == platform;

    @override
    int get hashCode =>
        termsVersion.hashCode +
        privacyVersion.hashCode +
        adult.hashCode +
        appVersion.hashCode +
        platform.hashCode;

  factory AcceptLegalDto.fromJson(Map<String, dynamic> json) => _$AcceptLegalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptLegalDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AcceptLegalDtoPlatformEnum {
@JsonValue(r'android')
android(r'android'),
@JsonValue(r'ios')
ios(r'ios'),
@JsonValue(r'web')
web(r'web');

const AcceptLegalDtoPlatformEnum(this.value);

final String value;

@override
String toString() => value;
}



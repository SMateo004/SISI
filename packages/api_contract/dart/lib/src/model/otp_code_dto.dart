//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_code_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpCodeDto {
  /// Returns a new [OtpCodeDto] instance.
  OtpCodeDto({

    required  this.phone,

    required  this.code,

    required  this.sentAt,

    required  this.expiresAt,

     this.usedAt,

    required  this.accountExists,

     this.name,

     this.activeMode,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'sentAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime sentAt;



  @JsonKey(
    
    name: r'expiresAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime expiresAt;



  @JsonKey(
    
    name: r'usedAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? usedAt;



      /// El número ya tiene cuenta (si no, es un registro nuevo)
  @JsonKey(
    
    name: r'accountExists',
    required: true,
    includeIfNull: false,
  )


  final bool accountExists;



  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'activeMode',
    required: false,
    includeIfNull: false,
  )


  final OtpCodeDtoActiveModeEnum? activeMode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpCodeDto &&
      other.phone == phone &&
      other.code == code &&
      other.sentAt == sentAt &&
      other.expiresAt == expiresAt &&
      other.usedAt == usedAt &&
      other.accountExists == accountExists &&
      other.name == name &&
      other.activeMode == activeMode;

    @override
    int get hashCode =>
        phone.hashCode +
        code.hashCode +
        sentAt.hashCode +
        expiresAt.hashCode +
        (usedAt == null ? 0 : usedAt.hashCode) +
        accountExists.hashCode +
        (name == null ? 0 : name.hashCode) +
        (activeMode == null ? 0 : activeMode.hashCode);

  factory OtpCodeDto.fromJson(Map<String, dynamic> json) => _$OtpCodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpCodeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum OtpCodeDtoActiveModeEnum {
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'worker')
worker(r'worker');

const OtpCodeDtoActiveModeEnum(this.value);

final String value;

@override
String toString() => value;
}



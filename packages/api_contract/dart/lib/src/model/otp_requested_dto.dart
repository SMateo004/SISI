//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_requested_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpRequestedDto {
  /// Returns a new [OtpRequestedDto] instance.
  OtpRequestedDto({

    required  this.expiresInSec,

    required  this.resendInSec,
  });

      /// Segundos hasta que vence el código
  @JsonKey(
    
    name: r'expiresInSec',
    required: true,
    includeIfNull: false,
  )


  final num expiresInSec;



      /// Segundos hasta poder pedir otro código
  @JsonKey(
    
    name: r'resendInSec',
    required: true,
    includeIfNull: false,
  )


  final num resendInSec;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpRequestedDto &&
      other.expiresInSec == expiresInSec &&
      other.resendInSec == resendInSec;

    @override
    int get hashCode =>
        expiresInSec.hashCode +
        resendInSec.hashCode;

  factory OtpRequestedDto.fromJson(Map<String, dynamic> json) => _$OtpRequestedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestedDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


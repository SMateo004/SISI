//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerifyOtpDto {
  /// Returns a new [VerifyOtpDto] instance.
  VerifyOtpDto({

    required  this.phone,

    required  this.code,
  });

      /// Celular. Sin prefijo se asume Bolivia (+591).
  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



      /// Código de 6 dígitos recibido por SMS
  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerifyOtpDto &&
      other.phone == phone &&
      other.code == code;

    @override
    int get hashCode =>
        phone.hashCode +
        code.hashCode;

  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) => _$VerifyOtpDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


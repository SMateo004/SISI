//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/otp_code_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_codes_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpCodesDto {
  /// Returns a new [OtpCodesDto] instance.
  OtpCodesDto({

    required  this.enabled,

    required  this.items,
  });

      /// Solo con OTP_PROVIDER=console y fuera de producción; si no, siempre vacío
  @JsonKey(
    
    name: r'enabled',
    required: true,
    includeIfNull: false,
  )


  final bool enabled;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<OtpCodeDto> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpCodesDto &&
      other.enabled == enabled &&
      other.items == items;

    @override
    int get hashCode =>
        enabled.hashCode +
        items.hashCode;

  factory OtpCodesDto.fromJson(Map<String, dynamic> json) => _$OtpCodesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpCodesDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


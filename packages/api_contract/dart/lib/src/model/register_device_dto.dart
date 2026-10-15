//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_device_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RegisterDeviceDto {
  /// Returns a new [RegisterDeviceDto] instance.
  RegisterDeviceDto({

    required  this.token,

    required  this.platform,
  });

      /// Token de FCM del dispositivo
  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: false,
  )


  final String token;



  @JsonKey(
    
    name: r'platform',
    required: true,
    includeIfNull: false,
  )


  final RegisterDeviceDtoPlatformEnum platform;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RegisterDeviceDto &&
      other.token == token &&
      other.platform == platform;

    @override
    int get hashCode =>
        token.hashCode +
        platform.hashCode;

  factory RegisterDeviceDto.fromJson(Map<String, dynamic> json) => _$RegisterDeviceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RegisterDeviceDtoPlatformEnum {
@JsonValue(r'android')
android(r'android'),
@JsonValue(r'web')
web(r'web'),
@JsonValue(r'ios')
ios(r'ios');

const RegisterDeviceDtoPlatformEnum(this.value);

final String value;

@override
String toString() => value;
}



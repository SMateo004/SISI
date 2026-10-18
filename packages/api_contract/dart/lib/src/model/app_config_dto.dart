//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/support_dto.dart';
import 'package:sisi_api/src/model/legal_version_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_config_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AppConfigDto {
  /// Returns a new [AppConfigDto] instance.
  AppConfigDto({

    required  this.platform,

    required  this.minVersion,

    required  this.upgradeRequired,

    required  this.storeUrl,

    required  this.support,

    required  this.legal,
  });

  @JsonKey(
    
    name: r'platform',
    required: true,
    includeIfNull: false,
  )


  final AppConfigDtoPlatformEnum platform;



  @JsonKey(
    
    name: r'minVersion',
    required: true,
    includeIfNull: false,
  )


  final String minVersion;



      /// La versión enviada es menor que la mínima
  @JsonKey(
    
    name: r'upgradeRequired',
    required: true,
    includeIfNull: false,
  )


  final bool upgradeRequired;



  @JsonKey(
    
    name: r'storeUrl',
    required: true,
    includeIfNull: true,
  )


  final String? storeUrl;



  @JsonKey(
    
    name: r'support',
    required: true,
    includeIfNull: true,
  )


  final SupportDto? support;



  @JsonKey(
    
    name: r'legal',
    required: true,
    includeIfNull: false,
  )


  final List<LegalVersionDto> legal;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AppConfigDto &&
      other.platform == platform &&
      other.minVersion == minVersion &&
      other.upgradeRequired == upgradeRequired &&
      other.storeUrl == storeUrl &&
      other.support == support &&
      other.legal == legal;

    @override
    int get hashCode =>
        platform.hashCode +
        minVersion.hashCode +
        upgradeRequired.hashCode +
        (storeUrl == null ? 0 : storeUrl.hashCode) +
        (support == null ? 0 : support.hashCode) +
        legal.hashCode;

  factory AppConfigDto.fromJson(Map<String, dynamic> json) => _$AppConfigDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AppConfigDtoPlatformEnum {
@JsonValue(r'android')
android(r'android'),
@JsonValue(r'ios')
ios(r'ios'),
@JsonValue(r'web')
web(r'web');

const AppConfigDtoPlatformEnum(this.value);

final String value;

@override
String toString() => value;
}



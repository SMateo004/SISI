//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'version_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VersionDto {
  /// Returns a new [VersionDto] instance.
  VersionDto({

    required  this.version,

    required  this.sha,

    required  this.env,
  });

  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final String version;



  @JsonKey(
    
    name: r'sha',
    required: true,
    includeIfNull: true,
  )


  final String? sha;



  @JsonKey(
    
    name: r'env',
    required: true,
    includeIfNull: false,
  )


  final String env;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VersionDto &&
      other.version == version &&
      other.sha == sha &&
      other.env == env;

    @override
    int get hashCode =>
        version.hashCode +
        (sha == null ? 0 : sha.hashCode) +
        env.hashCode;

  factory VersionDto.fromJson(Map<String, dynamic> json) => _$VersionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VersionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


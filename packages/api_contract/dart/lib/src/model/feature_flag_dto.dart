//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feature_flag_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FeatureFlagDto {
  /// Returns a new [FeatureFlagDto] instance.
  FeatureFlagDto({

    required  this.key,

    required  this.cityId,

    required  this.enabled,

    required  this.description,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;



  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: true,
  )


  final String? cityId;



  @JsonKey(
    
    name: r'enabled',
    required: true,
    includeIfNull: false,
  )


  final bool enabled;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: true,
  )


  final String? description;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final String updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FeatureFlagDto &&
      other.key == key &&
      other.cityId == cityId &&
      other.enabled == enabled &&
      other.description == description &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        key.hashCode +
        (cityId == null ? 0 : cityId.hashCode) +
        enabled.hashCode +
        (description == null ? 0 : description.hashCode) +
        updatedAt.hashCode;

  factory FeatureFlagDto.fromJson(Map<String, dynamic> json) => _$FeatureFlagDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureFlagDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_feature_flag_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SetFeatureFlagDto {
  /// Returns a new [SetFeatureFlagDto] instance.
  SetFeatureFlagDto({

    required  this.enabled,

     this.cityId,

     this.description,

     this.reason,
  });

  @JsonKey(
    
    name: r'enabled',
    required: true,
    includeIfNull: false,
  )


  final bool enabled;



      /// null u omitido = valor global
  @JsonKey(
    
    name: r'cityId',
    required: false,
    includeIfNull: false,
  )


  final String? cityId;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



      /// Motivo (queda en la auditoría)
  @JsonKey(
    
    name: r'reason',
    required: false,
    includeIfNull: false,
  )


  final String? reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SetFeatureFlagDto &&
      other.enabled == enabled &&
      other.cityId == cityId &&
      other.description == description &&
      other.reason == reason;

    @override
    int get hashCode =>
        enabled.hashCode +
        (cityId == null ? 0 : cityId.hashCode) +
        description.hashCode +
        reason.hashCode;

  factory SetFeatureFlagDto.fromJson(Map<String, dynamic> json) => _$SetFeatureFlagDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SetFeatureFlagDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


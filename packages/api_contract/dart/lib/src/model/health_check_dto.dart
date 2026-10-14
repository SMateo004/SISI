//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_check_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthCheckDto {
  /// Returns a new [HealthCheckDto] instance.
  HealthCheckDto({

    required  this.status,

     this.version,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final HealthCheckDtoStatusEnum status;



      /// Versión reportada (solo PostGIS)
  @JsonKey(
    
    name: r'version',
    required: false,
    includeIfNull: false,
  )


  final String? version;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HealthCheckDto &&
      other.status == status &&
      other.version == version;

    @override
    int get hashCode =>
        status.hashCode +
        version.hashCode;

  factory HealthCheckDto.fromJson(Map<String, dynamic> json) => _$HealthCheckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HealthCheckDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HealthCheckDtoStatusEnum {
@JsonValue(r'up')
up(r'up'),
@JsonValue(r'down')
down(r'down');

const HealthCheckDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



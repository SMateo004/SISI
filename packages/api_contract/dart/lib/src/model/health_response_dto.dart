//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/health_checks_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_response_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthResponseDto {
  /// Returns a new [HealthResponseDto] instance.
  HealthResponseDto({

    required  this.status,

    required  this.checks,

    required  this.timestamp,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final HealthResponseDtoStatusEnum status;



  @JsonKey(
    
    name: r'checks',
    required: true,
    includeIfNull: false,
  )


  final HealthChecksDto checks;



  @JsonKey(
    
    name: r'timestamp',
    required: true,
    includeIfNull: false,
  )


  final String timestamp;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HealthResponseDto &&
      other.status == status &&
      other.checks == checks &&
      other.timestamp == timestamp;

    @override
    int get hashCode =>
        status.hashCode +
        checks.hashCode +
        timestamp.hashCode;

  factory HealthResponseDto.fromJson(Map<String, dynamic> json) => _$HealthResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HealthResponseDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HealthResponseDtoStatusEnum {
@JsonValue(r'ok')
ok(r'ok'),
@JsonValue(r'error')
error(r'error');

const HealthResponseDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



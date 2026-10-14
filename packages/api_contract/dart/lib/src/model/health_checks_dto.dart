//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/health_check_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_checks_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HealthChecksDto {
  /// Returns a new [HealthChecksDto] instance.
  HealthChecksDto({

    required  this.database,

    required  this.postgis,

    required  this.redis,
  });

  @JsonKey(
    
    name: r'database',
    required: true,
    includeIfNull: false,
  )


  final HealthCheckDto database;



  @JsonKey(
    
    name: r'postgis',
    required: true,
    includeIfNull: false,
  )


  final HealthCheckDto postgis;



  @JsonKey(
    
    name: r'redis',
    required: true,
    includeIfNull: false,
  )


  final HealthCheckDto redis;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HealthChecksDto &&
      other.database == database &&
      other.postgis == postgis &&
      other.redis == redis;

    @override
    int get hashCode =>
        database.hashCode +
        postgis.hashCode +
        redis.hashCode;

  factory HealthChecksDto.fromJson(Map<String, dynamic> json) => _$HealthChecksDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HealthChecksDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


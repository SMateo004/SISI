//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reported_user_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReportedUserDto {
  /// Returns a new [ReportedUserDto] instance.
  ReportedUserDto({

    required  this.id,

    required  this.name,

    required  this.phone,

    required  this.validReporters,

    required  this.workerStatus,

    required  this.flaggedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: true,
  )


  final String? name;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



      /// Personas distintas con un reporte válido contra este usuario
  @JsonKey(
    
    name: r'validReporters',
    required: true,
    includeIfNull: false,
  )


  final num validReporters;



  @JsonKey(
    
    name: r'workerStatus',
    required: true,
    includeIfNull: true,
  )


  final String? workerStatus;



      /// Marcado para revisión (solo empleador con 3 reportes válidos)
  @JsonKey(
    
    name: r'flaggedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? flaggedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReportedUserDto &&
      other.id == id &&
      other.name == name &&
      other.phone == phone &&
      other.validReporters == validReporters &&
      other.workerStatus == workerStatus &&
      other.flaggedAt == flaggedAt;

    @override
    int get hashCode =>
        id.hashCode +
        (name == null ? 0 : name.hashCode) +
        phone.hashCode +
        validReporters.hashCode +
        (workerStatus == null ? 0 : workerStatus.hashCode) +
        (flaggedAt == null ? 0 : flaggedAt.hashCode);

  factory ReportedUserDto.fromJson(Map<String, dynamic> json) => _$ReportedUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReportedUserDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


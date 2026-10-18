//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'counters_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CountersDto {
  /// Returns a new [CountersDto] instance.
  CountersDto({

    required  this.verifications,

    required  this.heldRequests,

    required  this.heldMessages,

    required  this.reports,

    required  this.disputes,

    required  this.submissions,
  });

      /// Solicitudes de trabajador por revisar
  @JsonKey(
    
    name: r'verifications',
    required: true,
    includeIfNull: false,
  )


  final num verifications;



      /// Solicitudes retenidas por moderación
  @JsonKey(
    
    name: r'heldRequests',
    required: true,
    includeIfNull: false,
  )


  final num heldRequests;



      /// Mensajes de chat retenidos
  @JsonKey(
    
    name: r'heldMessages',
    required: true,
    includeIfNull: false,
  )


  final num heldMessages;



      /// Reportes pendientes
  @JsonKey(
    
    name: r'reports',
    required: true,
    includeIfNull: false,
  )


  final num reports;



      /// Disputas abiertas
  @JsonKey(
    
    name: r'disputes',
    required: true,
    includeIfNull: false,
  )


  final num disputes;



      /// Comprobantes por revisar
  @JsonKey(
    
    name: r'submissions',
    required: true,
    includeIfNull: false,
  )


  final num submissions;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CountersDto &&
      other.verifications == verifications &&
      other.heldRequests == heldRequests &&
      other.heldMessages == heldMessages &&
      other.reports == reports &&
      other.disputes == disputes &&
      other.submissions == submissions;

    @override
    int get hashCode =>
        verifications.hashCode +
        heldRequests.hashCode +
        heldMessages.hashCode +
        reports.hashCode +
        disputes.hashCode +
        submissions.hashCode;

  factory CountersDto.fromJson(Map<String, dynamic> json) => _$CountersDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CountersDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


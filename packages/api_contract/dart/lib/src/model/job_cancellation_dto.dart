//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_cancellation_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobCancellationDto {
  /// Returns a new [JobCancellationDto] instance.
  JobCancellationDto({

    required  this.by,

    required  this.reason,

    required  this.note,

    required  this.noteHeld,
  });

      /// Quién canceló
  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final JobCancellationDtoByEnum by;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: true,
  )


  final JobCancellationDtoReasonEnum? reason;



      /// Nota de quien canceló. Si la moderación la retuvo, solo la ve quien la escribió.
  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



      /// La nota quedó retenida por moderación (solo para quien la escribió)
  @JsonKey(
    
    name: r'noteHeld',
    required: true,
    includeIfNull: false,
  )


  final bool noteHeld;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobCancellationDto &&
      other.by == by &&
      other.reason == reason &&
      other.note == note &&
      other.noteHeld == noteHeld;

    @override
    int get hashCode =>
        by.hashCode +
        (reason == null ? 0 : reason.hashCode) +
        (note == null ? 0 : note.hashCode) +
        noteHeld.hashCode;

  factory JobCancellationDto.fromJson(Map<String, dynamic> json) => _$JobCancellationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JobCancellationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// Quién canceló
enum JobCancellationDtoByEnum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'admin')
admin(r'admin');

const JobCancellationDtoByEnum(this.value);

final String value;

@override
String toString() => value;
}


enum JobCancellationDtoReasonEnum {
@JsonValue(r'cambio_de_planes')
cambioDePlanes(r'cambio_de_planes'),
@JsonValue(r'no_llega_o_no_responde')
noLlegaONoResponde(r'no_llega_o_no_responde'),
@JsonValue(r'desacuerdo_de_precio')
desacuerdoDePrecio(r'desacuerdo_de_precio'),
@JsonValue(r'emergencia')
emergencia(r'emergencia'),
@JsonValue(r'otro')
otro(r'otro');

const JobCancellationDtoReasonEnum(this.value);

final String value;

@override
String toString() => value;
}



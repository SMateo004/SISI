//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancel_job_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancelJobDto {
  /// Returns a new [CancelJobDto] instance.
  CancelJobDto({

    required  this.reason,

     this.note,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final CancelJobDtoReasonEnum reason;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancelJobDto &&
      other.reason == reason &&
      other.note == note;

    @override
    int get hashCode =>
        reason.hashCode +
        note.hashCode;

  factory CancelJobDto.fromJson(Map<String, dynamic> json) => _$CancelJobDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CancelJobDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CancelJobDtoReasonEnum {
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

const CancelJobDtoReasonEnum(this.value);

final String value;

@override
String toString() => value;
}



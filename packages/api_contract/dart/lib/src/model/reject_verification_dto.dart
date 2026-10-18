//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reject_verification_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RejectVerificationDto {
  /// Returns a new [RejectVerificationDto] instance.
  RejectVerificationDto({

    required  this.reason,

    required  this.note,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final RejectVerificationDtoReasonEnum reason;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RejectVerificationDto &&
      other.reason == reason &&
      other.note == note;

    @override
    int get hashCode =>
        reason.hashCode +
        note.hashCode;

  factory RejectVerificationDto.fromJson(Map<String, dynamic> json) => _$RejectVerificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RejectVerificationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RejectVerificationDtoReasonEnum {
@JsonValue(r'documento_ilegible')
documentoIlegible(r'documento_ilegible'),
@JsonValue(r'documento_no_coincide')
documentoNoCoincide(r'documento_no_coincide'),
@JsonValue(r'selfie_no_coincide')
selfieNoCoincide(r'selfie_no_coincide'),
@JsonValue(r'menor_de_edad')
menorDeEdad(r'menor_de_edad'),
@JsonValue(r'documento_vencido')
documentoVencido(r'documento_vencido'),
@JsonValue(r'requisitos_de_categoria')
requisitosDeCategoria(r'requisitos_de_categoria'),
@JsonValue(r'datos_incompletos')
datosIncompletos(r'datos_incompletos'),
@JsonValue(r'otro')
otro(r'otro');

const RejectVerificationDtoReasonEnum(this.value);

final String value;

@override
String toString() => value;
}



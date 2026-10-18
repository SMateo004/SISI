//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_funnel_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotFunnelDto {
  /// Returns a new [PilotFunnelDto] instance.
  PilotFunnelDto({

    required  this.created,

    required  this.withOffer,

    required  this.assigned,

    required  this.completed,

    required  this.commissionCollected,
  });

      /// Solicitudes publicadas (sin borradores)
  @JsonKey(
    
    name: r'created',
    required: true,
    includeIfNull: false,
  )


  final num created;



      /// Con al menos una oferta
  @JsonKey(
    
    name: r'withOffer',
    required: true,
    includeIfNull: false,
  )


  final num withOffer;



      /// Asignadas (trabajo creado)
  @JsonKey(
    
    name: r'assigned',
    required: true,
    includeIfNull: false,
  )


  final num assigned;



      /// Trabajo terminado
  @JsonKey(
    
    name: r'completed',
    required: true,
    includeIfNull: false,
  )


  final num completed;



      /// Terminado y con la comisión ya cobrada (periodo pagado)
  @JsonKey(
    
    name: r'commissionCollected',
    required: true,
    includeIfNull: false,
  )


  final num commissionCollected;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotFunnelDto &&
      other.created == created &&
      other.withOffer == withOffer &&
      other.assigned == assigned &&
      other.completed == completed &&
      other.commissionCollected == commissionCollected;

    @override
    int get hashCode =>
        created.hashCode +
        withOffer.hashCode +
        assigned.hashCode +
        completed.hashCode +
        commissionCollected.hashCode;

  factory PilotFunnelDto.fromJson(Map<String, dynamic> json) => _$PilotFunnelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotFunnelDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


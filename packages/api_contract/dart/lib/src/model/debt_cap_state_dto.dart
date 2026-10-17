//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debt_cap_state_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DebtCapStateDto {
  /// Returns a new [DebtCapStateDto] instance.
  DebtCapStateDto({

    required  this.capBs,

    required  this.reached,

    required  this.amountToUnlockBs,
  });

      /// Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'capBs',
    required: true,
    includeIfNull: false,
  )


  final String capBs;



      /// El saldo supera el tope: no recibe solicitudes nuevas (R7.5)
  @JsonKey(
    
    name: r'reached',
    required: true,
    includeIfNull: false,
  )


  final bool reached;



      /// Lo que hay que pagar para volver a recibir solicitudes (0 si no está sobre el tope). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'amountToUnlockBs',
    required: true,
    includeIfNull: false,
  )


  final String amountToUnlockBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DebtCapStateDto &&
      other.capBs == capBs &&
      other.reached == reached &&
      other.amountToUnlockBs == amountToUnlockBs;

    @override
    int get hashCode =>
        capBs.hashCode +
        reached.hashCode +
        amountToUnlockBs.hashCode;

  factory DebtCapStateDto.fromJson(Map<String, dynamic> json) => _$DebtCapStateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DebtCapStateDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


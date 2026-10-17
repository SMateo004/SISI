//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_period_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CurrentPeriodDto {
  /// Returns a new [CurrentPeriodDto] instance.
  CurrentPeriodDto({

    required  this.id,

    required  this.startAt,

    required  this.endAt,

    required  this.dueAt,

    required  this.grossBs,

    required  this.commissionBs,

    required  this.netBs,

    required  this.paymentReference,
  });

      /// null si todavía no hay trabajos esta semana
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: true,
  )


  final String? id;



  @JsonKey(
    
    name: r'startAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime startAt;



  @JsonKey(
    
    name: r'endAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime endAt;



      /// Vencimiento de este periodo (miércoles 23:59 siguiente)
  @JsonKey(
    
    name: r'dueAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime dueAt;



      /// Ganado en el periodo (bruto, R8.1). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'grossBs',
    required: true,
    includeIfNull: false,
  )


  final String grossBs;



      /// Comisión del periodo. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'commissionBs',
    required: true,
    includeIfNull: false,
  )


  final String commissionBs;



      /// Neto del periodo: bruto − comisión. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'netBs',
    required: true,
    includeIfNull: false,
  )


  final String netBs;



  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: true,
  )


  final String? paymentReference;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CurrentPeriodDto &&
      other.id == id &&
      other.startAt == startAt &&
      other.endAt == endAt &&
      other.dueAt == dueAt &&
      other.grossBs == grossBs &&
      other.commissionBs == commissionBs &&
      other.netBs == netBs &&
      other.paymentReference == paymentReference;

    @override
    int get hashCode =>
        (id == null ? 0 : id.hashCode) +
        startAt.hashCode +
        endAt.hashCode +
        dueAt.hashCode +
        grossBs.hashCode +
        commissionBs.hashCode +
        netBs.hashCode +
        (paymentReference == null ? 0 : paymentReference.hashCode);

  factory CurrentPeriodDto.fromJson(Map<String, dynamic> json) => _$CurrentPeriodDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentPeriodDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


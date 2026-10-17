//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'period_summary_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PeriodSummaryDto {
  /// Returns a new [PeriodSummaryDto] instance.
  PeriodSummaryDto({

    required  this.id,

    required  this.startAt,

    required  this.endAt,

    required  this.dueAt,

    required  this.status,

    required  this.grossBs,

    required  this.commissionBs,

    required  this.netBs,

    required  this.balanceBs,

    required  this.paymentReference,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'dueAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime dueAt;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final PeriodSummaryDtoStatusEnum status;



      /// Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'grossBs',
    required: true,
    includeIfNull: false,
  )


  final String grossBs;



      /// Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'commissionBs',
    required: true,
    includeIfNull: false,
  )


  final String commissionBs;



      /// Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'netBs',
    required: true,
    includeIfNull: false,
  )


  final String netBs;



      /// Lo que queda por pagar de este periodo (negativo = a favor). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;



  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: false,
  )


  final String paymentReference;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PeriodSummaryDto &&
      other.id == id &&
      other.startAt == startAt &&
      other.endAt == endAt &&
      other.dueAt == dueAt &&
      other.status == status &&
      other.grossBs == grossBs &&
      other.commissionBs == commissionBs &&
      other.netBs == netBs &&
      other.balanceBs == balanceBs &&
      other.paymentReference == paymentReference;

    @override
    int get hashCode =>
        id.hashCode +
        startAt.hashCode +
        endAt.hashCode +
        dueAt.hashCode +
        status.hashCode +
        grossBs.hashCode +
        commissionBs.hashCode +
        netBs.hashCode +
        balanceBs.hashCode +
        paymentReference.hashCode;

  factory PeriodSummaryDto.fromJson(Map<String, dynamic> json) => _$PeriodSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodSummaryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PeriodSummaryDtoStatusEnum {
@JsonValue(r'abierto')
abierto(r'abierto'),
@JsonValue(r'cerrado_pendiente')
cerradoPendiente(r'cerrado_pendiente'),
@JsonValue(r'pagado')
pagado(r'pagado'),
@JsonValue(r'vencido')
vencido(r'vencido');

const PeriodSummaryDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



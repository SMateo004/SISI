//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'panel_period_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PanelPeriodDto {
  /// Returns a new [PanelPeriodDto] instance.
  PanelPeriodDto({

    required  this.id,

    required  this.workerId,

    required  this.workerName,

    required  this.workerPhone,

    required  this.status,

    required  this.paymentReference,

    required  this.startAt,

    required  this.endAt,

    required  this.dueAt,

    required  this.grossBs,

    required  this.commissionBs,

    required  this.balanceBs,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



  @JsonKey(
    
    name: r'workerName',
    required: true,
    includeIfNull: true,
  )


  final String? workerName;



  @JsonKey(
    
    name: r'workerPhone',
    required: true,
    includeIfNull: false,
  )


  final String workerPhone;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final PanelPeriodDtoStatusEnum status;



  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: false,
  )


  final String paymentReference;



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
    
    name: r'grossBs',
    required: true,
    includeIfNull: false,
  )


  final String grossBs;



  @JsonKey(
    
    name: r'commissionBs',
    required: true,
    includeIfNull: false,
  )


  final String commissionBs;



      /// Saldo del periodo (suma del ledger)
  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PanelPeriodDto &&
      other.id == id &&
      other.workerId == workerId &&
      other.workerName == workerName &&
      other.workerPhone == workerPhone &&
      other.status == status &&
      other.paymentReference == paymentReference &&
      other.startAt == startAt &&
      other.endAt == endAt &&
      other.dueAt == dueAt &&
      other.grossBs == grossBs &&
      other.commissionBs == commissionBs &&
      other.balanceBs == balanceBs;

    @override
    int get hashCode =>
        id.hashCode +
        workerId.hashCode +
        (workerName == null ? 0 : workerName.hashCode) +
        workerPhone.hashCode +
        status.hashCode +
        paymentReference.hashCode +
        startAt.hashCode +
        endAt.hashCode +
        dueAt.hashCode +
        grossBs.hashCode +
        commissionBs.hashCode +
        balanceBs.hashCode;

  factory PanelPeriodDto.fromJson(Map<String, dynamic> json) => _$PanelPeriodDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PanelPeriodDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PanelPeriodDtoStatusEnum {
@JsonValue(r'abierto')
abierto(r'abierto'),
@JsonValue(r'cerrado_pendiente')
cerradoPendiente(r'cerrado_pendiente'),
@JsonValue(r'pagado')
pagado(r'pagado'),
@JsonValue(r'vencido')
vencido(r'vencido');

const PanelPeriodDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



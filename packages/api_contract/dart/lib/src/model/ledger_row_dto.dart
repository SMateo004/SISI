//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ledger_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LedgerRowDto {
  /// Returns a new [LedgerRowDto] instance.
  LedgerRowDto({

    required  this.id,

    required  this.type,

    required  this.amountBs,

    required  this.runningBs,

    required  this.paymentReference,

    required  this.jobId,

    required  this.paymentId,

    required  this.correctsEntryId,

    required  this.reason,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final LedgerRowDtoTypeEnum type;



      /// Con signo: + debe, − paga
  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



      /// Saldo acumulado después de este movimiento
  @JsonKey(
    
    name: r'runningBs',
    required: true,
    includeIfNull: false,
  )


  final String runningBs;



  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: false,
  )


  final String paymentReference;



  @JsonKey(
    
    name: r'jobId',
    required: true,
    includeIfNull: true,
  )


  final String? jobId;



  @JsonKey(
    
    name: r'paymentId',
    required: true,
    includeIfNull: true,
  )


  final String? paymentId;



  @JsonKey(
    
    name: r'correctsEntryId',
    required: true,
    includeIfNull: true,
  )


  final String? correctsEntryId;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: true,
  )


  final String? reason;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LedgerRowDto &&
      other.id == id &&
      other.type == type &&
      other.amountBs == amountBs &&
      other.runningBs == runningBs &&
      other.paymentReference == paymentReference &&
      other.jobId == jobId &&
      other.paymentId == paymentId &&
      other.correctsEntryId == correctsEntryId &&
      other.reason == reason &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        amountBs.hashCode +
        runningBs.hashCode +
        paymentReference.hashCode +
        (jobId == null ? 0 : jobId.hashCode) +
        (paymentId == null ? 0 : paymentId.hashCode) +
        (correctsEntryId == null ? 0 : correctsEntryId.hashCode) +
        (reason == null ? 0 : reason.hashCode) +
        createdAt.hashCode;

  factory LedgerRowDto.fromJson(Map<String, dynamic> json) => _$LedgerRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LedgerRowDtoTypeEnum {
@JsonValue(r'comision')
comision(r'comision'),
@JsonValue(r'pago')
pago(r'pago'),
@JsonValue(r'ajuste')
ajuste(r'ajuste');

const LedgerRowDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



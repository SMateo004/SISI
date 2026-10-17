//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_ledger_entry_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminLedgerEntryDto {
  /// Returns a new [AdminLedgerEntryDto] instance.
  AdminLedgerEntryDto({

    required  this.id,

    required  this.type,

    required  this.amountBs,

    required  this.periodId,

    required  this.jobId,

    required  this.paymentId,

    required  this.correctsEntryId,

    required  this.reason,

    required  this.createdById,

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


  final AdminLedgerEntryDtoTypeEnum type;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'periodId',
    required: true,
    includeIfNull: false,
  )


  final String periodId;



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
    
    name: r'createdById',
    required: true,
    includeIfNull: true,
  )


  final String? createdById;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminLedgerEntryDto &&
      other.id == id &&
      other.type == type &&
      other.amountBs == amountBs &&
      other.periodId == periodId &&
      other.jobId == jobId &&
      other.paymentId == paymentId &&
      other.correctsEntryId == correctsEntryId &&
      other.reason == reason &&
      other.createdById == createdById &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        amountBs.hashCode +
        periodId.hashCode +
        (jobId == null ? 0 : jobId.hashCode) +
        (paymentId == null ? 0 : paymentId.hashCode) +
        (correctsEntryId == null ? 0 : correctsEntryId.hashCode) +
        (reason == null ? 0 : reason.hashCode) +
        (createdById == null ? 0 : createdById.hashCode) +
        createdAt.hashCode;

  factory AdminLedgerEntryDto.fromJson(Map<String, dynamic> json) => _$AdminLedgerEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminLedgerEntryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminLedgerEntryDtoTypeEnum {
@JsonValue(r'comision')
comision(r'comision'),
@JsonValue(r'pago')
pago(r'pago'),
@JsonValue(r'ajuste')
ajuste(r'ajuste');

const AdminLedgerEntryDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



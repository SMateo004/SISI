//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'period_row_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PeriodRowDto {
  /// Returns a new [PeriodRowDto] instance.
  PeriodRowDto({

    required  this.id,

    required  this.status,

    required  this.paymentReference,

    required  this.startAt,

    required  this.dueAt,

    required  this.commissionBs,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



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
    
    name: r'dueAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime dueAt;



  @JsonKey(
    
    name: r'commissionBs',
    required: true,
    includeIfNull: false,
  )


  final String commissionBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PeriodRowDto &&
      other.id == id &&
      other.status == status &&
      other.paymentReference == paymentReference &&
      other.startAt == startAt &&
      other.dueAt == dueAt &&
      other.commissionBs == commissionBs;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        paymentReference.hashCode +
        startAt.hashCode +
        dueAt.hashCode +
        commissionBs.hashCode;

  factory PeriodRowDto.fromJson(Map<String, dynamic> json) => _$PeriodRowDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodRowDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


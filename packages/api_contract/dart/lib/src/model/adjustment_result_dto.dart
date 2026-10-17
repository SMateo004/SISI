//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adjustment_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdjustmentResultDto {
  /// Returns a new [AdjustmentResultDto] instance.
  AdjustmentResultDto({

    required  this.entryId,

    required  this.periodId,

    required  this.amountBs,

    required  this.periodStatus,

    required  this.balanceBs,
  });

  @JsonKey(
    
    name: r'entryId',
    required: true,
    includeIfNull: false,
  )


  final String entryId;



  @JsonKey(
    
    name: r'periodId',
    required: true,
    includeIfNull: false,
  )


  final String periodId;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'periodStatus',
    required: true,
    includeIfNull: false,
  )


  final AdjustmentResultDtoPeriodStatusEnum periodStatus;



  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdjustmentResultDto &&
      other.entryId == entryId &&
      other.periodId == periodId &&
      other.amountBs == amountBs &&
      other.periodStatus == periodStatus &&
      other.balanceBs == balanceBs;

    @override
    int get hashCode =>
        entryId.hashCode +
        periodId.hashCode +
        amountBs.hashCode +
        periodStatus.hashCode +
        balanceBs.hashCode;

  factory AdjustmentResultDto.fromJson(Map<String, dynamic> json) => _$AdjustmentResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustmentResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdjustmentResultDtoPeriodStatusEnum {
@JsonValue(r'abierto')
abierto(r'abierto'),
@JsonValue(r'cerrado_pendiente')
cerradoPendiente(r'cerrado_pendiente'),
@JsonValue(r'pagado')
pagado(r'pagado'),
@JsonValue(r'vencido')
vencido(r'vencido');

const AdjustmentResultDtoPeriodStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_adjustment_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RegisterAdjustmentDto {
  /// Returns a new [RegisterAdjustmentDto] instance.
  RegisterAdjustmentDto({

    required  this.workerId,

    required  this.amountBs,

    required  this.reason,

     this.correctsEntryId,

     this.periodId,
  });

  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



      /// Con signo: positivo aumenta la deuda; negativo la reduce (ADR-0034)
  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



      /// Id del movimiento que corrige
  @JsonKey(
    
    name: r'correctsEntryId',
    required: false,
    includeIfNull: false,
  )


  final String? correctsEntryId;



      /// Periodo (por defecto, el del movimiento corregido o el actual)
  @JsonKey(
    
    name: r'periodId',
    required: false,
    includeIfNull: false,
  )


  final String? periodId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RegisterAdjustmentDto &&
      other.workerId == workerId &&
      other.amountBs == amountBs &&
      other.reason == reason &&
      other.correctsEntryId == correctsEntryId &&
      other.periodId == periodId;

    @override
    int get hashCode =>
        workerId.hashCode +
        amountBs.hashCode +
        reason.hashCode +
        correctsEntryId.hashCode +
        periodId.hashCode;

  factory RegisterAdjustmentDto.fromJson(Map<String, dynamic> json) => _$RegisterAdjustmentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAdjustmentDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


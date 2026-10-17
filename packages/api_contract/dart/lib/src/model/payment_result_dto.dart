//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/allocation_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentResultDto {
  /// Returns a new [PaymentResultDto] instance.
  PaymentResultDto({

    required  this.paymentId,

    required  this.workerId,

    required  this.amountBs,

    required  this.allocations,

    required  this.balanceBs,
  });

  @JsonKey(
    
    name: r'paymentId',
    required: true,
    includeIfNull: false,
  )


  final String paymentId;



  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



      /// Cómo se aplicó: más antiguo primero
  @JsonKey(
    
    name: r'allocations',
    required: true,
    includeIfNull: false,
  )


  final List<AllocationDto> allocations;



      /// Saldo después del pago (negativo = a favor)
  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentResultDto &&
      other.paymentId == paymentId &&
      other.workerId == workerId &&
      other.amountBs == amountBs &&
      other.allocations == allocations &&
      other.balanceBs == balanceBs;

    @override
    int get hashCode =>
        paymentId.hashCode +
        workerId.hashCode +
        amountBs.hashCode +
        allocations.hashCode +
        balanceBs.hashCode;

  factory PaymentResultDto.fromJson(Map<String, dynamic> json) => _$PaymentResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


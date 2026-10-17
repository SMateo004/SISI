//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_allocation_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentAllocationDto {
  /// Returns a new [PaymentAllocationDto] instance.
  PaymentAllocationDto({

    required  this.periodId,

    required  this.paymentReference,

    required  this.amountBs,
  });

  @JsonKey(
    
    name: r'periodId',
    required: true,
    includeIfNull: false,
  )


  final String periodId;



  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: false,
  )


  final String paymentReference;



      /// Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentAllocationDto &&
      other.periodId == periodId &&
      other.paymentReference == paymentReference &&
      other.amountBs == amountBs;

    @override
    int get hashCode =>
        periodId.hashCode +
        paymentReference.hashCode +
        amountBs.hashCode;

  factory PaymentAllocationDto.fromJson(Map<String, dynamic> json) => _$PaymentAllocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentAllocationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


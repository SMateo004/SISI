//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'allocation_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AllocationDto {
  /// Returns a new [AllocationDto] instance.
  AllocationDto({

    required  this.periodId,

    required  this.paymentReference,

    required  this.amountBs,

    required  this.status,
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



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final AllocationDtoStatusEnum status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AllocationDto &&
      other.periodId == periodId &&
      other.paymentReference == paymentReference &&
      other.amountBs == amountBs &&
      other.status == status;

    @override
    int get hashCode =>
        periodId.hashCode +
        paymentReference.hashCode +
        amountBs.hashCode +
        status.hashCode;

  factory AllocationDto.fromJson(Map<String, dynamic> json) => _$AllocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AllocationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AllocationDtoStatusEnum {
@JsonValue(r'abierto')
abierto(r'abierto'),
@JsonValue(r'cerrado_pendiente')
cerradoPendiente(r'cerrado_pendiente'),
@JsonValue(r'pagado')
pagado(r'pagado'),
@JsonValue(r'vencido')
vencido(r'vencido');

const AllocationDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



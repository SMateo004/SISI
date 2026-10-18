//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preview_allocation_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PreviewAllocationDto {
  /// Returns a new [PreviewAllocationDto] instance.
  PreviewAllocationDto({

    required  this.periodId,

    required  this.paymentReference,

    required  this.amountBs,

    required  this.periodBalanceAfterBs,

    required  this.statusAfter,
  });

      /// null = periodo actual que todavía no existe
  @JsonKey(
    
    name: r'periodId',
    required: true,
    includeIfNull: true,
  )


  final String? periodId;



  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: true,
  )


  final String? paymentReference;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'periodBalanceAfterBs',
    required: true,
    includeIfNull: false,
  )


  final String periodBalanceAfterBs;



  @JsonKey(
    
    name: r'statusAfter',
    required: true,
    includeIfNull: false,
  )


  final PreviewAllocationDtoStatusAfterEnum statusAfter;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PreviewAllocationDto &&
      other.periodId == periodId &&
      other.paymentReference == paymentReference &&
      other.amountBs == amountBs &&
      other.periodBalanceAfterBs == periodBalanceAfterBs &&
      other.statusAfter == statusAfter;

    @override
    int get hashCode =>
        (periodId == null ? 0 : periodId.hashCode) +
        (paymentReference == null ? 0 : paymentReference.hashCode) +
        amountBs.hashCode +
        periodBalanceAfterBs.hashCode +
        statusAfter.hashCode;

  factory PreviewAllocationDto.fromJson(Map<String, dynamic> json) => _$PreviewAllocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewAllocationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PreviewAllocationDtoStatusAfterEnum {
@JsonValue(r'abierto')
abierto(r'abierto'),
@JsonValue(r'cerrado_pendiente')
cerradoPendiente(r'cerrado_pendiente'),
@JsonValue(r'pagado')
pagado(r'pagado'),
@JsonValue(r'vencido')
vencido(r'vencido');

const PreviewAllocationDtoStatusAfterEnum(this.value);

final String value;

@override
String toString() => value;
}



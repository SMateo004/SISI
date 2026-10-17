//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_payment_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RegisterPaymentDto {
  /// Returns a new [RegisterPaymentDto] instance.
  RegisterPaymentDto({

    required  this.workerId,

    required  this.amountBs,

    required  this.method,

    required  this.paidAt,

     this.reference,

     this.receiptKey,

     this.submissionId,

     this.invoiceNumber,
  });

  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



      /// Monto pagado en Bs (texto, 2 decimales)
  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'method',
    required: true,
    includeIfNull: false,
  )


  final RegisterPaymentDtoMethodEnum method;



      /// Cuándo pagó (no futuro)
  @JsonKey(
    
    name: r'paidAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime paidAt;



  @JsonKey(
    
    name: r'reference',
    required: false,
    includeIfNull: false,
  )


  final String? reference;



      /// Clave del comprobante subido (receipts/{worker}/…)
  @JsonKey(
    
    name: r'receiptKey',
    required: false,
    includeIfNull: false,
  )


  final String? receiptKey;



      /// Comprobante enviado por el trabajador que se está registrando
  @JsonKey(
    
    name: r'submissionId',
    required: false,
    includeIfNull: false,
  )


  final String? submissionId;



      /// Número de factura (sin uso hasta la revisión tributaria)
  @JsonKey(
    
    name: r'invoiceNumber',
    required: false,
    includeIfNull: false,
  )


  final String? invoiceNumber;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RegisterPaymentDto &&
      other.workerId == workerId &&
      other.amountBs == amountBs &&
      other.method == method &&
      other.paidAt == paidAt &&
      other.reference == reference &&
      other.receiptKey == receiptKey &&
      other.submissionId == submissionId &&
      other.invoiceNumber == invoiceNumber;

    @override
    int get hashCode =>
        workerId.hashCode +
        amountBs.hashCode +
        method.hashCode +
        paidAt.hashCode +
        reference.hashCode +
        receiptKey.hashCode +
        submissionId.hashCode +
        invoiceNumber.hashCode;

  factory RegisterPaymentDto.fromJson(Map<String, dynamic> json) => _$RegisterPaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterPaymentDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RegisterPaymentDtoMethodEnum {
@JsonValue(r'qr_transferencia')
qrTransferencia(r'qr_transferencia'),
@JsonValue(r'efectivo')
efectivo(r'efectivo'),
@JsonValue(r'otro')
otro(r'otro');

const RegisterPaymentDtoMethodEnum(this.value);

final String value;

@override
String toString() => value;
}



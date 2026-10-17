//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/payment_allocation_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_payment_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MyPaymentDto {
  /// Returns a new [MyPaymentDto] instance.
  MyPaymentDto({

    required  this.id,

    required  this.amountBs,

    required  this.paidAt,

    required  this.method,

    required  this.status,

    required  this.reference,

    required  this.periods,

    required  this.receiptUrl,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



      /// Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'paidAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime paidAt;



  @JsonKey(
    
    name: r'method',
    required: true,
    includeIfNull: false,
  )


  final MyPaymentDtoMethodEnum method;



      /// Un pago del historial ya está registrado; los comprobantes en revisión están en /me/billing/submissions
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final MyPaymentDtoStatusEnum status;



  @JsonKey(
    
    name: r'reference',
    required: true,
    includeIfNull: true,
  )


  final String? reference;



      /// Periodos que cubrió
  @JsonKey(
    
    name: r'periods',
    required: true,
    includeIfNull: false,
  )


  final List<PaymentAllocationDto> periods;



      /// Enlace temporal al comprobante (R8.2)
  @JsonKey(
    
    name: r'receiptUrl',
    required: true,
    includeIfNull: true,
  )


  final String? receiptUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MyPaymentDto &&
      other.id == id &&
      other.amountBs == amountBs &&
      other.paidAt == paidAt &&
      other.method == method &&
      other.status == status &&
      other.reference == reference &&
      other.periods == periods &&
      other.receiptUrl == receiptUrl;

    @override
    int get hashCode =>
        id.hashCode +
        amountBs.hashCode +
        paidAt.hashCode +
        method.hashCode +
        status.hashCode +
        (reference == null ? 0 : reference.hashCode) +
        periods.hashCode +
        (receiptUrl == null ? 0 : receiptUrl.hashCode);

  factory MyPaymentDto.fromJson(Map<String, dynamic> json) => _$MyPaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MyPaymentDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum MyPaymentDtoMethodEnum {
@JsonValue(r'qr_transferencia')
qrTransferencia(r'qr_transferencia'),
@JsonValue(r'efectivo')
efectivo(r'efectivo'),
@JsonValue(r'otro')
otro(r'otro');

const MyPaymentDtoMethodEnum(this.value);

final String value;

@override
String toString() => value;
}


/// Un pago del historial ya está registrado; los comprobantes en revisión están en /me/billing/submissions
enum MyPaymentDtoStatusEnum {
@JsonValue(r'registrado')
registrado(r'registrado');

const MyPaymentDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



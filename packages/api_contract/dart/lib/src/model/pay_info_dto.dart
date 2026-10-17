//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pay_info_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PayInfoDto {
  /// Returns a new [PayInfoDto] instance.
  PayInfoDto({

    required  this.qrUrl,

    required  this.catchUpAmountBs,

    required  this.unlockAmountBs,

    required  this.totalBalanceBs,

    required  this.paymentReference,

    required  this.dueAt,

    required  this.instructions,

    required  this.gatewayEnabled,
  });

      /// URL temporal del QR de la empresa (null si no está cargado)
  @JsonKey(
    
    name: r'qrUrl',
    required: true,
    includeIfNull: true,
  )


  final String? qrUrl;



      /// \"Para ponerte al día\": periodos cerrados impagos. Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'catchUpAmountBs',
    required: true,
    includeIfNull: false,
  )


  final String catchUpAmountBs;



      /// \"Para volver a recibir solicitudes\": lo que deja el saldo en el tope (0 si no está sobre el tope). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'unlockAmountBs',
    required: true,
    includeIfNull: false,
  )


  final String unlockAmountBs;



      /// Saldo total, periodo abierto incluido (pago anticipado). Monto en Bs como texto con 2 decimales (nunca número de punto flotante).
  @JsonKey(
    
    name: r'totalBalanceBs',
    required: true,
    includeIfNull: false,
  )


  final String totalBalanceBs;



      /// Para la glosa: la del periodo más antiguo con deuda
  @JsonKey(
    
    name: r'paymentReference',
    required: true,
    includeIfNull: true,
  )


  final String? paymentReference;



  @JsonKey(
    
    name: r'dueAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? dueAt;



      /// Pasos en español
  @JsonKey(
    
    name: r'instructions',
    required: true,
    includeIfNull: false,
  )


  final List<String> instructions;



      /// Pago en línea (pasarela) disponible; hoy siempre false
  @JsonKey(
    
    name: r'gatewayEnabled',
    required: true,
    includeIfNull: false,
  )


  final bool gatewayEnabled;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PayInfoDto &&
      other.qrUrl == qrUrl &&
      other.catchUpAmountBs == catchUpAmountBs &&
      other.unlockAmountBs == unlockAmountBs &&
      other.totalBalanceBs == totalBalanceBs &&
      other.paymentReference == paymentReference &&
      other.dueAt == dueAt &&
      other.instructions == instructions &&
      other.gatewayEnabled == gatewayEnabled;

    @override
    int get hashCode =>
        (qrUrl == null ? 0 : qrUrl.hashCode) +
        catchUpAmountBs.hashCode +
        unlockAmountBs.hashCode +
        totalBalanceBs.hashCode +
        (paymentReference == null ? 0 : paymentReference.hashCode) +
        (dueAt == null ? 0 : dueAt.hashCode) +
        instructions.hashCode +
        gatewayEnabled.hashCode;

  factory PayInfoDto.fromJson(Map<String, dynamic> json) => _$PayInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PayInfoDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


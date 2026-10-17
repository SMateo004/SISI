//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_submission_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentSubmissionDto {
  /// Returns a new [PaymentSubmissionDto] instance.
  PaymentSubmissionDto({

    required  this.id,

    required  this.workerId,

    required  this.status,

    required  this.declaredAmountBs,

    required  this.note,

    required  this.reviewNote,

    required  this.paymentId,

    required  this.receiptUrl,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final PaymentSubmissionDtoStatusEnum status;



  @JsonKey(
    
    name: r'declaredAmountBs',
    required: true,
    includeIfNull: true,
  )


  final String? declaredAmountBs;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



      /// Motivo si se rechazó
  @JsonKey(
    
    name: r'reviewNote',
    required: true,
    includeIfNull: true,
  )


  final String? reviewNote;



  @JsonKey(
    
    name: r'paymentId',
    required: true,
    includeIfNull: true,
  )


  final String? paymentId;



      /// URL temporal del comprobante
  @JsonKey(
    
    name: r'receiptUrl',
    required: true,
    includeIfNull: false,
  )


  final String receiptUrl;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentSubmissionDto &&
      other.id == id &&
      other.workerId == workerId &&
      other.status == status &&
      other.declaredAmountBs == declaredAmountBs &&
      other.note == note &&
      other.reviewNote == reviewNote &&
      other.paymentId == paymentId &&
      other.receiptUrl == receiptUrl &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        workerId.hashCode +
        status.hashCode +
        (declaredAmountBs == null ? 0 : declaredAmountBs.hashCode) +
        (note == null ? 0 : note.hashCode) +
        (reviewNote == null ? 0 : reviewNote.hashCode) +
        (paymentId == null ? 0 : paymentId.hashCode) +
        receiptUrl.hashCode +
        createdAt.hashCode;

  factory PaymentSubmissionDto.fromJson(Map<String, dynamic> json) => _$PaymentSubmissionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSubmissionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PaymentSubmissionDtoStatusEnum {
@JsonValue(r'pendiente')
pendiente(r'pendiente'),
@JsonValue(r'registrado')
registrado(r'registrado'),
@JsonValue(r'rechazado')
rechazado(r'rechazado');

const PaymentSubmissionDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



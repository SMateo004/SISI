//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deletion_blocker_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeletionBlockerDto {
  /// Returns a new [DeletionBlockerDto] instance.
  DeletionBlockerDto({

    required  this.code,

    required  this.message,

     this.balanceBs,

     this.paymentReference,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final DeletionBlockerDtoCodeEnum code;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;



      /// Deuda a pagar (ACCOUNT_HAS_DEBT)
  @JsonKey(
    
    name: r'balanceBs',
    required: false,
    includeIfNull: false,
  )


  final String? balanceBs;



  @JsonKey(
    
    name: r'paymentReference',
    required: false,
    includeIfNull: false,
  )


  final String? paymentReference;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeletionBlockerDto &&
      other.code == code &&
      other.message == message &&
      other.balanceBs == balanceBs &&
      other.paymentReference == paymentReference;

    @override
    int get hashCode =>
        code.hashCode +
        message.hashCode +
        balanceBs.hashCode +
        (paymentReference == null ? 0 : paymentReference.hashCode);

  factory DeletionBlockerDto.fromJson(Map<String, dynamic> json) => _$DeletionBlockerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeletionBlockerDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DeletionBlockerDtoCodeEnum {
@JsonValue(r'ACCOUNT_IS_ADMIN')
ACCOUNT_IS_ADMIN(r'ACCOUNT_IS_ADMIN'),
@JsonValue(r'ACCOUNT_HAS_ACTIVE_JOB')
ACCOUNT_HAS_ACTIVE_JOB(r'ACCOUNT_HAS_ACTIVE_JOB'),
@JsonValue(r'ACCOUNT_HAS_PENDING_PAYMENT')
ACCOUNT_HAS_PENDING_PAYMENT(r'ACCOUNT_HAS_PENDING_PAYMENT'),
@JsonValue(r'ACCOUNT_HAS_DEBT')
ACCOUNT_HAS_DEBT(r'ACCOUNT_HAS_DEBT');

const DeletionBlockerDtoCodeEnum(this.value);

final String value;

@override
String toString() => value;
}



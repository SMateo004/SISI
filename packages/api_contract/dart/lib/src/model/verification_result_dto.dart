//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VerificationResultDto {
  /// Returns a new [VerificationResultDto] instance.
  VerificationResultDto({

    required  this.userId,

    required  this.status,

    required  this.rejectionReason,
  });

  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false,
  )


  final String userId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final VerificationResultDtoStatusEnum status;



  @JsonKey(
    
    name: r'rejectionReason',
    required: true,
    includeIfNull: true,
  )


  final String? rejectionReason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VerificationResultDto &&
      other.userId == userId &&
      other.status == status &&
      other.rejectionReason == rejectionReason;

    @override
    int get hashCode =>
        userId.hashCode +
        status.hashCode +
        (rejectionReason == null ? 0 : rejectionReason.hashCode);

  factory VerificationResultDto.fromJson(Map<String, dynamic> json) => _$VerificationResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum VerificationResultDtoStatusEnum {
@JsonValue(r'aprobado')
aprobado(r'aprobado'),
@JsonValue(r'rechazado')
rechazado(r'rechazado');

const VerificationResultDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



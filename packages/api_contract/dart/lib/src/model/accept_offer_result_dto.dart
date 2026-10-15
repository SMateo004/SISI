//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'accept_offer_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AcceptOfferResultDto {
  /// Returns a new [AcceptOfferResultDto] instance.
  AcceptOfferResultDto({

    required  this.jobId,

    required  this.requestId,
  });

  @JsonKey(
    
    name: r'jobId',
    required: true,
    includeIfNull: false,
  )


  final String jobId;



  @JsonKey(
    
    name: r'requestId',
    required: true,
    includeIfNull: false,
  )


  final String requestId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AcceptOfferResultDto &&
      other.jobId == jobId &&
      other.requestId == requestId;

    @override
    int get hashCode =>
        jobId.hashCode +
        requestId.hashCode;

  factory AcceptOfferResultDto.fromJson(Map<String, dynamic> json) => _$AcceptOfferResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptOfferResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


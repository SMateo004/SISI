//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_preview_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaymentPreviewDto {
  /// Returns a new [PaymentPreviewDto] instance.
  PaymentPreviewDto({

    required  this.workerId,

    required  this.amountBs,
  });

  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PaymentPreviewDto &&
      other.workerId == workerId &&
      other.amountBs == amountBs;

    @override
    int get hashCode =>
        workerId.hashCode +
        amountBs.hashCode;

  factory PaymentPreviewDto.fromJson(Map<String, dynamic> json) => _$PaymentPreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentPreviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


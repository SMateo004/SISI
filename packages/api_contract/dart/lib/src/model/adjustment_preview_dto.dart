//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'adjustment_preview_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdjustmentPreviewDto {
  /// Returns a new [AdjustmentPreviewDto] instance.
  AdjustmentPreviewDto({

    required  this.workerId,

    required  this.amountBs,

     this.correctsEntryId,

     this.periodId,
  });

  @JsonKey(
    
    name: r'workerId',
    required: true,
    includeIfNull: false,
  )


  final String workerId;



      /// Con signo: + aumenta la deuda
  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'correctsEntryId',
    required: false,
    includeIfNull: false,
  )


  final String? correctsEntryId;



  @JsonKey(
    
    name: r'periodId',
    required: false,
    includeIfNull: false,
  )


  final String? periodId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdjustmentPreviewDto &&
      other.workerId == workerId &&
      other.amountBs == amountBs &&
      other.correctsEntryId == correctsEntryId &&
      other.periodId == periodId;

    @override
    int get hashCode =>
        workerId.hashCode +
        amountBs.hashCode +
        correctsEntryId.hashCode +
        periodId.hashCode;

  factory AdjustmentPreviewDto.fromJson(Map<String, dynamic> json) => _$AdjustmentPreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustmentPreviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


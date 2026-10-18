//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/preview_allocation_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_preview_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BalancePreviewDto {
  /// Returns a new [BalancePreviewDto] instance.
  BalancePreviewDto({

    required  this.balanceBeforeBs,

    required  this.balanceAfterBs,

    required  this.allocations,

    required  this.blockedNow,

    required  this.unblocks,
  });

  @JsonKey(
    
    name: r'balanceBeforeBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBeforeBs;



  @JsonKey(
    
    name: r'balanceAfterBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceAfterBs;



  @JsonKey(
    
    name: r'allocations',
    required: true,
    includeIfNull: false,
  )


  final List<PreviewAllocationDto> allocations;



      /// Hoy está bloqueado por deuda
  @JsonKey(
    
    name: r'blockedNow',
    required: true,
    includeIfNull: false,
  )


  final bool blockedNow;



      /// Después de esto no quedaría ningún periodo vencido
  @JsonKey(
    
    name: r'unblocks',
    required: true,
    includeIfNull: false,
  )


  final bool unblocks;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BalancePreviewDto &&
      other.balanceBeforeBs == balanceBeforeBs &&
      other.balanceAfterBs == balanceAfterBs &&
      other.allocations == allocations &&
      other.blockedNow == blockedNow &&
      other.unblocks == unblocks;

    @override
    int get hashCode =>
        balanceBeforeBs.hashCode +
        balanceAfterBs.hashCode +
        allocations.hashCode +
        blockedNow.hashCode +
        unblocks.hashCode;

  factory BalancePreviewDto.fromJson(Map<String, dynamic> json) => _$BalancePreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BalancePreviewDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/overdue_row_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'overdue_list_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OverdueListDto {
  /// Returns a new [OverdueListDto] instance.
  OverdueListDto({

    required  this.items,

    required  this.totalBs,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<OverdueRowDto> items;



      /// Suma de los saldos vencidos
  @JsonKey(
    
    name: r'totalBs',
    required: true,
    includeIfNull: false,
  )


  final String totalBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OverdueListDto &&
      other.items == items &&
      other.totalBs == totalBs;

    @override
    int get hashCode =>
        items.hashCode +
        totalBs.hashCode;

  factory OverdueListDto.fromJson(Map<String, dynamic> json) => _$OverdueListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OverdueListDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


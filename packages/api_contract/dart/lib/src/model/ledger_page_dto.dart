//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/ledger_row_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ledger_page_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LedgerPageDto {
  /// Returns a new [LedgerPageDto] instance.
  LedgerPageDto({

    required  this.balanceBs,

    required  this.items,

    required  this.nextCursor,
  });

  @JsonKey(
    
    name: r'balanceBs',
    required: true,
    includeIfNull: false,
  )


  final String balanceBs;



      /// Del más nuevo al más viejo
  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<LedgerRowDto> items;



  @JsonKey(
    
    name: r'nextCursor',
    required: true,
    includeIfNull: true,
  )


  final String? nextCursor;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LedgerPageDto &&
      other.balanceBs == balanceBs &&
      other.items == items &&
      other.nextCursor == nextCursor;

    @override
    int get hashCode =>
        balanceBs.hashCode +
        items.hashCode +
        (nextCursor == null ? 0 : nextCursor.hashCode);

  factory LedgerPageDto.fromJson(Map<String, dynamic> json) => _$LedgerPageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerPageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


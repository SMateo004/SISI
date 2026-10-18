//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moderation_match_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModerationMatchDto {
  /// Returns a new [ModerationMatchDto] instance.
  ModerationMatchDto({

    required  this.termId,

    required  this.term,

    required  this.kind,

    required  this.category,
  });

  @JsonKey(
    
    name: r'termId',
    required: true,
    includeIfNull: false,
  )


  final String termId;



  @JsonKey(
    
    name: r'term',
    required: true,
    includeIfNull: false,
  )


  final String term;



  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final ModerationMatchDtoKindEnum kind;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final ModerationMatchDtoCategoryEnum category;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ModerationMatchDto &&
      other.termId == termId &&
      other.term == term &&
      other.kind == kind &&
      other.category == category;

    @override
    int get hashCode =>
        termId.hashCode +
        term.hashCode +
        kind.hashCode +
        category.hashCode;

  factory ModerationMatchDto.fromJson(Map<String, dynamic> json) => _$ModerationMatchDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModerationMatchDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ModerationMatchDtoKindEnum {
@JsonValue(r'word')
word(r'word'),
@JsonValue(r'regex')
regex(r'regex');

const ModerationMatchDtoKindEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ModerationMatchDtoCategoryEnum {
@JsonValue(r'sexual')
sexual(r'sexual'),
@JsonValue(r'drogas')
drogas(r'drogas'),
@JsonValue(r'armas')
armas(r'armas'),
@JsonValue(r'ilegal')
ilegal(r'ilegal'),
@JsonValue(r'inmoral')
inmoral(r'inmoral'),
@JsonValue(r'venta_productos')
ventaProductos(r'venta_productos');

const ModerationMatchDtoCategoryEnum(this.value);

final String value;

@override
String toString() => value;
}



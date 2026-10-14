//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moderation_term_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModerationTermDto {
  /// Returns a new [ModerationTermDto] instance.
  ModerationTermDto({

    required  this.id,

    required  this.term,

    required  this.kind,

    required  this.category,

    required  this.active,

    required  this.note,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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


  final ModerationTermDtoKindEnum kind;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final ModerationTermDtoCategoryEnum category;



  @JsonKey(
    
    name: r'active',
    required: true,
    includeIfNull: false,
  )


  final bool active;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ModerationTermDto &&
      other.id == id &&
      other.term == term &&
      other.kind == kind &&
      other.category == category &&
      other.active == active &&
      other.note == note;

    @override
    int get hashCode =>
        id.hashCode +
        term.hashCode +
        kind.hashCode +
        category.hashCode +
        active.hashCode +
        (note == null ? 0 : note.hashCode);

  factory ModerationTermDto.fromJson(Map<String, dynamic> json) => _$ModerationTermDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModerationTermDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ModerationTermDtoKindEnum {
@JsonValue(r'word')
word(r'word'),
@JsonValue(r'regex')
regex(r'regex');

const ModerationTermDtoKindEnum(this.value);

final String value;

@override
String toString() => value;
}


enum ModerationTermDtoCategoryEnum {
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

const ModerationTermDtoCategoryEnum(this.value);

final String value;

@override
String toString() => value;
}



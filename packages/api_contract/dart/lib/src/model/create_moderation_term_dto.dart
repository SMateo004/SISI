//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_moderation_term_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateModerationTermDto {
  /// Returns a new [CreateModerationTermDto] instance.
  CreateModerationTermDto({

    required  this.term,

    required  this.kind,

    required  this.category,

     this.note,

     this.reason,
  });

      /// Palabra/frase (con * de prefijo) o regex
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


  final CreateModerationTermDtoKindEnum kind;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final CreateModerationTermDtoCategoryEnum category;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



      /// Motivo (queda en la auditoría)
  @JsonKey(
    
    name: r'reason',
    required: false,
    includeIfNull: false,
  )


  final String? reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateModerationTermDto &&
      other.term == term &&
      other.kind == kind &&
      other.category == category &&
      other.note == note &&
      other.reason == reason;

    @override
    int get hashCode =>
        term.hashCode +
        kind.hashCode +
        category.hashCode +
        note.hashCode +
        reason.hashCode;

  factory CreateModerationTermDto.fromJson(Map<String, dynamic> json) => _$CreateModerationTermDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateModerationTermDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CreateModerationTermDtoKindEnum {
@JsonValue(r'word')
word(r'word'),
@JsonValue(r'regex')
regex(r'regex');

const CreateModerationTermDtoKindEnum(this.value);

final String value;

@override
String toString() => value;
}


enum CreateModerationTermDtoCategoryEnum {
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

const CreateModerationTermDtoCategoryEnum(this.value);

final String value;

@override
String toString() => value;
}



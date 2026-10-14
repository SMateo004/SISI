//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_moderation_term_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateModerationTermDto {
  /// Returns a new [UpdateModerationTermDto] instance.
  UpdateModerationTermDto({

     this.category,

     this.active,

     this.note,
  });

  @JsonKey(
    
    name: r'category',
    required: false,
    includeIfNull: false,
  )


  final UpdateModerationTermDtoCategoryEnum? category;



  @JsonKey(
    
    name: r'active',
    required: false,
    includeIfNull: false,
  )


  final bool? active;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UpdateModerationTermDto &&
      other.category == category &&
      other.active == active &&
      other.note == note;

    @override
    int get hashCode =>
        category.hashCode +
        active.hashCode +
        note.hashCode;

  factory UpdateModerationTermDto.fromJson(Map<String, dynamic> json) => _$UpdateModerationTermDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateModerationTermDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UpdateModerationTermDtoCategoryEnum {
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

const UpdateModerationTermDtoCategoryEnum(this.value);

final String value;

@override
String toString() => value;
}



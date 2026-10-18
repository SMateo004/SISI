//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SettingDto {
  /// Returns a new [SettingDto] instance.
  SettingDto({

    required  this.key,

    required  this.group,

    required  this.label,

    required  this.help,

    required  this.kind,

    required  this.unit,

    required  this.min,

    required  this.max,

    required  this.value,

    required  this.defaultValue,

    required  this.overridden,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;



  @JsonKey(
    
    name: r'group',
    required: true,
    includeIfNull: false,
  )


  final SettingDtoGroupEnum group;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'help',
    required: true,
    includeIfNull: false,
  )


  final String help;



  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final SettingDtoKindEnum kind;



  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: false,
  )


  final SettingDtoUnitEnum unit;



  @JsonKey(
    
    name: r'min',
    required: true,
    includeIfNull: true,
  )


  final num? min;



  @JsonKey(
    
    name: r'max',
    required: true,
    includeIfNull: true,
  )


  final num? max;



      /// Valor vigente, como texto
  @JsonKey(
    
    name: r'value',
    required: true,
    includeIfNull: false,
  )


  final String value;



      /// Valor por defecto (variable de entorno)
  @JsonKey(
    
    name: r'defaultValue',
    required: true,
    includeIfNull: false,
  )


  final String defaultValue;



      /// Cambiado desde el panel
  @JsonKey(
    
    name: r'overridden',
    required: true,
    includeIfNull: false,
  )


  final bool overridden;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SettingDto &&
      other.key == key &&
      other.group == group &&
      other.label == label &&
      other.help == help &&
      other.kind == kind &&
      other.unit == unit &&
      other.min == min &&
      other.max == max &&
      other.value == value &&
      other.defaultValue == defaultValue &&
      other.overridden == overridden &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        key.hashCode +
        group.hashCode +
        label.hashCode +
        help.hashCode +
        kind.hashCode +
        unit.hashCode +
        (min == null ? 0 : min.hashCode) +
        (max == null ? 0 : max.hashCode) +
        value.hashCode +
        defaultValue.hashCode +
        overridden.hashCode +
        (updatedAt == null ? 0 : updatedAt.hashCode);

  factory SettingDto.fromJson(Map<String, dynamic> json) => _$SettingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SettingDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SettingDtoGroupEnum {
@JsonValue(r'matching')
matching(r'matching'),
@JsonValue(r'ofertas')
ofertas(r'ofertas'),
@JsonValue(r'trabajos')
trabajos(r'trabajos'),
@JsonValue(r'cobros')
cobros(r'cobros');

const SettingDtoGroupEnum(this.value);

final String value;

@override
String toString() => value;
}


enum SettingDtoKindEnum {
@JsonValue(r'int')
int_(r'int'),
@JsonValue(r'decimal')
decimal(r'decimal'),
@JsonValue(r'rings')
rings(r'rings');

const SettingDtoKindEnum(this.value);

final String value;

@override
String toString() => value;
}


enum SettingDtoUnitEnum {
@JsonValue(r'ms')
ms(r'ms'),
@JsonValue(r'días')
das(r'días'),
@JsonValue(r'hora')
hora(r'hora'),
@JsonValue(r'Bs')
bs(r'Bs'),
@JsonValue(r'ofertas')
ofertas(r'ofertas'),
@JsonValue(r'veces')
veces(r'veces'),
@JsonValue(r'anillos')
anillos(r'anillos');

const SettingDtoUnitEnum(this.value);

final String value;

@override
String toString() => value;
}



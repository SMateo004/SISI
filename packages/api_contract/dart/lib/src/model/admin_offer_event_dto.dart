//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_offer_event_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminOfferEventDto {
  /// Returns a new [AdminOfferEventDto] instance.
  AdminOfferEventDto({

    required  this.kind,

    required  this.revision,

    required  this.type,

    required  this.amountBs,

    required  this.etaMin,

    required  this.at,
  });

  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final AdminOfferEventDtoKindEnum kind;



  @JsonKey(
    
    name: r'revision',
    required: true,
    includeIfNull: false,
  )


  final num revision;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final AdminOfferEventDtoTypeEnum type;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



  @JsonKey(
    
    name: r'etaMin',
    required: true,
    includeIfNull: false,
  )


  final num etaMin;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminOfferEventDto &&
      other.kind == kind &&
      other.revision == revision &&
      other.type == type &&
      other.amountBs == amountBs &&
      other.etaMin == etaMin &&
      other.at == at;

    @override
    int get hashCode =>
        kind.hashCode +
        revision.hashCode +
        type.hashCode +
        amountBs.hashCode +
        etaMin.hashCode +
        at.hashCode;

  factory AdminOfferEventDto.fromJson(Map<String, dynamic> json) => _$AdminOfferEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminOfferEventDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminOfferEventDtoKindEnum {
@JsonValue(r'creada')
creada(r'creada'),
@JsonValue(r'reemplazada')
reemplazada(r'reemplazada'),
@JsonValue(r'retirada')
retirada(r'retirada'),
@JsonValue(r'aceptada')
aceptada(r'aceptada'),
@JsonValue(r'cerrada')
cerrada(r'cerrada');

const AdminOfferEventDtoKindEnum(this.value);

final String value;

@override
String toString() => value;
}


enum AdminOfferEventDtoTypeEnum {
@JsonValue(r'accept')
accept(r'accept'),
@JsonValue(r'counter')
counter(r'counter');

const AdminOfferEventDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



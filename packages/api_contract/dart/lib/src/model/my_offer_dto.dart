//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_offer_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MyOfferDto {
  /// Returns a new [MyOfferDto] instance.
  MyOfferDto({

    required  this.id,

    required  this.type,

    required  this.amountBs,

    required  this.etaMin,

    required  this.status,

    required  this.revision,

    required  this.updatedAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final MyOfferDtoTypeEnum type;



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
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final MyOfferDtoStatusEnum status;



  @JsonKey(
    
    name: r'revision',
    required: true,
    includeIfNull: false,
  )


  final num revision;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MyOfferDto &&
      other.id == id &&
      other.type == type &&
      other.amountBs == amountBs &&
      other.etaMin == etaMin &&
      other.status == status &&
      other.revision == revision &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        amountBs.hashCode +
        etaMin.hashCode +
        status.hashCode +
        revision.hashCode +
        updatedAt.hashCode;

  factory MyOfferDto.fromJson(Map<String, dynamic> json) => _$MyOfferDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MyOfferDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum MyOfferDtoTypeEnum {
@JsonValue(r'accept')
accept(r'accept'),
@JsonValue(r'counter')
counter(r'counter');

const MyOfferDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum MyOfferDtoStatusEnum {
@JsonValue(r'activa')
activa(r'activa'),
@JsonValue(r'aceptada')
aceptada(r'aceptada'),
@JsonValue(r'cerrada')
cerrada(r'cerrada');

const MyOfferDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



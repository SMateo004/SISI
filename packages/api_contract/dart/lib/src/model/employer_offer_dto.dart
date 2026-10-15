//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/offer_worker_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employer_offer_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EmployerOfferDto {
  /// Returns a new [EmployerOfferDto] instance.
  EmployerOfferDto({

    required  this.id,

    required  this.type,

    required  this.amountBs,

    required  this.etaMin,

    required  this.distanceM,

    required  this.revision,

    required  this.worker,

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


  final EmployerOfferDtoTypeEnum type;



  @JsonKey(
    
    name: r'amountBs',
    required: true,
    includeIfNull: false,
  )


  final String amountBs;



      /// Minutos estimados de llegada
  @JsonKey(
    
    name: r'etaMin',
    required: true,
    includeIfNull: false,
  )


  final num etaMin;



  @JsonKey(
    
    name: r'distanceM',
    required: true,
    includeIfNull: false,
  )


  final num distanceM;



      /// Sube cada vez que el trabajador reemplaza su oferta
  @JsonKey(
    
    name: r'revision',
    required: true,
    includeIfNull: false,
  )


  final num revision;



  @JsonKey(
    
    name: r'worker',
    required: true,
    includeIfNull: false,
  )


  final OfferWorkerDto worker;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime updatedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EmployerOfferDto &&
      other.id == id &&
      other.type == type &&
      other.amountBs == amountBs &&
      other.etaMin == etaMin &&
      other.distanceM == distanceM &&
      other.revision == revision &&
      other.worker == worker &&
      other.updatedAt == updatedAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        amountBs.hashCode +
        etaMin.hashCode +
        distanceM.hashCode +
        revision.hashCode +
        worker.hashCode +
        updatedAt.hashCode;

  factory EmployerOfferDto.fromJson(Map<String, dynamic> json) => _$EmployerOfferDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerOfferDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum EmployerOfferDtoTypeEnum {
@JsonValue(r'accept')
accept(r'accept'),
@JsonValue(r'counter')
counter(r'counter');

const EmployerOfferDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



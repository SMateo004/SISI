//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/my_offer_dto.dart';
import 'package:sisi_api/src/model/employer_rating_dto.dart';
import 'package:sisi_api/src/model/incoming_photo_dto.dart';
import 'package:sisi_api/src/model/price_range_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class IncomingRequestDto {
  /// Returns a new [IncomingRequestDto] instance.
  IncomingRequestDto({

    required  this.requestId,

    required  this.outcome,

    required  this.category,

    required  this.description,

    required  this.distanceM,

    required  this.proposedPriceBs,

    required  this.referenceRange,

    required  this.maxCounterBs,

    required  this.photos,

    required  this.ring,

    required  this.respondBy,

    required  this.myOffer,

    required  this.jobId,

    required  this.notifiedAt,

    required  this.employer,
  });

  @JsonKey(
    
    name: r'requestId',
    required: true,
    includeIfNull: false,
  )


  final String requestId;



      /// abierta = puede ofertar; elegido = lo eligieron (ver contacto con jobId)
  @JsonKey(
    
    name: r'outcome',
    required: true,
    includeIfNull: false,
  )


  final IncomingRequestDtoOutcomeEnum outcome;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final Object category;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;



  @JsonKey(
    
    name: r'distanceM',
    required: true,
    includeIfNull: false,
  )


  final num distanceM;



  @JsonKey(
    
    name: r'proposedPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String proposedPriceBs;



  @JsonKey(
    
    name: r'referenceRange',
    required: true,
    includeIfNull: false,
  )


  final PriceRangeDto referenceRange;



      /// Tope de la contraoferta
  @JsonKey(
    
    name: r'maxCounterBs',
    required: true,
    includeIfNull: false,
  )


  final String maxCounterBs;



  @JsonKey(
    
    name: r'photos',
    required: true,
    includeIfNull: false,
  )


  final List<IncomingPhotoDto> photos;



      /// Anillo en el que le llegó
  @JsonKey(
    
    name: r'ring',
    required: true,
    includeIfNull: false,
  )


  final num ring;



      /// Fin del plazo de su anillo (cuenta regresiva en la app)
  @JsonKey(
    
    name: r'respondBy',
    required: true,
    includeIfNull: false,
  )


  final DateTime respondBy;



  @JsonKey(
    
    name: r'myOffer',
    required: true,
    includeIfNull: true,
  )


  final MyOfferDto? myOffer;



  @JsonKey(
    
    name: r'jobId',
    required: true,
    includeIfNull: true,
  )


  final String? jobId;



  @JsonKey(
    
    name: r'notifiedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime notifiedAt;



      /// Calificación del empleador (la que le dieron los trabajadores)
  @JsonKey(
    
    name: r'employer',
    required: true,
    includeIfNull: false,
  )


  final EmployerRatingDto employer;





    @override
    bool operator ==(Object other) => identical(this, other) || other is IncomingRequestDto &&
      other.requestId == requestId &&
      other.outcome == outcome &&
      other.category == category &&
      other.description == description &&
      other.distanceM == distanceM &&
      other.proposedPriceBs == proposedPriceBs &&
      other.referenceRange == referenceRange &&
      other.maxCounterBs == maxCounterBs &&
      other.photos == photos &&
      other.ring == ring &&
      other.respondBy == respondBy &&
      other.myOffer == myOffer &&
      other.jobId == jobId &&
      other.notifiedAt == notifiedAt &&
      other.employer == employer;

    @override
    int get hashCode =>
        requestId.hashCode +
        outcome.hashCode +
        category.hashCode +
        description.hashCode +
        distanceM.hashCode +
        proposedPriceBs.hashCode +
        referenceRange.hashCode +
        maxCounterBs.hashCode +
        photos.hashCode +
        ring.hashCode +
        respondBy.hashCode +
        (myOffer == null ? 0 : myOffer.hashCode) +
        (jobId == null ? 0 : jobId.hashCode) +
        notifiedAt.hashCode +
        employer.hashCode;

  factory IncomingRequestDto.fromJson(Map<String, dynamic> json) => _$IncomingRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IncomingRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// abierta = puede ofertar; elegido = lo eligieron (ver contacto con jobId)
enum IncomingRequestDtoOutcomeEnum {
@JsonValue(r'abierta')
abierta(r'abierta'),
@JsonValue(r'elegido')
elegido(r'elegido'),
@JsonValue(r'elegida_otra')
elegidaOtra(r'elegida_otra'),
@JsonValue(r'cancelada')
cancelada(r'cancelada'),
@JsonValue(r'expirada')
expirada(r'expirada');

const IncomingRequestDtoOutcomeEnum(this.value);

final String value;

@override
String toString() => value;
}



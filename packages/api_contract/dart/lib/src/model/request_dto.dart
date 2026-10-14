//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/request_photo_dto.dart';
import 'package:sisi_api/src/model/request_category_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestDto {
  /// Returns a new [RequestDto] instance.
  RequestDto({

    required  this.id,

    required  this.status,

     this.statusMessage,

    required  this.category,

    required  this.cityId,

    required  this.description,

    required  this.latitude,

    required  this.longitude,

    required  this.address,

    required  this.proposedPriceBs,

    required  this.photos,

    required  this.createdAt,

     this.publishedAt,

     this.cancelledAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final RequestDtoStatusEnum status;



      /// Mensaje para el empleador según el estado (neutral si está retenida)
  @JsonKey(
    
    name: r'statusMessage',
    required: false,
    includeIfNull: false,
  )


  final String? statusMessage;



  @JsonKey(
    
    name: r'category',
    required: true,
    includeIfNull: false,
  )


  final RequestCategoryDto category;



  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: false,
  )


  final String cityId;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;



  @JsonKey(
    
    name: r'latitude',
    required: true,
    includeIfNull: false,
  )


  final num latitude;



  @JsonKey(
    
    name: r'longitude',
    required: true,
    includeIfNull: false,
  )


  final num longitude;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



  @JsonKey(
    
    name: r'proposedPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String proposedPriceBs;



  @JsonKey(
    
    name: r'photos',
    required: true,
    includeIfNull: false,
  )


  final List<RequestPhotoDto> photos;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final String createdAt;



  @JsonKey(
    
    name: r'publishedAt',
    required: false,
    includeIfNull: false,
  )


  final String? publishedAt;



  @JsonKey(
    
    name: r'cancelledAt',
    required: false,
    includeIfNull: false,
  )


  final String? cancelledAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RequestDto &&
      other.id == id &&
      other.status == status &&
      other.statusMessage == statusMessage &&
      other.category == category &&
      other.cityId == cityId &&
      other.description == description &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address &&
      other.proposedPriceBs == proposedPriceBs &&
      other.photos == photos &&
      other.createdAt == createdAt &&
      other.publishedAt == publishedAt &&
      other.cancelledAt == cancelledAt;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        (statusMessage == null ? 0 : statusMessage.hashCode) +
        category.hashCode +
        cityId.hashCode +
        description.hashCode +
        latitude.hashCode +
        longitude.hashCode +
        address.hashCode +
        proposedPriceBs.hashCode +
        photos.hashCode +
        createdAt.hashCode +
        (publishedAt == null ? 0 : publishedAt.hashCode) +
        (cancelledAt == null ? 0 : cancelledAt.hashCode);

  factory RequestDto.fromJson(Map<String, dynamic> json) => _$RequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RequestDtoStatusEnum {
@JsonValue(r'borrador')
borrador(r'borrador'),
@JsonValue(r'retenida')
retenida(r'retenida'),
@JsonValue(r'buscando')
buscando(r'buscando'),
@JsonValue(r'con_ofertas')
conOfertas(r'con_ofertas'),
@JsonValue(r'asignada')
asignada(r'asignada'),
@JsonValue(r'cancelada')
cancelada(r'cancelada'),
@JsonValue(r'expirada')
expirada(r'expirada');

const RequestDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



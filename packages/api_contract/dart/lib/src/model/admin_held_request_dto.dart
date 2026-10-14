//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/request_photo_dto.dart';
import 'package:sisi_api/src/model/request_category_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_held_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminHeldRequestDto {
  /// Returns a new [AdminHeldRequestDto] instance.
  AdminHeldRequestDto({

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

    required  this.matches,

    required  this.employerId,
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


  final AdminHeldRequestDtoStatusEnum status;



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



      /// Términos que coincidieron (solo para el admin)
  @JsonKey(
    
    name: r'matches',
    required: true,
    includeIfNull: false,
  )


  final Object matches;



  @JsonKey(
    
    name: r'employerId',
    required: true,
    includeIfNull: false,
  )


  final String employerId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminHeldRequestDto &&
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
      other.cancelledAt == cancelledAt &&
      other.matches == matches &&
      other.employerId == employerId;

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
        (cancelledAt == null ? 0 : cancelledAt.hashCode) +
        matches.hashCode +
        employerId.hashCode;

  factory AdminHeldRequestDto.fromJson(Map<String, dynamic> json) => _$AdminHeldRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminHeldRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminHeldRequestDtoStatusEnum {
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

const AdminHeldRequestDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



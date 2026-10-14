//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateRequestDto {
  /// Returns a new [CreateRequestDto] instance.
  CreateRequestDto({

    required  this.categoryId,

    required  this.description,

    required  this.latitude,

    required  this.longitude,

    required  this.address,

    required  this.proposedPriceBs,
  });

  @JsonKey(
    
    name: r'categoryId',
    required: true,
    includeIfNull: false,
  )


  final String categoryId;



      /// Entre 20 y 1000 caracteres (configurable)
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



      /// Dirección en texto
  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



      /// Precio propuesto en Bs (incluye el traslado, R3.5)
  @JsonKey(
    
    name: r'proposedPriceBs',
    required: true,
    includeIfNull: false,
  )


  final String proposedPriceBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateRequestDto &&
      other.categoryId == categoryId &&
      other.description == description &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address &&
      other.proposedPriceBs == proposedPriceBs;

    @override
    int get hashCode =>
        categoryId.hashCode +
        description.hashCode +
        latitude.hashCode +
        longitude.hashCode +
        address.hashCode +
        proposedPriceBs.hashCode;

  factory CreateRequestDto.fromJson(Map<String, dynamic> json) => _$CreateRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


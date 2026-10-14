//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CategoryDto {
  /// Returns a new [CategoryDto] instance.
  CategoryDto({

    required  this.id,

    required  this.name,

    required  this.description,

    required  this.priceMinBs,

    required  this.priceMaxBs,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: true,
  )


  final String? description;



      /// Precio mínimo de referencia en Bs
  @JsonKey(
    
    name: r'priceMinBs',
    required: true,
    includeIfNull: false,
  )


  final String priceMinBs;



      /// Precio máximo de referencia en Bs
  @JsonKey(
    
    name: r'priceMaxBs',
    required: true,
    includeIfNull: false,
  )


  final String priceMaxBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CategoryDto &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.priceMinBs == priceMinBs &&
      other.priceMaxBs == priceMaxBs;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        (description == null ? 0 : description.hashCode) +
        priceMinBs.hashCode +
        priceMaxBs.hashCode;

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


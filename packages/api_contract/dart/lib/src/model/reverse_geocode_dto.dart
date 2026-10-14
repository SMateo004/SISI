//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reverse_geocode_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReverseGeocodeDto {
  /// Returns a new [ReverseGeocodeDto] instance.
  ReverseGeocodeDto({

     this.address,
  });

      /// Sugerencia editable; null si no hay resultado
  @JsonKey(
    
    name: r'address',
    required: false,
    includeIfNull: false,
  )


  final String? address;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReverseGeocodeDto &&
      other.address == address;

    @override
    int get hashCode =>
        (address == null ? 0 : address.hashCode);

  factory ReverseGeocodeDto.fromJson(Map<String, dynamic> json) => _$ReverseGeocodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseGeocodeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


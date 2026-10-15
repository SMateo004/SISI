//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'availability_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AvailabilityDto {
  /// Returns a new [AvailabilityDto] instance.
  AvailabilityDto({

    required  this.available,

    required  this.availableSince,

    required  this.locatedAt,

    required  this.sendEverySec,

    required  this.staleAfterSec,
  });

  @JsonKey(
    
    name: r'available',
    required: true,
    includeIfNull: false,
  )


  final bool available;



  @JsonKey(
    
    name: r'availableSince',
    required: true,
    includeIfNull: true,
  )


  final DateTime? availableSince;



      /// Última ubicación recibida por la API
  @JsonKey(
    
    name: r'locatedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? locatedAt;



      /// Cada cuántos segundos debe la app enviar la ubicación mientras está disponible (en primer plano)
  @JsonKey(
    
    name: r'sendEverySec',
    required: true,
    includeIfNull: false,
  )


  final num sendEverySec;



      /// Sin ubicación en este tiempo, deja de estar disponible
  @JsonKey(
    
    name: r'staleAfterSec',
    required: true,
    includeIfNull: false,
  )


  final num staleAfterSec;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AvailabilityDto &&
      other.available == available &&
      other.availableSince == availableSince &&
      other.locatedAt == locatedAt &&
      other.sendEverySec == sendEverySec &&
      other.staleAfterSec == staleAfterSec;

    @override
    int get hashCode =>
        available.hashCode +
        (availableSince == null ? 0 : availableSince.hashCode) +
        (locatedAt == null ? 0 : locatedAt.hashCode) +
        sendEverySec.hashCode +
        staleAfterSec.hashCode;

  factory AvailabilityDto.fromJson(Map<String, dynamic> json) => _$AvailabilityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


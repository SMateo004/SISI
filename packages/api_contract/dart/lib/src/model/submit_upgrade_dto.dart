//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'submit_upgrade_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubmitUpgradeDto {
  /// Returns a new [SubmitUpgradeDto] instance.
  SubmitUpgradeDto({

    required  this.birthDate,

    required  this.categoryIds,

    required  this.transport,

    required  this.maxRadiusKm,
  });

      /// Fecha de nacimiento (AAAA-MM-DD)
  @JsonKey(
    
    name: r'birthDate',
    required: true,
    includeIfNull: false,
  )


  final String birthDate;



  @JsonKey(
    
    name: r'categoryIds',
    required: true,
    includeIfNull: false,
  )


  final List<String> categoryIds;



  @JsonKey(
    
    name: r'transport',
    required: true,
    includeIfNull: false,
  )


  final SubmitUpgradeDtoTransportEnum transport;



          // minimum: 1
          // maximum: 10
  @JsonKey(
    
    name: r'maxRadiusKm',
    required: true,
    includeIfNull: false,
  )


  final num maxRadiusKm;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SubmitUpgradeDto &&
      other.birthDate == birthDate &&
      other.categoryIds == categoryIds &&
      other.transport == transport &&
      other.maxRadiusKm == maxRadiusKm;

    @override
    int get hashCode =>
        birthDate.hashCode +
        categoryIds.hashCode +
        transport.hashCode +
        maxRadiusKm.hashCode;

  factory SubmitUpgradeDto.fromJson(Map<String, dynamic> json) => _$SubmitUpgradeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitUpgradeDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum SubmitUpgradeDtoTransportEnum {
@JsonValue(r'a_pie')
aPie(r'a_pie'),
@JsonValue(r'bicicleta')
bicicleta(r'bicicleta'),
@JsonValue(r'moto')
moto(r'moto'),
@JsonValue(r'auto')
auto(r'auto'),
@JsonValue(r'transporte_publico')
transportePublico(r'transporte_publico');

const SubmitUpgradeDtoTransportEnum(this.value);

final String value;

@override
String toString() => value;
}



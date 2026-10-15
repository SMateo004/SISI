//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_offer_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateOfferDto {
  /// Returns a new [CreateOfferDto] instance.
  CreateOfferDto({

    required  this.type,

     this.amountBs,
  });

      /// accept = acepta el precio propuesto; counter = contraoferta (R5.2)
  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final CreateOfferDtoTypeEnum type;



      /// Obligatorio en una contraoferta
  @JsonKey(
    
    name: r'amountBs',
    required: false,
    includeIfNull: false,
  )


  final String? amountBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreateOfferDto &&
      other.type == type &&
      other.amountBs == amountBs;

    @override
    int get hashCode =>
        type.hashCode +
        amountBs.hashCode;

  factory CreateOfferDto.fromJson(Map<String, dynamic> json) => _$CreateOfferDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOfferDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// accept = acepta el precio propuesto; counter = contraoferta (R5.2)
enum CreateOfferDtoTypeEnum {
@JsonValue(r'accept')
accept(r'accept'),
@JsonValue(r'counter')
counter(r'counter');

const CreateOfferDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_pilot_phones_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddPilotPhonesDto {
  /// Returns a new [AddPilotPhonesDto] instance.
  AddPilotPhonesDto({

    required  this.phones,

     this.note,

     this.cityId,

    required  this.reason,
  });

      /// Números a habilitar (con o sin +591)
  @JsonKey(
    
    name: r'phones',
    required: true,
    includeIfNull: false,
  )


  final List<String> phones;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



      /// Ciudad (por defecto, la del piloto)
  @JsonKey(
    
    name: r'cityId',
    required: false,
    includeIfNull: false,
  )


  final String? cityId;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddPilotPhonesDto &&
      other.phones == phones &&
      other.note == note &&
      other.cityId == cityId &&
      other.reason == reason;

    @override
    int get hashCode =>
        phones.hashCode +
        note.hashCode +
        cityId.hashCode +
        reason.hashCode;

  factory AddPilotPhonesDto.fromJson(Map<String, dynamic> json) => _$AddPilotPhonesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddPilotPhonesDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


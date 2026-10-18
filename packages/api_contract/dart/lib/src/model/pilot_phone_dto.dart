//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pilot_phone_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PilotPhoneDto {
  /// Returns a new [PilotPhoneDto] instance.
  PilotPhoneDto({

    required  this.id,

    required  this.phone,

    required  this.note,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PilotPhoneDto &&
      other.id == id &&
      other.phone == phone &&
      other.note == note &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        (note == null ? 0 : note.hashCode) +
        createdAt.hashCode;

  factory PilotPhoneDto.fromJson(Map<String, dynamic> json) => _$PilotPhoneDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PilotPhoneDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


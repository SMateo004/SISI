//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_job_party_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminJobPartyDto {
  /// Returns a new [AdminJobPartyDto] instance.
  AdminJobPartyDto({

    required  this.id,

    required  this.name,

    required  this.phone,
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
    includeIfNull: true,
  )


  final String? name;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminJobPartyDto &&
      other.id == id &&
      other.name == name &&
      other.phone == phone;

    @override
    int get hashCode =>
        id.hashCode +
        (name == null ? 0 : name.hashCode) +
        phone.hashCode;

  factory AdminJobPartyDto.fromJson(Map<String, dynamic> json) => _$AdminJobPartyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminJobPartyDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


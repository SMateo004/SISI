//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_version_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LegalVersionDto {
  /// Returns a new [LegalVersionDto] instance.
  LegalVersionDto({

    required  this.type,

    required  this.version,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final LegalVersionDtoTypeEnum type;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final num version;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LegalVersionDto &&
      other.type == type &&
      other.version == version;

    @override
    int get hashCode =>
        type.hashCode +
        version.hashCode;

  factory LegalVersionDto.fromJson(Map<String, dynamic> json) => _$LegalVersionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LegalVersionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum LegalVersionDtoTypeEnum {
@JsonValue(r'terms')
terms(r'terms'),
@JsonValue(r'privacy')
privacy(r'privacy');

const LegalVersionDtoTypeEnum(this.value);

final String value;

@override
String toString() => value;
}



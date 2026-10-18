//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SupportDto {
  /// Returns a new [SupportDto] instance.
  SupportDto({

    required  this.whatsapp,

    required  this.url,
  });

  @JsonKey(
    
    name: r'whatsapp',
    required: true,
    includeIfNull: false,
  )


  final String whatsapp;



  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SupportDto &&
      other.whatsapp == whatsapp &&
      other.url == url;

    @override
    int get hashCode =>
        whatsapp.hashCode +
        url.hashCode;

  factory SupportDto.fromJson(Map<String, dynamic> json) => _$SupportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SupportDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


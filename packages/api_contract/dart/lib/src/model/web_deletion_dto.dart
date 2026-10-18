//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'web_deletion_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class WebDeletionDto {
  /// Returns a new [WebDeletionDto] instance.
  WebDeletionDto({

    required  this.phone,

    required  this.code,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;





    @override
    bool operator ==(Object other) => identical(this, other) || other is WebDeletionDto &&
      other.phone == phone &&
      other.code == code;

    @override
    int get hashCode =>
        phone.hashCode +
        code.hashCode;

  factory WebDeletionDto.fromJson(Map<String, dynamic> json) => _$WebDeletionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WebDeletionDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


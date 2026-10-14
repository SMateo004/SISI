//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_warning_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequestWarningDto {
  /// Returns a new [RequestWarningDto] instance.
  RequestWarningDto({

    required  this.code,

    required  this.message,

    required  this.referenceMinBs,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;



  @JsonKey(
    
    name: r'referenceMinBs',
    required: true,
    includeIfNull: false,
  )


  final String referenceMinBs;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RequestWarningDto &&
      other.code == code &&
      other.message == message &&
      other.referenceMinBs == referenceMinBs;

    @override
    int get hashCode =>
        code.hashCode +
        message.hashCode +
        referenceMinBs.hashCode;

  factory RequestWarningDto.fromJson(Map<String, dynamic> json) => _$RequestWarningDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RequestWarningDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


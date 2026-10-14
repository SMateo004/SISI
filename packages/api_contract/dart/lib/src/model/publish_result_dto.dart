//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/request_dto.dart';
import 'package:sisi_api/src/model/request_warning_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'publish_result_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PublishResultDto {
  /// Returns a new [PublishResultDto] instance.
  PublishResultDto({

    required  this.request,

    required  this.warnings,

    required  this.held,

    required  this.message,
  });

  @JsonKey(
    
    name: r'request',
    required: true,
    includeIfNull: false,
  )


  final RequestDto request;



  @JsonKey(
    
    name: r'warnings',
    required: true,
    includeIfNull: false,
  )


  final List<RequestWarningDto> warnings;



      /// Quedó retenida para revisión (R3.3)
  @JsonKey(
    
    name: r'held',
    required: true,
    includeIfNull: false,
  )


  final bool held;



  @JsonKey(
    
    name: r'message',
    required: true,
    includeIfNull: false,
  )


  final String message;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PublishResultDto &&
      other.request == request &&
      other.warnings == warnings &&
      other.held == held &&
      other.message == message;

    @override
    int get hashCode =>
        request.hashCode +
        warnings.hashCode +
        held.hashCode +
        message.hashCode;

  factory PublishResultDto.fromJson(Map<String, dynamic> json) => _$PublishResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PublishResultDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


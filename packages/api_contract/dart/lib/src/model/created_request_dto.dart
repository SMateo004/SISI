//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/request_dto.dart';
import 'package:sisi_api/src/model/request_warning_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'created_request_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreatedRequestDto {
  /// Returns a new [CreatedRequestDto] instance.
  CreatedRequestDto({

    required  this.request,

    required  this.warnings,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is CreatedRequestDto &&
      other.request == request &&
      other.warnings == warnings;

    @override
    int get hashCode =>
        request.hashCode +
        warnings.hashCode;

  factory CreatedRequestDto.fromJson(Map<String, dynamic> json) => _$CreatedRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedRequestDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


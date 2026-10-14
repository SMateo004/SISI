//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error_body.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApiErrorBody {
  /// Returns a new [ApiErrorBody] instance.
  ApiErrorBody({

    required  this.statusCode,

    required  this.code,

    required  this.message,
  });

  @JsonKey(
    
    name: r'statusCode',
    required: true,
    includeIfNull: false,
  )


  final num statusCode;



      /// Código estable para la app
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApiErrorBody &&
      other.statusCode == statusCode &&
      other.code == code &&
      other.message == message;

    @override
    int get hashCode =>
        statusCode.hashCode +
        code.hashCode +
        message.hashCode;

  factory ApiErrorBody.fromJson(Map<String, dynamic> json) => _$ApiErrorBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorBodyToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


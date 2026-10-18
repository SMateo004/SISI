//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mode_denied_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModeDeniedDto {
  /// Returns a new [ModeDeniedDto] instance.
  ModeDeniedDto({

    required  this.statusCode,

    required  this.code,

    required  this.message,

    required  this.nextAction,

    required  this.actionLabel,
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



  @JsonKey(
    
    name: r'nextAction',
    required: true,
    includeIfNull: false,
  )


  final ModeDeniedDtoNextActionEnum nextAction;



  @JsonKey(
    
    name: r'actionLabel',
    required: true,
    includeIfNull: false,
  )


  final String actionLabel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ModeDeniedDto &&
      other.statusCode == statusCode &&
      other.code == code &&
      other.message == message &&
      other.nextAction == nextAction &&
      other.actionLabel == actionLabel;

    @override
    int get hashCode =>
        statusCode.hashCode +
        code.hashCode +
        message.hashCode +
        nextAction.hashCode +
        actionLabel.hashCode;

  factory ModeDeniedDto.fromJson(Map<String, dynamic> json) => _$ModeDeniedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModeDeniedDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ModeDeniedDtoNextActionEnum {
@JsonValue(r'COMPLETE_VERIFICATION')
COMPLETE_VERIFICATION(r'COMPLETE_VERIFICATION'),
@JsonValue(r'VIEW_REVIEW_STATUS')
VIEW_REVIEW_STATUS(r'VIEW_REVIEW_STATUS'),
@JsonValue(r'RESUBMIT_VERIFICATION')
RESUBMIT_VERIFICATION(r'RESUBMIT_VERIFICATION'),
@JsonValue(r'PAY_COMMISSION')
PAY_COMMISSION(r'PAY_COMMISSION'),
@JsonValue(r'CONTACT_SUPPORT')
CONTACT_SUPPORT(r'CONTACT_SUPPORT'),
@JsonValue(r'COMPLETE_PROFILE')
COMPLETE_PROFILE(r'COMPLETE_PROFILE');

const ModeDeniedDtoNextActionEnum(this.value);

final String value;

@override
String toString() => value;
}



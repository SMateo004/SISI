//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'send_message_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SendMessageDto {
  /// Returns a new [SendMessageDto] instance.
  SendMessageDto({

    required  this.body,
  });

  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SendMessageDto &&
      other.body == body;

    @override
    int get hashCode =>
        body.hashCode;

  factory SendMessageDto.fromJson(Map<String, dynamic> json) => _$SendMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


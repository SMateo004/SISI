//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatMessageDto {
  /// Returns a new [ChatMessageDto] instance.
  ChatMessageDto({

    required  this.id,

    required  this.jobId,

    required  this.senderId,

    required  this.mine,

    required  this.body,

    required  this.status,

    required  this.readAt,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'jobId',
    required: true,
    includeIfNull: false,
  )


  final String jobId;



  @JsonKey(
    
    name: r'senderId',
    required: true,
    includeIfNull: false,
  )


  final String senderId;



      /// Lo envié yo
  @JsonKey(
    
    name: r'mine',
    required: true,
    includeIfNull: false,
  )


  final bool mine;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



      /// retenido = no se entregó (moderación); solo lo ve quien lo envió
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final ChatMessageDtoStatusEnum status;



  @JsonKey(
    
    name: r'readAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? readAt;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ChatMessageDto &&
      other.id == id &&
      other.jobId == jobId &&
      other.senderId == senderId &&
      other.mine == mine &&
      other.body == body &&
      other.status == status &&
      other.readAt == readAt &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        jobId.hashCode +
        senderId.hashCode +
        mine.hashCode +
        body.hashCode +
        status.hashCode +
        (readAt == null ? 0 : readAt.hashCode) +
        createdAt.hashCode;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) => _$ChatMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// retenido = no se entregó (moderación); solo lo ve quien lo envió
enum ChatMessageDtoStatusEnum {
@JsonValue(r'entregado')
entregado(r'entregado'),
@JsonValue(r'retenido')
retenido(r'retenido');

const ChatMessageDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



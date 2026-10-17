//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sent_message_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SentMessageDto {
  /// Returns a new [SentMessageDto] instance.
  SentMessageDto({

    required  this.id,

    required  this.jobId,

    required  this.senderId,

    required  this.mine,

    required  this.body,

    required  this.status,

    required  this.readAt,

    required  this.createdAt,

    required  this.notice,
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


  final SentMessageDtoStatusEnum status;



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



      /// Aviso neutral para quien envió un mensaje retenido
  @JsonKey(
    
    name: r'notice',
    required: true,
    includeIfNull: true,
  )


  final String? notice;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SentMessageDto &&
      other.id == id &&
      other.jobId == jobId &&
      other.senderId == senderId &&
      other.mine == mine &&
      other.body == body &&
      other.status == status &&
      other.readAt == readAt &&
      other.createdAt == createdAt &&
      other.notice == notice;

    @override
    int get hashCode =>
        id.hashCode +
        jobId.hashCode +
        senderId.hashCode +
        mine.hashCode +
        body.hashCode +
        status.hashCode +
        (readAt == null ? 0 : readAt.hashCode) +
        createdAt.hashCode +
        (notice == null ? 0 : notice.hashCode);

  factory SentMessageDto.fromJson(Map<String, dynamic> json) => _$SentMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SentMessageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// retenido = no se entregó (moderación); solo lo ve quien lo envió
enum SentMessageDtoStatusEnum {
@JsonValue(r'entregado')
entregado(r'entregado'),
@JsonValue(r'retenido')
retenido(r'retenido');

const SentMessageDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}



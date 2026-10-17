//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/chat_message_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_page_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChatPageDto {
  /// Returns a new [ChatPageDto] instance.
  ChatPageDto({

    required  this.items,

    required  this.nextCursor,

    required  this.open,

    required  this.closesAt,

    required  this.unread,
  });

      /// Del más reciente al más antiguo
  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<ChatMessageDto> items;



  @JsonKey(
    
    name: r'nextCursor',
    required: true,
    includeIfNull: true,
  )


  final String? nextCursor;



      /// Se pueden enviar mensajes
  @JsonKey(
    
    name: r'open',
    required: true,
    includeIfNull: false,
  )


  final bool open;



      /// Cuándo pasa a solo lectura (24 h después de terminado o cancelado)
  @JsonKey(
    
    name: r'closesAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? closesAt;



      /// Mensajes de la contraparte sin leer
  @JsonKey(
    
    name: r'unread',
    required: true,
    includeIfNull: false,
  )


  final num unread;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ChatPageDto &&
      other.items == items &&
      other.nextCursor == nextCursor &&
      other.open == open &&
      other.closesAt == closesAt &&
      other.unread == unread;

    @override
    int get hashCode =>
        items.hashCode +
        (nextCursor == null ? 0 : nextCursor.hashCode) +
        open.hashCode +
        (closesAt == null ? 0 : closesAt.hashCode) +
        unread.hashCode;

  factory ChatPageDto.fromJson(Map<String, dynamic> json) => _$ChatPageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatPageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


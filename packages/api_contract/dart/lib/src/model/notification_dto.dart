//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NotificationDto {
  /// Returns a new [NotificationDto] instance.
  NotificationDto({

    required  this.id,

    required  this.type,

    required  this.title,

    required  this.body,

    required  this.route,

    required  this.data,

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
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



      /// Pantalla de la app a abrir
  @JsonKey(
    
    name: r'route',
    required: true,
    includeIfNull: false,
  )


  final String route;



  @JsonKey(
    
    name: r'data',
    required: true,
    includeIfNull: false,
  )


  final Map<String, Object> data;



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
    bool operator ==(Object other) => identical(this, other) || other is NotificationDto &&
      other.id == id &&
      other.type == type &&
      other.title == title &&
      other.body == body &&
      other.route == route &&
      other.data == data &&
      other.readAt == readAt &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        type.hashCode +
        title.hashCode +
        body.hashCode +
        route.hashCode +
        data.hashCode +
        (readAt == null ? 0 : readAt.hashCode) +
        createdAt.hashCode;

  factory NotificationDto.fromJson(Map<String, dynamic> json) => _$NotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


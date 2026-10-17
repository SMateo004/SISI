//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_held_message_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminHeldMessageDto {
  /// Returns a new [AdminHeldMessageDto] instance.
  AdminHeldMessageDto({

    required  this.id,

    required  this.jobId,

    required  this.senderId,

    required  this.body,

    required  this.matches,

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



  @JsonKey(
    
    name: r'body',
    required: true,
    includeIfNull: false,
  )


  final String body;



      /// Términos que coincidieron
  @JsonKey(
    
    name: r'matches',
    required: true,
    includeIfNull: false,
  )


  final Object matches;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminHeldMessageDto &&
      other.id == id &&
      other.jobId == jobId &&
      other.senderId == senderId &&
      other.body == body &&
      other.matches == matches &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        jobId.hashCode +
        senderId.hashCode +
        body.hashCode +
        matches.hashCode +
        createdAt.hashCode;

  factory AdminHeldMessageDto.fromJson(Map<String, dynamic> json) => _$AdminHeldMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminHeldMessageDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


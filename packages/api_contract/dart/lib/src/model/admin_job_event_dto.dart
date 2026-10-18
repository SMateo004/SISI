//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_job_event_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminJobEventDto {
  /// Returns a new [AdminJobEventDto] instance.
  AdminJobEventDto({

    required  this.action,

    required  this.fromStatus,

    required  this.toStatus,

    required  this.actorRole,

    required  this.actorId,

    required  this.note,

    required  this.at,
  });

  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



  @JsonKey(
    
    name: r'fromStatus',
    required: true,
    includeIfNull: false,
  )


  final String fromStatus;



  @JsonKey(
    
    name: r'toStatus',
    required: true,
    includeIfNull: false,
  )


  final String toStatus;



  @JsonKey(
    
    name: r'actorRole',
    required: true,
    includeIfNull: false,
  )


  final AdminJobEventDtoActorRoleEnum actorRole;



  @JsonKey(
    
    name: r'actorId',
    required: true,
    includeIfNull: true,
  )


  final String? actorId;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminJobEventDto &&
      other.action == action &&
      other.fromStatus == fromStatus &&
      other.toStatus == toStatus &&
      other.actorRole == actorRole &&
      other.actorId == actorId &&
      other.note == note &&
      other.at == at;

    @override
    int get hashCode =>
        action.hashCode +
        fromStatus.hashCode +
        toStatus.hashCode +
        actorRole.hashCode +
        (actorId == null ? 0 : actorId.hashCode) +
        (note == null ? 0 : note.hashCode) +
        at.hashCode;

  factory AdminJobEventDto.fromJson(Map<String, dynamic> json) => _$AdminJobEventDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminJobEventDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminJobEventDtoActorRoleEnum {
@JsonValue(r'worker')
worker(r'worker'),
@JsonValue(r'employer')
employer(r'employer'),
@JsonValue(r'system')
system(r'system'),
@JsonValue(r'admin')
admin(r'admin');

const AdminJobEventDtoActorRoleEnum(this.value);

final String value;

@override
String toString() => value;
}



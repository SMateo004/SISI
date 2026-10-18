//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_entry_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditEntryDto {
  /// Returns a new [AuditEntryDto] instance.
  AuditEntryDto({

    required  this.id,

    required  this.adminId,

    required  this.adminName,

    required  this.adminPhone,

    required  this.action,

    required  this.targetType,

    required  this.targetId,

    required  this.before,

    required  this.after,

    required  this.reason,

    required  this.ip,

    required  this.forwardedFor,

    required  this.userAgent,

    required  this.cityId,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'adminId',
    required: true,
    includeIfNull: false,
  )


  final String adminId;



  @JsonKey(
    
    name: r'adminName',
    required: true,
    includeIfNull: true,
  )


  final String? adminName;



  @JsonKey(
    
    name: r'adminPhone',
    required: true,
    includeIfNull: false,
  )


  final String adminPhone;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



  @JsonKey(
    
    name: r'targetType',
    required: true,
    includeIfNull: false,
  )


  final String targetType;



  @JsonKey(
    
    name: r'targetId',
    required: true,
    includeIfNull: false,
  )


  final String targetId;



  @JsonKey(
    
    name: r'before',
    required: true,
    includeIfNull: true,
  )


  final Map<String, Object>? before;



  @JsonKey(
    
    name: r'after',
    required: true,
    includeIfNull: true,
  )


  final Map<String, Object>? after;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: true,
  )


  final String? reason;



  @JsonKey(
    
    name: r'ip',
    required: true,
    includeIfNull: true,
  )


  final String? ip;



  @JsonKey(
    
    name: r'forwardedFor',
    required: true,
    includeIfNull: true,
  )


  final String? forwardedFor;



  @JsonKey(
    
    name: r'userAgent',
    required: true,
    includeIfNull: true,
  )


  final String? userAgent;



  @JsonKey(
    
    name: r'cityId',
    required: true,
    includeIfNull: true,
  )


  final String? cityId;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditEntryDto &&
      other.id == id &&
      other.adminId == adminId &&
      other.adminName == adminName &&
      other.adminPhone == adminPhone &&
      other.action == action &&
      other.targetType == targetType &&
      other.targetId == targetId &&
      other.before == before &&
      other.after == after &&
      other.reason == reason &&
      other.ip == ip &&
      other.forwardedFor == forwardedFor &&
      other.userAgent == userAgent &&
      other.cityId == cityId &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        adminId.hashCode +
        (adminName == null ? 0 : adminName.hashCode) +
        adminPhone.hashCode +
        action.hashCode +
        targetType.hashCode +
        targetId.hashCode +
        (before == null ? 0 : before.hashCode) +
        (after == null ? 0 : after.hashCode) +
        (reason == null ? 0 : reason.hashCode) +
        (ip == null ? 0 : ip.hashCode) +
        (forwardedFor == null ? 0 : forwardedFor.hashCode) +
        (userAgent == null ? 0 : userAgent.hashCode) +
        (cityId == null ? 0 : cityId.hashCode) +
        createdAt.hashCode;

  factory AuditEntryDto.fromJson(Map<String, dynamic> json) => _$AuditEntryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuditEntryDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


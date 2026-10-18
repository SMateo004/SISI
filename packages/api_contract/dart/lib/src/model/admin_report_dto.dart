//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:sisi_api/src/model/reported_user_dto.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_report_dto.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminReportDto {
  /// Returns a new [AdminReportDto] instance.
  AdminReportDto({

    required  this.id,

    required  this.targetType,

    required  this.targetId,

    required  this.reason,

    required  this.status,

    required  this.createdAt,

    required  this.reporterId,

    required  this.reporterName,

    required  this.reporterPhone,

    required  this.targetSummary,

    required  this.note,

    required  this.noteHeld,

    required  this.resolution,

    required  this.reportedUser,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'targetType',
    required: true,
    includeIfNull: false,
  )


  final AdminReportDtoTargetTypeEnum targetType;



  @JsonKey(
    
    name: r'targetId',
    required: true,
    includeIfNull: false,
  )


  final String targetId;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final AdminReportDtoReasonEnum reason;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final AdminReportDtoStatusEnum status;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'reporterId',
    required: true,
    includeIfNull: false,
  )


  final String reporterId;



  @JsonKey(
    
    name: r'reporterName',
    required: true,
    includeIfNull: true,
  )


  final String? reporterName;



  @JsonKey(
    
    name: r'reporterPhone',
    required: true,
    includeIfNull: false,
  )


  final String reporterPhone;



      /// Qué se reportó, en una línea
  @JsonKey(
    
    name: r'targetSummary',
    required: true,
    includeIfNull: false,
  )


  final String targetSummary;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: true,
  )


  final String? note;



  @JsonKey(
    
    name: r'noteHeld',
    required: true,
    includeIfNull: false,
  )


  final bool noteHeld;



  @JsonKey(
    
    name: r'resolution',
    required: true,
    includeIfNull: true,
  )


  final String? resolution;



  @JsonKey(
    
    name: r'reportedUser',
    required: true,
    includeIfNull: false,
  )


  final ReportedUserDto reportedUser;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminReportDto &&
      other.id == id &&
      other.targetType == targetType &&
      other.targetId == targetId &&
      other.reason == reason &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.reporterId == reporterId &&
      other.reporterName == reporterName &&
      other.reporterPhone == reporterPhone &&
      other.targetSummary == targetSummary &&
      other.note == note &&
      other.noteHeld == noteHeld &&
      other.resolution == resolution &&
      other.reportedUser == reportedUser;

    @override
    int get hashCode =>
        id.hashCode +
        targetType.hashCode +
        targetId.hashCode +
        reason.hashCode +
        status.hashCode +
        createdAt.hashCode +
        reporterId.hashCode +
        (reporterName == null ? 0 : reporterName.hashCode) +
        reporterPhone.hashCode +
        targetSummary.hashCode +
        (note == null ? 0 : note.hashCode) +
        noteHeld.hashCode +
        (resolution == null ? 0 : resolution.hashCode) +
        reportedUser.hashCode;

  factory AdminReportDto.fromJson(Map<String, dynamic> json) => _$AdminReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdminReportDtoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminReportDtoTargetTypeEnum {
@JsonValue(r'request')
request(r'request'),
@JsonValue(r'user')
user(r'user'),
@JsonValue(r'chat_message')
chatMessage(r'chat_message'),
@JsonValue(r'job')
job(r'job');

const AdminReportDtoTargetTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


enum AdminReportDtoReasonEnum {
@JsonValue(r'servicios_sexuales')
serviciosSexuales(r'servicios_sexuales'),
@JsonValue(r'drogas')
drogas(r'drogas'),
@JsonValue(r'armas')
armas(r'armas'),
@JsonValue(r'ilegal')
ilegal(r'ilegal'),
@JsonValue(r'inmoral')
inmoral(r'inmoral'),
@JsonValue(r'venta_productos')
ventaProductos(r'venta_productos'),
@JsonValue(r'acoso')
acoso(r'acoso'),
@JsonValue(r'fraude')
fraude(r'fraude'),
@JsonValue(r'no_se_presento')
noSePresento(r'no_se_presento'),
@JsonValue(r'suplantacion')
suplantacion(r'suplantacion'),
@JsonValue(r'otro')
otro(r'otro');

const AdminReportDtoReasonEnum(this.value);

final String value;

@override
String toString() => value;
}


enum AdminReportDtoStatusEnum {
@JsonValue(r'pendiente')
pendiente(r'pendiente'),
@JsonValue(r'valido')
valido(r'valido'),
@JsonValue(r'descartado')
descartado(r'descartado');

const AdminReportDtoStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


